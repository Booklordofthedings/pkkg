![The pkkg logo](pkkg_large.png)
# pkkg - almost a package manager [![The pkkg logo](pkkg_small.png)](https://github.com/Booklordofthedings/pkkg)
Not really a package manager, however it can download dependencies for you.  
May become an actual package manager in the future if the features are added

## usage
- pkkg install *//Downloads all of the required dependencies*
- pkkg help *//Displays a help menu for commands*
- pkkg new *//Creates a new pkk file in the current directoy*
- pkkg add "name" --version 1.0.0 --source "https" *//Adds a new dependency to the current project, using the given name, version and url*

## installation
Compile the project and add the compiled file to the path.  
The compiled files will be in the build/ directory.  
**Release** can also contain already compiled versions of pkkg

## dependencies
This program has no external build dependencies outside of the beef compiler.  
However some other programs are included by code in the souce.
- The TOML parser from the Beefy2D library
- LybCL A commandline parser by Booklordofthedings
- Bofa A configuration parser by Booklordofthedings
