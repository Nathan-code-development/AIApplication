package mono.androidx.dynamicanimation.animation;


public class AnimationHandler_DurationScaleChangeListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		androidx.dynamicanimation.animation.AnimationHandler.DurationScaleChangeListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_register:()Z:GetRegisterHandler:AndroidX.DynamicAnimation.AnimationHandler+IDurationScaleChangeListenerInvoker, Xamarin.AndroidX.DynamicAnimation\n" +
			"n_unregister:()Z:GetUnregisterHandler:AndroidX.DynamicAnimation.AnimationHandler+IDurationScaleChangeListenerInvoker, Xamarin.AndroidX.DynamicAnimation\n" +
			"";
		mono.android.Runtime.register ("AndroidX.DynamicAnimation.AnimationHandler+IDurationScaleChangeListenerImplementor, Xamarin.AndroidX.DynamicAnimation", AnimationHandler_DurationScaleChangeListenerImplementor.class, __md_methods);
	}

	public AnimationHandler_DurationScaleChangeListenerImplementor ()
	{
		super ();
		if (getClass () == AnimationHandler_DurationScaleChangeListenerImplementor.class) {
			mono.android.TypeManager.Activate ("AndroidX.DynamicAnimation.AnimationHandler+IDurationScaleChangeListenerImplementor, Xamarin.AndroidX.DynamicAnimation", "", this, new java.lang.Object[] {  });
		}
	}

	public boolean register ()
	{
		return n_register ();
	}

	private native boolean n_register ();

	public boolean unregister ()
	{
		return n_unregister ();
	}

	private native boolean n_unregister ();

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
