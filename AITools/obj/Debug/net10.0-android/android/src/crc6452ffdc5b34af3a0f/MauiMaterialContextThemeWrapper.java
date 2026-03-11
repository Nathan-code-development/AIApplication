package crc6452ffdc5b34af3a0f;


public class MauiMaterialContextThemeWrapper
	extends android.view.ContextThemeWrapper
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiMaterialContextThemeWrapper, Microsoft.Maui", MauiMaterialContextThemeWrapper.class, __md_methods);
	}

	public MauiMaterialContextThemeWrapper ()
	{
		super ();
		if (getClass () == MauiMaterialContextThemeWrapper.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialContextThemeWrapper, Microsoft.Maui", "", this, new java.lang.Object[] {  });
		}
	}

	public MauiMaterialContextThemeWrapper (android.content.Context p0, android.content.res.Resources.Theme p1)
	{
		super (p0, p1);
		if (getClass () == MauiMaterialContextThemeWrapper.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialContextThemeWrapper, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Content.Res.Resources+Theme, Mono.Android", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public MauiMaterialContextThemeWrapper (android.content.Context p0, int p1)
	{
		super (p0, p1);
		if (getClass () == MauiMaterialContextThemeWrapper.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialContextThemeWrapper, Microsoft.Maui", "Android.Content.Context, Mono.Android:System.Int32, System.Private.CoreLib", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public MauiMaterialContextThemeWrapper (android.content.Context p0)
	{
		super ();
		if (getClass () == MauiMaterialContextThemeWrapper.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiMaterialContextThemeWrapper, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
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
