import SwiftUI

struct SnipingParameters {
    var bookingURL: String
    var cookie: String
    var userAgent: String
}

struct TicketSnipingView: View {
    @State private var bookingURL: String = ""
    @State private var cookie: String = ""
    @State private var userAgent: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                cardView(title: "预订 URL", placeholder: "https://example.com", text: $bookingURL, isMultiline: false)
                cardView(title: "Cookie", placeholder: "输入 Cookie", text: $cookie, isMultiline: true)
                cardView(title: "User-Agent", placeholder: "输入 User-Agent", text: $userAgent, isMultiline: true)
                Button(action: startSniping) {
                    Text("开始抢票")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    private func startSniping() {
        let params = SnipingParameters(bookingURL: bookingURL, cookie: cookie, userAgent: userAgent)
        TicketSniper.startSniping(parameters: params)
    }

    @ViewBuilder
    private func cardView(title: String, placeholder: String, text: Binding<String>, isMultiline: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            if isMultiline {
                TextEditor(text: text)
                    .frame(minHeight: 80)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.3)))
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

