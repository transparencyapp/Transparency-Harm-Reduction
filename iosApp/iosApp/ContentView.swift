import SwiftUI
import shared
import WebKit

struct ContentView: View {

    @State private var selectedOption: String?

    var body: some View {
            NavigationView {
                VStack {
                    WebView(url: "https://mediafiles.botpress.cloud/697af148-5a35-46d1-b017-c1be5192d0d2/webchat/bot.html")
                        .padding(.top, 40)
                        .edgesIgnoringSafeArea(.all)
                }
                .navigationBarItems(trailing:
                    Menu {
                        Button(action: {
                            self.selectedOption = "Help"
                            // Navigate or perform action for Option 1
                        }) {
                            Text("Help")
                        }
                        Button(action: {
                            self.selectedOption = "How do spot kits work?"
                            // Navigate or perform action for Option 2
                        }) {
                            Text("How do spot kits work?")
                        }
                        // Add more buttons for additional options as needed
                    } label: {
                        Image(systemName: "ellipsis.circle") // Menu icon
                            .imageScale(.large)
                    }
                )
                    .background(
                        NavigationLink("", destination: getDestinationForOption(selectedOption), isActive: Binding<Bool>(get: { selectedOption != nil }, set: { _ in selectedOption = nil }))
                    )
                }
            }

        // Function to return destination based on selected option
        func getDestinationForOption(_ option: String?) -> some View {
            switch option {
            case "Help":
                return AnyView(InstructionsView())
            case "How do spot kits work?":
                return AnyView(SpotKitView())
            default:
                return AnyView(EmptyView())
            }
        }
    }


struct InstructionsView: View {
    var body: some View {
                VStack {
                    Spacer(minLength: 40) // Add space at the top to mimic padding
                    TabView {
                        ForEach(0..<5) { index in
                            GeometryReader { geometry in
                                Image("instructions_\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.black)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
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
        .background(Color.black)
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
}

struct SpotKitView_Previews: PreviewProvider {
    static var previews: some View {
        SpotKitView()
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
