import SwiftUI
import shared
import WebKit
import os

struct ContentView: View {

    @State private var selectedOption: String?
    @State public var showInstructions: Bool
    @State private var isLoading: Bool = false

    init() {
        // Check UserDefaults for the key "hasSeenInstructions"
        let hasSeenInstructions = UserDefaults.standard.bool(forKey: "hasSeenInstructions")
        _showInstructions = State(initialValue: !hasSeenInstructions)
    }

    var body: some View {
        NavigationView {
            VStack {
//                if showInstructions {
//                    InstructionsView(showInstructions: $showInstructions)
//                        .padding(.top, 40)
//                        .edgesIgnoringSafeArea(.all)
//                } else {
                    ZStack {
                        WebView(url: "https://cdn.botpress.cloud/webchat/v3.3/shareable.html?configUrl=https://files.bpcontent.cloud/2025/06/10/18/20250610184208-S2WRA6N1.json", isLoading: $isLoading)
                            .padding(.top, 40)
                            .edgesIgnoringSafeArea(.all)
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CustomProgressViewStyle(color: .blue))
                                .scaleEffect(2)
                        }
                    }
//                }
            }
            .navigationBarItems(trailing:
                Menu {
                    Button(action: {
                        self.selectedOption = "App Guide"
                    }) {
                        Text("App Guide")
                    }
                    Button(action: {
                        self.selectedOption = "Spot Kit Guide"
                    }) {
                        Text("Spot Kit Guide")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle") // Menu icon
                        .imageScale(.large)
                }
            )
                .background(
                    NavigationLink("", destination: getDestinationForOption(selectedOption), isActive: Binding<Bool>(get: { selectedOption != nil }, set: { _ in selectedOption = nil }))
                )
            }
            .background(Color(UIColor(hex: "#1A212E")))
        }

        // Function to return destination based on selected option
        func getDestinationForOption(_ option: String?) -> some View {
            switch option {
            case "App Guide":
                return AnyView(InstructionsView(showInstructions:$showInstructions))
            case "Spot Kit Guide":
                return AnyView(SpotKitView())
            default:
                return AnyView(EmptyView())
            }
        }
    }

struct CustomProgressViewStyle: ProgressViewStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(color)
    }
}


struct InstructionsView: View {
    @Binding var showInstructions: Bool
    var body: some View {
                VStack {
                    Spacer(minLength: 40) // Add space at the top to mimic padding
                    TabView {
                        ForEach(0..<5) { index in
                            GeometryReader { geometry in
                                Image("instructions_\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .background(Color(UIColor(hex: "#1A212E")))
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color(UIColor(hex: "#1A212E")))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                if(showInstructions) {
                    Button(action: {
                        // Mark the instructions as seen
                        UserDefaults.standard.set(true, forKey: "hasSeenInstructions")
                        // Hide the instructions view
                        showInstructions = false
                    }) {
                        Text("Got it")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(8)
                    }
                }
    }
}

struct SpotKitView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 40) // Add space at the top to mimic padding
            GeometryReader { geometry in
                Image("how_do_spot_kits_work")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.width)
            }
        }
        .background(Color(UIColor(hex: "#1A212E")))
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Handle navigation actions
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                // Open links in external browser
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.parent.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.parent.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.parent.isLoading = false
            }
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            a = 255
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
            a = 255
        case 8:
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

struct SpotKitView_Previews: PreviewProvider {
    static var previews: some View {
        SpotKitView()
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView(showInstructions: .constant(true))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
