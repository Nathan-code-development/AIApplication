package crc6452ffdc5b34af3a0f;


public class MauiPickerBase
	extends androidx.appcompat.widget.AppCompatEditText
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_getDefaultMovementMethod:()Landroid/text/method/MovementMethod;:GetGetDefaultMovementMethodHandler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiPickerBase, Microsoft.Maui", MauiPickerBase.class, __md_methods);
	}

	public MauiPickerBase (android.content.Context p0)
	{
		super (p0);
		if (getClass () == MauiPickerBase.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiPickerBase, Microsoft.Maui", "Android.Content.Context, Mono.Android", this, new java.lang.Object[] { p0 });
		}
	}

	public MauiPickerBase (android.content.Context p0, android.util.AttributeSet p1)
	{
		super (p0, p1);
		if (getClass () == MauiPickerBase.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiPickerBase, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Util.IAttributeSet, Mono.Android", this, new java.lang.Object[] { p0, p1 });
		}
	}

	public MauiPickerBase (android.content.Context p0, android.util.AttributeSet p1, int p2)
	{
		super (p0, p1, p2);
		if (getClass () == MauiPickerBase.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiPickerBase, Microsoft.Maui", "Android.Content.Context, Mono.Android:Android.Util.IAttributeSet, Mono.Android:System.Int32, System.Private.CoreLib", this, new java.lang.Object[] { p0, p1, p2 });
		}
	}

	public android.text.method.MovementMethod getDefaultMovementMethod ()
	{
		return n_getDefaultMovementMethod ();
	}

	private native android.text.method.MovementMethod n_getDefaultMovementMethod ();

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
