namespace Bofa.Builder;
using System;
using System.Collections;
typealias bb = BofaBuilder;
class BofaBuilder
{
	/*
		Allows users to easily build a bofa file via code
		name, typename, typeindicator, value

		This is really fucking slow, because we are allocating so much
		In a sensible application you wouldnd call this all that much anyways, so I dont care
	*/
	public struct b
	{
		public String Name; //This is always dynamic
		public String Type; //Never dynamic
		public String TypeName; //Only dynamic on custom types
		public String Value; //Dynamic on everything that isnt a array or object
		public Span<b> Members;

		public this(String name, String type, String typeName, String value, Span<b> members)
		{
			Name = name;
			Type = type;
			TypeName = typeName;
			Value = value;
			Members = members;
		}

		public void Cleanup()
		{
			delete Name;
			if(Type == "c")
				delete TypeName;

			if(Type != "a" && Type != "o")
				delete Value;

			for(let e in Members)
			{
				e.Cleanup();
			}
		}

		public void ToString(String toAppend, uint32 depth)
		{
			String toAdd = scope .(scope $"{Type} ");
			toAdd.PadLeft(depth+toAdd.Length,' ');
			if(Type == "c")
				toAdd.Append(scope $"{TypeName} ");
			toAdd.Append(scope $"{Name} ");
			//Every single
			if(Type != "a" && Type != "o") //In this case we can just normally return
			{
				
				if(Type != "t")
					toAdd.Append(scope $"{Value}");
				else
				{
					var en = Value.Split('\n');
					toAdd.Append(en.GetNext());

					for(var e in en)
					{
						toAdd.Append('\n');
						String n = scope .();
						n.PadLeft(depth+1, ' ');
						n.Append("- ");
						n.Append(e);
						toAdd.Append(n);
					}
				}
				

			}
			toAdd.Append('\n');
			if(Type == "a" || Type == "o")
			{
				for(var b in Members)
				{
					b.ToString(toAdd,depth+1);
				}
			}
			toAppend.Append(toAdd);
		}
	}

	private Span<b> values;
	private List<b> valueList = new .();
	public this(params Span<b> input)
	{
		values = input;
	}


	public ~this()
	{
		for(var a in values)
			a.Cleanup();

		for(var a in valueList)
			a.Cleanup();
		delete valueList;
	}

	public override void ToString(String strBuffer)
	{
		for(var a in values)
		{
			a.ToString(strBuffer, 0);
		}
		for(var a in valueList)
		{
			a.ToString(strBuffer, 0);
		}
		if(strBuffer[strBuffer.Length-1] == '\n')
			strBuffer.RemoveFromEnd(1); //There are probably better ways to do this but I dont care
	}

	///Adds a single entry after the creation
	public void Add(b pToAdd)
	{
		valueList.Add(pToAdd);
	}

	public static b Num(StringView name, float number)
	{
		return 	.(new .(name), "n", null, new .(number.ToString(.. scope .())),null);
	}

	public static b Bool(StringView name, bool bool)
	{
		return .(new .(name), "b", null, new .(bool.ToString(.. scope .())),null);
	}

	public static b Line(StringView name, StringView line)
	{
		return .(new .(name), "l", null, new .(line),null);
	}

	public static b BigNum(StringView name, double bigNum)
	{
		return .(new .(name), "bn", null, new .(bigNum.ToString(.. scope .())),null);
	}

	public static b Int(StringView name, int32 number)
	{
		return .(new .(name), "i", null, new .(number.ToString(.. scope .())),null);
	}

	public static b BigInt(StringView name, int64 number)
	{
		return .(new .(name), "bi", null, new .(number.ToString(.. scope .())),null);
	}

	public static b Text(StringView name, StringView text)
	{
		return .(new .(name),"t", null, new .(text),null);
	}

	public static b Custom(StringView name, StringView type, StringView value)
	{
		return .(new .(name), "c",new .(type), new .(value), null);
	}

	public static b Object(StringView name, params Span<b> input)
	{
		return .(new .(name), "o", null,null,input);
	}

	public static b Array(StringView name, params Span<b> input)
	{
		return .(new .(name), "a", null,new .(""),input);
	}


	//Array functions, that dont take a name
	public static b NumA(float value)
	{
		return Num("-", value);
	}
	public static b BoolA(bool value)
	{
		return Bool("-", value);
	}
	public static b LineA(StringView value)
	{
		return Line("-", value);
	}
	public static b BigNumA(double value)
	{
		return BigNum("-", value);
	}
	public static b IntA(int32 value)
	{
		return Int("-", value);
	}
	public static b BigIntA(int64 value)
	{
		return BigInt("-", value);
	}
	public static b TextA(StringView value)
	{
		return Text("-", value);
	}
	public static b CustomA(StringView type, StringView value)
	{
		return Custom("-", type, value);
	}
	public static b ObjectA(params Span<b> input)
	{
		return .("-", "o", null, null, input);
	}
	public static b ArrayA(params Span<b> input)
	{
		return .("-", "a", null, null, input);
	}

	[Test]
	public static void Test()
	{
		BofaBuilder builder = scope .(
			bb.Num("Number",123),
			bb.Custom("farbe", "color", "255 0 255"),
			bb.Text("Text", "multi \nLine"),
			bb.Object( "obj",
				bb.Num("SubObject", 123)
				)
			);
		Console.WriteLine(builder.ToString(.. scope .()));
	}
}