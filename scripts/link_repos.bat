@echo off
setlocal enableextensions enabledelayedexpansion

REM Git repo link
REM SSH URL allowed but will be converted to HTTP URL
set REPO=%1

REM Path to internal repo to create
set IPATH=%2

REM Optional path to external repo to create soft link too
set EPATH=%3

REM Dummy variable for subroutine return values 
set RVAL=
REM Getting current path in case of error
set CDIR=%cd%
call :repo_to_ssh %REPO%
set REPO=%RVAL%



REM Checking if internal path exists and if it does, check if path is a git repo
call :isdir %IPATH%
if %RVAL% (
	call :check_repo %IPATH% %REPO%
	exit /b
)

REM If internal path does not exist, cloning repo or create soft link to external repo
if not defined EPATH (
	call :isdir %IPATH%
	if not %RVAL% (
		echo "Cloning repo"
		git clone %REPO% %IPATH%	
	)
) else (
	echo "Creating soft link to local repo"
	if %RVAL% call :check_repo %EPATH% %REPO%  
	mklink /D %IPATH% %EPATH%
)

exit /b
REM End of main subroutine

:isdir 
	set ATTR=%~a1
	set DIRATTR=%ATTR:~0,1%
	if "%DIRATTR%"=="d" (set RVAL=1==1) else (set RVAL=1==2)
	exit /b

REM Convert Github URL SSH to HTTPS
:repo_to_ssh
	set TREPO=%1
	if not "%TREPO:~-4%" == ".git" set TREPO=%TREPO%.git
	
	if "%TREPO:~0,14%" == "git@github.com" (
		set RVAL=%TREPO%
		exit /b
	)
	
	if not "%TREPO:~0,5%" == "https" (
		echo "FATAL: Repo URL '%TREPO%' does not appear to be a valid link^^!^^!^^!"
		goto :error
	)
	
	for /F "tokens=1,2 delims=/" %%a in ("%TREPO:~19%") do (
	   set RVAL=git@github.com:%%a/%%b
	)

	exit /b
	
REM Function for checking if repo at path is a valid repo	
:check_repo

	set RPATH=%1
	set REPO=%2
	set VAL=cvg
	
	
	REM Checking if directory at path is a git repo
	call :isdir %RPATH%\.git
	if not %RVAL% (
		echo FATAL: Path '%RPATH%' is not a git repo^^!^^!^^!
		goto :error
	)
	
	REM Checking repos at path is same as specified

	cd %RPATH% 
	for /f "delims=" %%A in ('git remote get-url origin') do set "REPO_AT_PATH=%%A"
	call :repo_to_ssh %REPO_AT_PATH%
	set REPO_AT_PATH=%RVAL%

	if not "%REPO_AT_PATH%" == "%REPO%" (
		echo FATAL: Repo at path '%RPATH%' does not match specified repo^^!^^!^^! Expected '%REPO%', got '%REPO_AT_PATH%'.
		goto :error
	)
	
	REM Checking if repo is up-to-date
	set UPDATE=1==1
	for /f "delims=" %%A in ('git status -uno') do (
		set VAL=%%A
		set VAL=!VAL:~0,30!
		if "!VAL!" == "Your branch is up to date with" (
			set UPDATE=1==2
			goto :endloop	
		)
	) 
:endloop	

	REM Asking to update repo if necessary 
	if %UPDATE% (
		set /p "RESPONSE=Local repo is not up to date. Do you to pull latest update [Y/N]?"

		echo !RESPONSE!

		if "!RESPONSE!" == "Y" goto :update
		if "!RESPONSE!" == "y" goto :update
		if "!RESPONSE!" == "N" goto :noupdate
		if "!RESPONSE!" == "n" goto :noupdate
		
		echo FATAL: Invalid response^^!^^!^^!
		goto :error
		
	)
	
:endupdate	
	cd %CDIR%	
	exit /b
	
:update
		echo "Fetching latest repo version"
		git fetch origin
		git pull
		goto :endupdate

:noupdate
		echo "Using current repo version"
		goto :endupdate

:error
	cd %CDIR%
	exit /b 1