import SwiftUI
import shared
import WebKit

struct ContentView: View {
    var body: some View {
        WebView(url: "https://mediafiles.botpress.cloud/697af148-5a35-46d1-b017-c1be5192d0d2/webchat/bot.html")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

//     func makeCoordinator() -> Coordinator {
//             return Coordinator()
//         }
//
//     class Coordinator: NSObject, WKNavigationDelegate {
//         // Handle navigation actions
//         func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//             // Allow all navigation actions
//             decisionHandler(.allow)
//         }
//     }
}