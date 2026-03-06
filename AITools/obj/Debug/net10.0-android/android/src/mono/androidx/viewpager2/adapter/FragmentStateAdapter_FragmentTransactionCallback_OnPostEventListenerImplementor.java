package mono.androidx.viewpager2.adapter;


public class FragmentStateAdapter_FragmentTransactionCallback_OnPostEventListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		androidx.viewpager2.adapter.FragmentStateAdapter.FragmentTransactionCallback.OnPostEventListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onPost:()V:GetOnPostHandler:AndroidX.ViewPager2.Adapter.FragmentStateAdapter+FragmentTransactionCallback+IOnPostEventListenerInvoker, Xamarin.AndroidX.ViewPager2\n" +
			"";
		mono.android.Runtime.register ("AndroidX.ViewPager2.Adapter.FragmentStateAdapter+FragmentTransactionCallback+IOnPostEventListenerImplementor, Xamarin.AndroidX.ViewPager2", FragmentStateAdapter_FragmentTransactionCallback_OnPostEventListenerImplementor.class, __md_methods);
	}

	public FragmentStateAdapter_FragmentTransactionCallback_OnPostEventListenerImplementor ()
	{
		super ();
		if (getClass () == FragmentStateAdapter_FragmentTransactionCallback_OnPostEventListenerImplementor.class) {
			mono.android.TypeManager.Activate ("AndroidX.ViewPager2.Adapter.FragmentStateAdapter+FragmentTransactionCallback+IOnPostEventListenerImplementor, Xamarin.AndroidX.ViewPager2", "", this, new java.lang.Object[] {  });
		}
	}

	public void onPost ()
	{
		n_onPost ();
	}

	private native void n_onPost ();

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
