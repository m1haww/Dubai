import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let url: String
    let parkName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        // Enable cloud storage interaction
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        print("🌐 WebView loading URL: \(url)")
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("❌ Failed to create URL from string: \(url)")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            // Handle tel: links
            if url.scheme == "tel" {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                decisionHandler(.cancel)
                return
            }
            
            // Handle external links (open in Safari)
            if !isValidDomain(url) && navigationAction.navigationType == .linkActivated {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                decisionHandler(.cancel)
                return
            }
            
            // Allow navigation within allowed domain
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Enable cloud storage features after page loads
            let script = """
                // Enable cloud storage APIs
                if (navigator.storage && navigator.storage.persist) {
                    navigator.storage.persist().then(function(persistent) {
                        console.log('Persistent storage:', persistent);
                    });
                }
            """
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
        
        private func isValidDomain(_ url: URL) -> Bool {
            guard let host = url.host else { return false }
            return host.contains("dubaiparks.click") || host.contains("domen.com") || host.contains("yourdomain.com")
        }
    }
}