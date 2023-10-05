namespace pkkg;
using LybCL;
using System;
using Bofa;
using Bofa.Builder;
using System.IO;
class Add
{
	public this(CommandLine p)
	{
		var resName = p.getArgument(0);
		if(resName case .Err)
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				No name argument seems to be provided
				-------------------------------------
				""");
		}

		//Lets hope this works
		String version = p.getParameter("version") case .Ok(let val) ? scope .(val) : scope .("1.0.0");

		var resSource = p.getParameter("source");
		if(resSource case .Err)
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				No source is provided
				-------------------------------------
				""");
			return;
		}

		String data = scope .();
		var pkkg = File.ReadAllText(".pkkg", data);
		if(pkkg case .Err)
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				Error while reading the local package file, maybe its missing ?
				-------------------------------------
				""");
			return;
		}

		/*
			We are not actually parsing anything here,
			and im fine w that tbh
		*/

		data.Append("\n");
		data.Append(scope $"""
			 o -
			  l name {resName.Value}
			  c ver Version {version}
			  l source {resSource.Value}
			""");

		var resWrite = File.WriteAllText(".pkkg", data);
 		if(resWrite case .Err)
		{
			Console.WriteLine("""
				pkkg - Almost a package manager
				error--------------------------------
				Error while writing to the config file
				-------------------------------------
				""");
			return;
		}
	}

}