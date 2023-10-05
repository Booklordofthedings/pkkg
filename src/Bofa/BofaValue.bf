namespace Bofa;
using System;
using System.Collections;
[Union]
struct BofaValue
{
	public float Number;
	public double BigNumber;
	public int32 Integer;
	public int64 BigInteger;
	public bool Boolean;
	public StringView Line;
	public StringView Custom;
	public String Text;
	public Dictionary<StringView, Bofa> Object = null;
	public List<Bofa> Array = null;
}