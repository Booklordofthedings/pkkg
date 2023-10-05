namespace pkkg;
using System;
using System.Collections;
using System.Text;

/* DisposeProxy - Beefy2D
	Type Required by StructuredData to work
	Source: https://github.com/beefytech/Beef
*/

public delegate void DisposeProxyDelegate();

public class DisposeProxy : IDisposable
{
	public DisposeProxyDelegate mDisposeProxyDelegate;

	public this(DisposeProxyDelegate theDelegate = null)
	{
		mDisposeProxyDelegate = theDelegate;
	}

	public ~this()
	{
		delete mDisposeProxyDelegate;
	}

	public void Dispose()
	{
		mDisposeProxyDelegate();
	}
}