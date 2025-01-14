# FUNWAVE-TVD Github Page

[Sphinx](https://www.sphinx-doc.org/en/master/index.html) source files for generating [FUNWAVE-TVD](https://github.com/fengyanshi/FUNWAVE-TVD) documentation and publishing to Git Pages. 

## Workflow
 
### Repository Structure  
Sphinx source files and the build system are contained in the master branch. HTML files generated by Sphinx are contained in the gh-pages branch.

### Publishing Git Pages
HTML files are generated via Sphinx using a Git Action and are triggered when commits are pushed to the master branch. The Git Action automatically generates the HTML files and pushes the changes to the gh-pages branch. 

## Development
Sphinx source files are contained inside the src directory 

### Build System
A local version of the HTML source files may be generated using the Makefile on Linux/MacOS systems (with bash support) or with Windows Shell using the make.bat file on Windows systems. 

**_NOTE:_** This guide will use examples on Linux/MacOS via the Makefile. Windows systems may run the same commands by replacing make with make.bat.

### Installing Prerequisites
Ensure all required Python packages are installed to build the HTML source files using the following command in the terminal (or Windows Shell) while in the root repository path.

```
make install_requirements
```

It is recommended that a Conda Environment or Python Virtual Environment is used and activated before installing the prerequisites.

### [Optional] Setting up External Repositories  
The Sphinx source files depend on two external repositories: [FUNWAVE-TVD](https://github.com/fengyanshi/FUNWAVE-TVD) and [FUNWAVE-TVD Python Toolbox](https://github.com/mayhl/FUNWAVE-TVD-Python-Tools) [Under Development]. By default, this build system will clone a local copy of the repositories in a new folder named external. If local copies of the repositories already exist on the system, they may be linked to the build system. 

To link the existing repositories, using your favorite text editor, modify the Makefile and set the following variables 

```
FUNWAVE_PATH=Path/to/FUNWAVE-TVD_repository
FUNTOOL_PATH=Path/to/FUNWAVE-TVD_Python_Toolbox_repository
```
 
For Windows systems, modify the make.bat file and set the following variables.

```
set FUNWAVE_PATH=Path/to/FUNWAVE-TVD_repository
set FUNTOOL_PATH=Path/to/FUNWAVE-TVD_Python_Toolbox_repository
```

**_NOTE:_** The build system will create soft links to the paths specified. 

### Referencing Files in External Repositories
Files in the external repositories may be referenced by using relative paths. For files in the FUNWAVE-TVD repository, use

```
external/FUNWAVE/
```

and for the Python Toolbox, use

```
external/FUNTOOL/
```

**_NOTE:_** Repositories must reside in the src directory (the directory containing conf.py) for toc-tree to build correctly with the external repository's Sphinx source files.

### Building HTML Source files using Sphinx 

To create the HTML source files using Sphinx, run the following command.

```
make html
```

HTML source files are created inside the folder 'build'.