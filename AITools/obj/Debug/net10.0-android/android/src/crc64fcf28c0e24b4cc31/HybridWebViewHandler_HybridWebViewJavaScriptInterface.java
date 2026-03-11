package crc64fcf28c0e24b4cc31;


public class HybridWebViewHandler_HybridWebViewJavaScriptInterface
	extends com.microsoft.maui.HybridJavaScriptInterface
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_sendMessage:(Ljava/lang/String;)V:GetSendMessage_Ljava_lang_String_Handler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Handlers.HybridWebViewHandler+HybridWebViewJavaScriptInterface, Microsoft.Maui", HybridWebViewHandler_HybridWebViewJavaScriptInterface.class, __md_methods);
	}

	public HybridWebViewHandler_HybridWebViewJavaScriptInterface ()
	{
		super ();
		if (getClass () == HybridWebViewHandler_HybridWebViewJavaScriptInterface.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Handlers.HybridWebViewHandler+HybridWebViewJavaScriptInterface, Microsoft.Maui", "", this, new java.lang.Object[] {  });
		}
	}

@android.webkit.JavascriptInterface
	public void sendMessage (java.lang.String p0)
	{
		n_sendMessage (p0);
	}

	private native void n_sendMessage (java.lang.String p0);

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
