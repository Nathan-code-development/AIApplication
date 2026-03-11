package crc6452ffdc5b34af3a0f;


public class MauiTextView
	extends com.microsoft.maui.PlatformAppCompatTextView
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onLayoutFormatted:(ZIIII)V:GetOnLayoutFormatted_ZIIIIHandler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiTextView, Microsoft.Maui", MauiTextView.class, __md_methods);
	}

	public MauiTextView (android.content.Context p0)
	{
		super (p0);
		if (getClass () == MauiTextView.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiTextView, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public void onLayoutFormatted (boolean p0, int p1, int p2, int p3, int p4)
	{
		n_onLayoutFormatted (p0, p1, p2, p3, p4);
	}

	private native void n_onLayoutFormatted (boolean p0, int p1, int p2, int p3, int p4);

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
