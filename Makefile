# Minimal makefile for Sphinx documentation
#

# Git repo urls
# NOTE: HTTPS and SSH are considered to be different
FUNWAVE_REPO="https://github.com/fengyanshi/FUNWAVE-TVD.git"
FUNTOOL_REPO="git@github.com:mayhl/FUNWAVE-TVD-Python-Tools.git"

# Optional paths to local repos to use instead of cloning 
# NOTE: HTTPS and SSH are considered to be different; therefore,
#       ensure above urls match urls at paths 
#       (e.g. 'git remote get-url origin' while in repo path)  
FUNWAVE_PATH=
FUNTOOL_PATH=

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = funwave
SOURCEDIR     = src
BUILDDIR      = build

# Paths to 
EPATH=src/external
FUNWAVE_EPATH= $(EPATH)/FUNWAVE
FUNTOOL_EPATH= $(EPATH)/FUNTOOL

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

install_requirements:
	pip3 install -r requirements.txt

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@bash scripts/link_repos.sh ${FUNWAVE_REPO} ${FUNWAVE_EPATH} ${FUNWAVE_PATH}
	@bash scripts/link_repos.sh ${FUNTOOL_REPO} ${FUNTOOL_EPATH} ${FUNTOOL_PATH}
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	cp css/* $(BUILDDIR)/html/_static/
