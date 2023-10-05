namespace pkkg;
using System;
/* Help - pkkg
	Explains how this work in the console
*/
class Help
{
	public this()
	{
		Console.WriteLine(scope $"""
			pkkg - Almost a package manager
			info---------------------------------
			author: Booklordofthedings
			version: {Program.VERSION_MAJOR}.{Program.VERSION_MINOR}.{Program.VERSION_PATCH}
			desc: Download dependencies of packages
			commands-----------------------------
			help <- displays this 
			new <- Creates a new config file in the current folder
			install <- loads all dependencies of the config file in the current folder
			add --name [name] --source [link to repo]
			-------------------------------------
			""");
		Console.Read();
	}
}