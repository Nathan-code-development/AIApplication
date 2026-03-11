package crc6439358991bbf5dbbd;


public class DrawableContainer
	extends androidx.appcompat.graphics.drawable.DrawableContainerCompat
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("AndroidX.AppCompat.Graphics.Drawable.DrawableContainer, Xamarin.AndroidX.AppCompat.AppCompatResources", DrawableContainer.class, __md_methods);
	}

	public DrawableContainer ()
	{
		super ();
		if (getClass () == DrawableContainer.class) {
			mono.android.TypeManager.Activate ("AndroidX.AppCompat.Graphics.Drawable.DrawableContainer, Xamarin.AndroidX.AppCompat.AppCompatResources", "", this, new java.lang.Object[] {  });
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
