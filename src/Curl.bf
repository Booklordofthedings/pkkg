namespace pkkg;
using System;
using System.Diagnostics;
class Curl
{
	//We have curl at home
	public this(StringView path, StringView target)
	{
		String command;
#if BF_PLATFORM_LINUX
		Command = scope .(scope $"curl -o {target} {path}");
#elif BF_PLATFORM_WINDOWS
		command = scope .(scope $"powershell.exe curl {path} -o {target}");
#else
		Runtime.FatalError("Platform might not support curl, idk");
#endif

		ProcessStartInfo p = scope .();
		p.SetFileNameAndArguments(command);
		p.UseShellExecute = false;
		SpawnedProcess process = scope SpawnedProcess();
		if (process.Start(p) case .Err)
		{
			Runtime.FatalError("Unable to start SpawnProcess.");
		}
	}
}