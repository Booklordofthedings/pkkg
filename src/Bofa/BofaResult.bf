namespace Bofa;
using System;
using System.Collections;
class BofaResult
{
	/*
		BofaResult contains the result of an interaction with the Bofa Parser Library
		If you parse a String the parser will return a BofaResult Object
		Querying an existing Bofa Result will also return a sub BofaResult
		This exist in order to keep the bofa data objects clean and instead manage access via this class
		It also contains information about wether any one query was sucessfull
	*/
	private bool _isResult = false; //If this is true we dont delete any actual object data
	private String _data = null; //The backing data, needs to be cleared on destruction if set
	private Dictionary<StringView, Bofa> _contents = new Dictionary<StringView, Bofa>(10); //Storage
	private List<Bofa> _result = null;
	private Bofa _lastObject = null; //Keeps track of the last object we have added


	public bool OK { //Keeps track of wether the parsing failed at some point
		public get;
		private set;
	} = true;

	public ~this()
	{ 

		if(_result != null)
			delete _result;

		if(_data != null)
		{
			delete _data;
			for(let i in _contents)
			{
				delete i.value;
			}
		} //We only delete values on the core object in order to not have error with dumb shit

		delete _contents;
	}

	private bool Insert(BofaParser.lineParserResult pResult)
	{ //This is guaranteed to be a valid pResult, because no one would ever call this from somewhere else with different params
		//DONT DO THIS ^

		if(pResult.Bofa.0 > 0 && (_lastObject == null || (_lastObject.Type != .Object && _lastObject.Type != .Array && _lastObject.Type != .Text)))
			return false;

		if(pResult.Bofa.0 > 0)
			if(pResult.IsBofa)
				return _lastObject.[Friend]Insert(pResult.Bofa.0-1, pResult.Bofa.1);
			else
				return _lastObject.[Friend]Insert(pResult.Text.0-1, null, pResult.Text.1);
		//Okay so we really need to add it in on this layer

		if(!pResult.IsBofa)
		{	//For text entries on the current layer
			if(_lastObject.Type != .Text)
				return false;
			_lastObject.Value.Text.Append(scope $"\n{pResult.Text.1}");
			return true;
		}

		let toAdd = pResult.Bofa.1;
		if(_contents.ContainsKey(toAdd.Name))
			return false; //Dublicate name error
		_contents.Add(toAdd.Name, toAdd);
		_lastObject = toAdd;
		return true;
	}

	///Interface functions go here
	public Result<Bofa> this[StringView pValue]
	{
		public get {
			if(!_contents.ContainsKey(pValue))
			 return .Err;
			return _contents[pValue];
		}
	}

	public Result<Bofa> GetByName(StringView pValue)
	{
		return this[pValue];
	}

}