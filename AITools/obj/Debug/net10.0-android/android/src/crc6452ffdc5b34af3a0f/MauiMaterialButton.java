package crc6452ffdc5b34af3a0f;


public class MauiMaterialButton
	extends com.google.android.material.button.MaterialButton
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_getIconGravity:()I:GetGetIconGravityHandler\n" +
			"n_setIconGravity:(I)V:GetSetIconGravity_IHandler\n" +
			"n_onMeasure:(II)V:GetOnMeasure_IIHandler\n" +
			"n_onLayout:(ZIIII)V:GetOnLayout_ZIIIIHandler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiMaterialButton, Microsoft.Maui", MauiMaterialButton.class, __md_methods);
	}

	public MauiMaterialButton (android.content.Context p0)
	{
		super (p0);
		if (getClass () == MauiMaterialButton.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialButton, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public MauiMaterialButton (android.content.Context p0, android.util.AttributeSet p1)
	{
		super (p0, p1);
		if (getClass () == MauiMaterialButton.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialButton, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Util.IAttributeSet, Mono.Android", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public MauiMaterialButton (android.content.Context p0, android.util.AttributeSet p1, int p2)
	{
		super (p0, p1, p2);
		if (getClass () == MauiMaterialButton.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialButton, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Util.IAttributeSet, Mono.Android:System.Int32, System.Private.CoreLib", this, new java.lang.Object[] { p0, p1, p2 });
		}
	}

	public int getIconGravity ()
	{
		return n_getIconGravity ();
	}

	private native int n_getIconGravity ();

	public void setIconGravity (int p0)
	{
		n_setIconGravity (p0);
	}

	private native void n_setIconGravity (int p0);

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
