namespace pkkg;
using System.IO;
using System;
class New
{
	public this()
	{

		if(File.Exists(".pkkg"))
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				A pkkg file already exists in this directory.
				In order to prevent bad things, we dont allow replacing an already existing file.
				If this was done intentionally, just delete the original file and rerun this command
				-------------------------------------
				""");
			return;
		}

		var res = File.WriteAllText(".pkkg", """
			# Pkkg - Almost a package manager
			l name DefaultName
			c ver Version 1.0.0
			l author DefaultAuthor
			a dependencies
			""");

		if(res case .Err)
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				An error occured while trying to create a .pkkg file
				-------------------------------------
				""");
		}
	}
}