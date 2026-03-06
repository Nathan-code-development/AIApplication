package crc6452ffdc5b34af3a0f;


public class FragmentManagerExtensions_CallBacks
	extends androidx.fragment.app.FragmentManager.FragmentLifecycleCallbacks
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onFragmentDestroyed:(Landroidx/fragment/app/FragmentManager;Landroidx/fragment/app/Fragment;)V:GetOnFragmentDestroyed_Landroidx_fragment_app_FragmentManager_Landroidx_fragment_app_Fragment_Handler\n" +
			"n_onFragmentResumed:(Landroidx/fragment/app/FragmentManager;Landroidx/fragment/app/Fragment;)V:GetOnFragmentResumed_Landroidx_fragment_app_FragmentManager_Landroidx_fragment_app_Fragment_Handler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.FragmentManagerExtensions+CallBacks, Microsoft.Maui", FragmentManagerExtensions_CallBacks.class, __md_methods);
	}

	public FragmentManagerExtensions_CallBacks ()
	{
		super ();
		if (getClass () == FragmentManagerExtensions_CallBacks.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.FragmentManagerExtensions+CallBacks, Microsoft.Maui", "", this, new java.lang.Object[] {  });
		}
	}

	public void onFragmentDestroyed (androidx.fragment.app.FragmentManager p0, androidx.fragment.app.Fragment p1)
	{
		n_onFragmentDestroyed (p0, p1);
	}

	private native void n_onFragmentDestroyed (androidx.fragment.app.FragmentManager p0, androidx.fragment.app.Fragment p1);

	public void onFragmentResumed (androidx.fragment.app.FragmentManager p0, androidx.fragment.app.Fragment p1)
	{
		n_onFragmentResumed (p0, p1);
	}

	private native void n_onFragmentResumed (androidx.fragment.app.FragmentManager p0, androidx.fragment.app.Fragment p1);

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
