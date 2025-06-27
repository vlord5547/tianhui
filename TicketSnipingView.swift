import SwiftUI

struct SniperParameters {
    let url: String
    let cookie: String
    let userAgent: String
    let onUpdate: (String) -> Void
}

class TicketSniper {
    static func startSniping(parameters: SniperParameters) {
        parameters.onUpdate("准备发送请求")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            parameters.onUpdate("预订请求已发出")
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                parameters.onUpdate("确认请求中")
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    parameters.onUpdate("到达支付页面，等待人工付款")
                }
            }
        }
    }
}

struct TicketSnipingView: View {
    @State private var bookingURL: String = ""
    @State private var cookie: String = ""
    @State private var userAgent: String = ""
    @State private var status: String = "等待用户输入"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                inputSection(title: "预订 URL") {
                    TextField("https://example.com", text: $bookingURL)
                        .textFieldStyle(.roundedBorder)
                }

                inputSection(title: "Cookie") {
                    TextEditor(text: $cookie)
                        .frame(minHeight: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                }

                inputSection(title: "User-Agent") {
                    TextEditor(text: $userAgent)
                        .frame(minHeight: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                }

                inputSection(title: "当前状态：") {
                    Text(status)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: startSniping) {
                    Text("开始抢票")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }

    private func inputSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }

    private func startSniping() {
        status = "正在请求..."
        let params = SniperParameters(url: bookingURL, cookie: cookie, userAgent: userAgent) { message in
            DispatchQueue.main.async {
                self.status = message
            }
        }
        TicketSniper.startSniping(parameters: params)
    }
}

#Preview {
    TicketSnipingView()
}
