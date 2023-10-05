namespace Bofa;
using System;
class Bofa
{
	public eBofaType Type;
	public StringView TypeName;
	public StringView Name;
	public BofaValue Value;

	private Bofa LastObject = null;

	public ~this()
	{

		if(Type == .Text)
			delete Value.Text;
		else if(Type == .Object && Value.Object != null)
			DeleteDictionaryAndValues!(Value.Object);
		else if(Type == .Array && Value.Array != null)
			DeleteContainerAndItems!(Value.Array);
	}

	private bool Insert(uint32 depth, Bofa toInsert, StringView toAdd = "")
	{
		if(depth > 0 && (LastObject == null || (LastObject.Type != .Array && LastObject.Type != .Object && LastObject.Type != .Text)))
			return false;

		if(depth > 0)
		{
			return LastObject.Insert(depth-1, toInsert, toAdd);
		}
		//Actually insert it now
		switch(Type)
		{
		case .Text:
			Value.Text.Append(scope $"\n{toAdd}");
		case .Array:
			Value.Array.Add(toInsert);
		case .Object:
			if(Value.Object.ContainsKey(toInsert.Name))
				return false; //Error
			Value.Object.Add(toInsert.Name, toInsert);
		default:
			return false;
		}
		LastObject = toInsert;
		return true;
	}


	//Finding specific entries easier
	public Result<Bofa> this[StringView name]
	{
		public get {
			if(Type != .Object)
				return .Err;
			if(!Value.Object.ContainsKey(name))
				return .Err;
			return .Ok(Value.Object[name]);
		}
	}

	public Result<Bofa> this[uint32 number]
	{
		public get {
			if(Type != .Array)
				return .Err;
			if(Value.Array.Count <= number)
				return .Err;
			return Value.Array[number];
		}
	}

	public static mixin GetValueOrDefault<T>(Result<T> result, T dfault)
	{
		result case .Err ? dfault : result
	}
}