@ECHO OFF

REM Git repo urls
set FUNWAVE_REPO=https://github.com/fengyanshi/FUNWAVE-TVD.git
set FUNTOOL_REPO=git@github.com:mayhl/FUNWAVE-TVD-Python-Tools.git

REM Optional paths to local repos to use instead of cloning 
set FUNWAVE_PATH=
set FUNTOOL_PATH=

REM Paths to 
set EPATH=src/external
set FUNWAVE_EPATH=%EPATH%/FUNWAVE
set FUNTOOL_EPATH=%EPATH%/FUNTOOL

pushd %~dp0

REM Command file for Sphinx documentation

if "%SPHINXBUILD%" == "" (
	set SPHINXBUILD=sphinx-build
)
set SOURCEDIR=src
set BUILDDIR= build
set SPHINXPROJ= funwave

if "%1" == "" goto help
if "%1" == "install_requirements" goto install_requirements


%SPHINXBUILD% >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'sphinx-build' command was not found. Make sure you have Sphinx
	echo.installed, then set the SPHINXBUILD environment variable to point
	echo.to the full path of the 'sphinx-build' executable. Alternatively you
	echo.may add the Sphinx directory to PATH.
	echo.
	echo.If you don't have Sphinx installed, grab it from
	echo.http://sphinx-doc.org/
	exit /b 1
)

echo %FUNWAVE_REPO% %FUNWAVE_EPATH% %FUNWAVE_PATH%
call scripts/link_repos.bat %FUNWAVE_REPO% %FUNWAVE_EPATH% %FUNWAVE_PATH%
call scripts/link_repos.bat %FUNTOOL_REPO% %FUNTOOL_EPATH% %FUNTOOL_PATH%
%SPHINXBUILD% -M %1 %SOURCEDIR% %BUILDDIR% %SPHINXOPTS%
copy css\* %BUILDDIR%\html\_static\
goto end

:install_requirements
pip3 install -r requirements.txt
goto end

:help
%SPHINXBUILD% -M help %SOURCEDIR% %BUILDDIR% %SPHINXOPTS%

:end
popd
