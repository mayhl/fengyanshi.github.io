
# Git repo link
# NOTE: SSH URL allowed but will be converted to HTTP URL
REPO=$1

# Path to internal repo to create
IPATH=$2

# Optional path to external repo to create soft link too
EPATH=$3

# Convert Github URL HTTPS to SSH
repo_to_ssh() {
        REPO=$1

	if ! [[ "${REPO}" == *".git" ]]; then
		REPO="${REPO}.git"
	fi 

        if [[ "${REPO}" == "git@github.com"* ]]; then
                echo ${REPO}
                exit 0
        fi

        if ! [[ "${REPO}" == "https"* ]]; then
                echo "FATAL: Repo URL '$REPO' does not appear to be a valid link!!!"
                exit 1
        fi  

        NAME=$(echo ${REPO} | rev | cut -d / -f1 | rev)
        AUTHOR=$(echo ${REPO} | rev | cut -d / -f2 | rev)
        SSH_REPO="git@github.com:${AUTHOR}/${NAME}"
        echo ${SSH_REPO}
}       

# Convert Github URL SSH to HTTPS
repo_to_http() {
        REPO=$1
        if [[ "${REPO}" == "https"* ]]; then
                echo ${REPO}
                exit 0
        fi      
        
        if ! [[ "${REPO}" == "git@github.com"* ]]; then
                echo "FATAL: Repo URL '$REPO' does not appear to be a valid link!!!"
                exit 1
        fi 

        NAME=$(echo ${REPO} | rev | cut -d / -f1 | rev)
        AUTHOR=$(echo ${REPO} | cut -d / -f1 | cut -d : -f2)
        HTML_REPO="https://github.com/${AUTHOR}/${NAME}"
        echo ${HTML_REPO}
}    

# Function for checking if repo at path is a valid repo
check_repo() {

	RPATH=$1	
	REPO=$2

	# Checking if directory at path is a git repo
	if ! [ -d "${RPATH}/.git" ]; then
		echo "FATAL: Path '$RPATH' is not a git repo!!!"
		exit 1
	fi

	# Checking repos at path is same as specified
	CDIR=$(pwd)
	cd ${RPATH} 
	REPO_AT_PATH=$(git remote get-url origin)
	REPO_AT_PATH=$(repo_to_ssh ${REPO_AT_PATH})

	if ! [[ ${REPO} == ${REPO_AT_PATH} ]]; then
		echo "FATAL: Repo at path '${RPATH}' does not match specified repo!!! Expected '${REPO}', got '${REPO_AT_PATH}'."
		exit 1
	fi
	cd ${CDIR}	


	# Checking if repo is up-to-date
	STATUS=$(git status -uno)
	if ! [[ ${STATUS} == *"Your branch is up to date"* ]]; then
		echo "Local repo is not up to date. Do you to pull latest update [Y/N]?"
		read UPDATE

		if [[ "${UPDATE}" == "y" || "${UPDATE}" == "Y" ]]; then
			echo "Fetching latest repo version"
			git fetch origin
			git pull
		elif [[ "${UPDATE}" == "n" || "${UPDATE}" == "N" ]]; then
			echo "Using current repo version"
		else
			echo "FATAL: Invalid response!!!"
			exit 1
		fi

		exit 0
	fi
}


# Always use HTTPS URL when cloning local. SSH URL allowed  when soft linking to local repo
# NOTE: Using HTTPS URL for Github action Bot
REPO=$(repo_to_ssh ${REPO})
echo "Checking repo '${REPO}'"

# Checking if internal path exists and if it does, check if path is a git repo
if [ -d "${IPATH}" ]; then
	check_repo ${IPATH} ${REPO}
fi

# If internal path does not exist, cloning repo or create soft link to external repo 
if [ -z "${EPATH}" ]; then
	if ! [ -d "${IPATH}" ]; then
		echo "Cloning repo ${REPO}"
		git clone ${REPO} ${IPATH}
	fi
else
	echo "Creating soft link to local repo"
	check_repo ${EPATH} ${REPO}
	ln -s ${EPATH} ${IPATH}	
fi
