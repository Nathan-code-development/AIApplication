package crc6452ffdc5b34af3a0f;


public class WrapperView
	extends com.microsoft.maui.PlatformWrapperView
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onLayout:(ZIIII)V:GetOnLayout_ZIIIIHandler\n" +
			"n_dispatchTouchEvent:(Landroid/view/MotionEvent;)Z:GetDispatchTouchEvent_Landroid_view_MotionEvent_Handler\n" +
			"n_getClipPath:(II)Landroid/graphics/Path;:GetGetClipPath_IIHandler\n" +
			"n_getVisibility:()I:GetGetVisibilityHandler\n" +
			"n_setVisibility:(I)V:GetSetVisibility_IHandler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.WrapperView, Microsoft.Maui", WrapperView.class, __md_methods);
	}

	public WrapperView (android.content.Context p0)
	{
		super (p0);
		if (getClass () == WrapperView.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.WrapperView, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public void onLayout (boolean p0, int p1, int p2, int p3, int p4)
	{
		n_onLayout (p0, p1, p2, p3, p4);
	}

	private native void n_onLayout (boolean p0, int p1, int p2, int p3, int p4);

	public boolean dispatchTouchEvent (android.view.MotionEvent p0)
	{
		return n_dispatchTouchEvent (p0);
	}

	private native boolean n_dispatchTouchEvent (android.view.MotionEvent p0);

	public android.graphics.Path getClipPath (int p0, int p1)
	{
		return n_getClipPath (p0, p1);
	}

	private native android.graphics.Path n_getClipPath (int p0, int p1);

	public int getVisibility ()
	{
		return n_getVisibility ();
	}

	private native int n_getVisibility ();

	public void setVisibility (int p0)
	{
		n_setVisibility (p0);
	}

	private native void n_setVisibility (int p0);

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
