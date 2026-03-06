package crc6452ffdc5b34af3a0f;


public class MauiSwipeRefreshLayout
	extends androidx.swiperefreshlayout.widget.SwipeRefreshLayout
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onMeasure:(II)V:GetOnMeasure_IIHandler\n" +
			"n_onLayout:(ZIIII)V:GetOnLayout_ZIIIIHandler\n" +
			"n_canChildScrollUp:()Z:GetCanChildScrollUpHandler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiSwipeRefreshLayout, Microsoft.Maui", MauiSwipeRefreshLayout.class, __md_methods);
	}

	public MauiSwipeRefreshLayout (android.content.Context p0)
	{
		super (p0);
		if (getClass () == MauiSwipeRefreshLayout.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiSwipeRefreshLayout, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public MauiSwipeRefreshLayout (android.content.Context p0, android.util.AttributeSet p1)
	{
		super (p0, p1);
		if (getClass () == MauiSwipeRefreshLayout.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiSwipeRefreshLayout, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Util.IAttributeSet, Mono.Android", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public void onMeasure (int p0, int p1)
	{
		n_onMeasure (p0, p1);
	}

	private native void n_onMeasure (int p0, int p1);

	public void onLayout (boolean p0, int p1, int p2, int p3, int p4)
	{
		n_onLayout (p0, p1, p2, p3, p4);
	}

	private native void n_onLayout (boolean p0, int p1, int p2, int p3, int p4);

	public boolean canChildScrollUp ()
	{
		return n_canChildScrollUp ();
	}

	private native boolean n_canChildScrollUp ();

	private java.util.ArrayList refList;
	public void monodroidAddReference (java.lang.Object obj)
	{
		if (refList == null)
			refList = new java.util.ArrayList ();
		refList.add (obj);
	}

	public void monodroidClearReferences ()
	{
		if (refList != null)
			refList.clear ();
	}
}
