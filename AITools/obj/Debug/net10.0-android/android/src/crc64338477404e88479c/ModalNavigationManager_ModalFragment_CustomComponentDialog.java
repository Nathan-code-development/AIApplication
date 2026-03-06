package crc64338477404e88479c;


public class ModalNavigationManager_ModalFragment_CustomComponentDialog
	extends androidx.activity.ComponentDialog
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onKeyDown:(ILandroid/view/KeyEvent;)Z:GetOnKeyDown_ILandroid_view_KeyEvent_Handler\n" +
			"n_onKeyLongPress:(ILandroid/view/KeyEvent;)Z:GetOnKeyLongPress_ILandroid_view_KeyEvent_Handler\n" +
			"n_onKeyMultiple:(IILandroid/view/KeyEvent;)Z:GetOnKeyMultiple_IILandroid_view_KeyEvent_Handler\n" +
			"n_onKeyShortcut:(ILandroid/view/KeyEvent;)Z:GetOnKeyShortcut_ILandroid_view_KeyEvent_Handler\n" +
			"n_onKeyUp:(ILandroid/view/KeyEvent;)Z:GetOnKeyUp_ILandroid_view_KeyEvent_Handler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Controls.Platform.ModalNavigationManager+ModalFragment+CustomComponentDialog, Microsoft.Maui.Controls", ModalNavigationManager_ModalFragment_CustomComponentDialog.class, __md_methods);
	}

	public ModalNavigationManager_ModalFragment_CustomComponentDialog (android.content.Context p0)
	{
		super (p0);
		if (getClass () == ModalNavigationManager_ModalFragment_CustomComponentDialog.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Controls.Platform.ModalNavigationManager+ModalFragment+CustomComponentDialog, Microsoft.Maui.Controls", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public ModalNavigationManager_ModalFragment_CustomComponentDialog (android.content.Context p0, int p1)
	{
		super (p0, p1);
		if (getClass () == ModalNavigationManager_ModalFragment_CustomComponentDialog.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Controls.Platform.ModalNavigationManager+ModalFragment+CustomComponentDialog, Microsoft.Maui.Controls", "Android.Content.Context, Mono.Android:System.Int32, System.Private.CoreLib", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public boolean onKeyDown (int p0, android.view.KeyEvent p1)
	{
		return n_onKeyDown (p0, p1);
	}

	private native boolean n_onKeyDown (int p0, android.view.KeyEvent p1);

	public boolean onKeyLongPress (int p0, android.view.KeyEvent p1)
	{
		return n_onKeyLongPress (p0, p1);
	}

	private native boolean n_onKeyLongPress (int p0, android.view.KeyEvent p1);

	public boolean onKeyMultiple (int p0, int p1, android.view.KeyEvent p2)
	{
		return n_onKeyMultiple (p0, p1, p2);
	}

	private native boolean n_onKeyMultiple (int p0, int p1, android.view.KeyEvent p2);

	public boolean onKeyShortcut (int p0, android.view.KeyEvent p1)
	{
		return n_onKeyShortcut (p0, p1);
	}

	private native boolean n_onKeyShortcut (int p0, android.view.KeyEvent p1);

	public boolean onKeyUp (int p0, android.view.KeyEvent p1)
	{
		return n_onKeyUp (p0, p1);
	}

	private native boolean n_onKeyUp (int p0, android.view.KeyEvent p1);

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
