namespace Bofa;
using System;
struct BofaParser
{
	public BofaResult Parse(StringView pLine)
	{
		BofaResult toReturn = new .();
		toReturn.[Friend]_data = new String(pLine);
		var enumerator = toReturn.[Friend]_data.Split('\n');
		for(let e in enumerator)
		{ //Loop through each line
			var res = parseLine(e); //Handle the result and do the inserting
			if(res.IsEmpty)
				continue;
			if(!res.Ok)
			{
				toReturn.[Friend]OK = false;
				return toReturn;
			}
			var result = toReturn.[Friend]Insert(res);
			if(result == false)
			{
				toReturn.[Friend]OK = false;
				if(res.IsBofa)
					delete res.Bofa.1;
				return toReturn;
			}
		}
		return toReturn;
	}


	///Atttempts to parse a single line into a bofa object and returns its depth
	private lineParserResult parseLine(StringView pLine)
	{
		StringView line = pLine; //So that we can work on it

#region Depth
		//Get the depth of the line
		uint32 depth = 0;
		var hasContent = false; //In order to check wether it just ran out, or wether we actually have content
		for(var c in line)
		{
			if(c == '	' || c == ' ')
			{
				depth++;
				continue;
			}
			else if(c == '#')
				return .(); //Comment
			hasContent = true;
			break;
		}
		if(!hasContent)
			return .(); //Is empty
		line = .(line, depth);
#endregion

#region Type
		//Get the type of the line
		let type = NextPart(line);
		line = type.1;
		if(type.0 == "") //Shouldnt be empty
			return .();
		else if(type.0 == "-")
			return .(type.1, depth+1);
		//We have now assured, that the object we are handling is seemingly a normal one
		StringView typeName;
		switch(type.0)
		{
		case "c":
			let tnameres = NextPart(line);
			if(tnameres.0 == "")
				return .(false);
			line = tnameres.1;
			typeName = tnameres.0;
		case "n":
			typeName = "Number";
		case "b":
			typeName = "Boolean";
		case "l":
			typeName = "Line";
		case "bn":
			typeName = "BigNumber";
		case "i":
			typeName = "Integer";
		case "bi":
			typeName = "BigInteger";
		case "t":
			typeName = "Text";
		case "a":
			typeName = "Array";
		case "o":
			typeName = "Object";
		default:
			return .(false); //Unsupported type error
		}
#endregion

#region Name
		//Get the name and return if its a array or object
		let nameres = NextPart(line);
		line = nameres.1;
		if(nameres.0 == "")
			return .(false);

		if(type.0 == "o" || type.0 == "a")
		{
			Bofa toReturn = new Bofa();
			toReturn.Name = nameres.0;
			toReturn.TypeName = typeName;
			if(type.0 == "o")
			{
				toReturn.Type = .Object;
				toReturn.Value.Object = new .();
				return .(toReturn, depth);
			}
			toReturn.Type = .Array;
			toReturn.Value.Array = new .();
			return .(toReturn, depth);
		}
#endregion

#region Value
		if(line == "")
			return .(false);
		Bofa toReturn = new .();
		toReturn.Name = nameres.0;
		toReturn.TypeName = typeName;
		switch(type.0)
		{
		case "n":
			toReturn.Type = .Number;
			var result = float.Parse(line);
			if(result case .Err)
			{
				delete toReturn;
				return .(false);
			}
			toReturn.Value.Number = result.Value;
		case "b":
			if(line == "true")
				toReturn.Value.Boolean = true;
			else if(line == "false")
				toReturn.Value.Boolean = false;
			else
			{
				delete toReturn;
				return .(false);
			}
			toReturn.Type = .Boolean;
		case "l":
			toReturn.Value.Line = line;
			toReturn.Type = .Line;
		case "bn":
			toReturn.Type = .BigNumber;
			var result = double.Parse(line);
			if(result case .Err)
			{
				delete toReturn;
				return .(false);
			}
			toReturn.Value.BigNumber = result.Value;
		case "i":
			toReturn.Type = .Integer;
			var result = int32.Parse(line);
			if(result case .Err)
			{
				delete toReturn;
				return .(false);
			}
			toReturn.Value.Integer = result.Value;
		case "bi":
			toReturn.Type = .BigInteger;
			var result = int64.Parse(line);
			if(result case .Err)
			{
				delete toReturn;
				return .(false);
			}
			toReturn.Value.BigInteger = result.Value;
		case "t":
			toReturn.Value.Text = new .(line);
			toReturn.Type = .Text;
		case "c":
			toReturn.Value.Custom = line;
			toReturn.Type = .Custom;
		default:
			delete toReturn;
			return .(false);
		}
#endregion
		//If this ever returns something went wrong
		return .(toReturn,depth);

	}



	private static (StringView, StringView) NextPart(StringView pLine)
	{
		int i = 0;
		for(var c in pLine)
		{
			if(c == ' ')
			{
				if(@c.GetNext() case .Ok(let val))
				{
					i++;
				}
				break;
			}
			i++;
		}
		return (.(pLine, 0, (i < pLine.Length) ? i-1 : i), .(pLine, i));
	}

	public struct lineParserResult
	{ //I hate that this is necessary to handle parseLine, but its just so much data that needs to be moved
		private bool ok = true;
		private bool isEmpty = false;
		private uint32 depth = 0;

		private bool isBofa = true; //Wether this is a bofa or a string extension
		private StringView text = "";
		private Bofa bofa = null;

		public this(bool pIsEmpty = true)
		{ //Either for errors or incase its an empty line
			//the difference is that empty lines should be skipped, while an error would
			if(pIsEmpty)
				isEmpty = true;
			else
				ok = false;
		}

		public this(StringView pText, uint32 pDepth = 0)
		{ //For text addendums
			depth = pDepth;
			isBofa = false;
			text = pText;
		}
		
		public this(Bofa pBofa, uint32 pDepth = 0)
		{ //For normal bofa objects
			depth = pDepth;
			bofa = pBofa;
		}

		public bool Ok
		{
			public get {
				return ok;
			}
		}

		public bool IsEmpty
		{
			public get {
				return isEmpty;
			}
		}

		public bool IsBofa
		{
			public get {
				return isBofa;
			}
		}

		public (uint32, Bofa) Bofa
		{
			public get {
				return (depth, bofa);
			}
		}

		public (uint32, StringView) Text
		{
			public get {
				return (depth, text);
			}
		}

	}

}