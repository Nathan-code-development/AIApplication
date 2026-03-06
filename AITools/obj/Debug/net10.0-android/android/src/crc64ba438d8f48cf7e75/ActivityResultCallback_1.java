package crc64ba438d8f48cf7e75;


public class ActivityResultCallback_1
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		androidx.activity.result.ActivityResultCallback
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onActivityResult:(Ljava/lang/Object;)V:GetOnActivityResult_Ljava_lang_Object_Handler:AndroidX.Activity.Result.IActivityResultCallbackInvoker, Xamarin.AndroidX.Activity\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.ApplicationModel.ActivityResultCallback`1, Microsoft.Maui.Essentials", ActivityResultCallback_1.class, __md_methods);
	}

	public ActivityResultCallback_1 ()
	{
		super ();
		if (getClass () == ActivityResultCallback_1.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.ApplicationModel.ActivityResultCallback`1, Microsoft.Maui.Essentials", "", this, new java.lang.Object[] {  });
		}
	}

	public void onActivityResult (java.lang.Object p0)
	{
		n_onActivityResult (p0);
	}

	private native void n_onActivityResult (java.lang.Object p0);

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
