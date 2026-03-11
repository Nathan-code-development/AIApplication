package crc6452ffdc5b34af3a0f;


public class MauiHybridWebViewClient
	extends android.webkit.WebViewClient
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_shouldInterceptRequest:(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;:GetShouldInterceptRequest_Landroid_webkit_WebView_Landroid_webkit_WebResourceRequest_Handler\n" +
			"";
		mono.android.Runtime.register ("Microsoft.Maui.Platform.MauiHybridWebViewClient, Microsoft.Maui", MauiHybridWebViewClient.class, __md_methods);
	}

	public MauiHybridWebViewClient ()
	{
		super ();
		if (getClass () == MauiHybridWebViewClient.class) {
			mono.android.TypeManager.Activate ("Microsoft.Maui.Platform.MauiHybridWebViewClient, Microsoft.Maui", "", this, new java.lang.Object[] {  });
		}
	}

	public android.webkit.WebResourceResponse shouldInterceptRequest (android.webkit.WebView p0, android.webkit.WebResourceRequest p1)
	{
		return n_shouldInterceptRequest (p0, p1);
	}

	private native android.webkit.WebResourceResponse n_shouldInterceptRequest (android.webkit.WebView p0, android.webkit.WebResourceRequest p1);

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
