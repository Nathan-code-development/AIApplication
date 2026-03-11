package crc6452ffdc5b34af3a0f;


public class MauiMaterialButton_MauiResizableDrawable
	extends android.graphics.drawable.LayerDrawable
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiMaterialButton+MauiResizableDrawable, Microsoft.Maui", MauiMaterialButton_MauiResizableDrawable.class, __md_methods);
	}

	public MauiMaterialButton_MauiResizableDrawable (android.graphics.drawable.Drawable[] p0)
	{
		super (p0);
		if (getClass () == MauiMaterialButton_MauiResizableDrawable.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialButton+MauiResizableDrawable, Microsoft.Maui", "Android.Graphics.Drawables.Drawable[], Mono.Android", this, new java.lang.Object[] { p0 });
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
