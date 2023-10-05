namespace pkkg;
using System;
using System.Diagnostics;
using Bofa;
using System.IO;
class Install
{
	public this()
	{
		if(!Directory.Exists("deps"))
		{
			//Fully erroring doesnt really matter, so well just fatal fail from here
			var data = File.ReadAllText(".pkkg",.. scope .());
			var bofaResult = scope BofaParser().Parse(data);

			var deps = bofaResult.GetByName("dependencies");
			for(var i in deps.Value.Value.Array)
			{
				var name = i.Value.Object["name"];
				var source = i.Value.Object["source"].Value.Line;


				ProcessStartInfo p = scope .();
				p.SetFileNameAndArguments(scope $"git clone {source} repositories/{name.Value.Line}");
				p.UseShellExecute = false;
				SpawnedProcess process = scope SpawnedProcess();
				if (process.Start(p) case .Err)
				{
					Runtime.FatalError("Unable to start SpawnProcess.");
				}
				Console.Clear();
			}
			delete bofaResult;
		}
	}
}