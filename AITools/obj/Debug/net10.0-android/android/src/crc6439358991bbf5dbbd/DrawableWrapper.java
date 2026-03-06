package crc6439358991bbf5dbbd;


public class DrawableWrapper
	extends androidx.appcompat.graphics.drawable.DrawableWrapperCompat
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("AndroidX.AppCompat.Graphics.Drawable.DrawableWrapper, Xamarin.AndroidX.AppCompat.AppCompatResources", DrawableWrapper.class, __md_methods);
	}

	public DrawableWrapper (android.graphics.drawable.Drawable p0)
	{
		super (p0);
		if (getClass () == DrawableWrapper.class) {
			mono.android.TypeManager.Activate ("AndroidX.AppCompat.Graphics.Drawable.DrawableWrapper, Xamarin.AndroidX.AppCompat.AppCompatResources", "Android.Graphics.Drawables.Drawable, Mono.Android", this, new java.lang.Object[] { p0 });
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
