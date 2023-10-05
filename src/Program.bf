namespace pkkg;
using System;
using LybCL;
class Program
{
	public static readonly uint64 VERSION_MAJOR = 1;
	public static readonly uint64 VERSION_MINOR = 0;
	public static readonly uint64 VERSION_PATCH = 0;

	public static void Main(String[] args)
	{
		var commands = scope CommandLine(args);
		String command = scope String(commands.getCommand());
		command.ToLower();
		switch(command)
		{
		case "new":
			scope New();
		case "add":
			 scope Add(commands);
		case "install":
			 scope Install();
		case "help":
			scope Help();
		case "default":
			scope Help();
		default:
			scope Help();
		}
	}
}