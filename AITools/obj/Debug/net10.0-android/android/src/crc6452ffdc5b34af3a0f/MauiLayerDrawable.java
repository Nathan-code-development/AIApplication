package crc6452ffdc5b34af3a0f;


public class MauiLayerDrawable
	extends android.graphics.drawable.LayerDrawable
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiLayerDrawable, Microsoft.Maui", MauiLayerDrawable.class, __md_methods);
	}

	public MauiLayerDrawable (android.graphics.drawable.Drawable[] p0)
	{
		super (p0);
		if (getClass () == MauiLayerDrawable.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiLayerDrawable, Microsoft.Maui", "Android.Graphics.Drawables.Drawable[], Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

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
