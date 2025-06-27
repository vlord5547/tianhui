import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Parameters required for the ticket sniping process.
struct SniperParameters {
    /// URL for the initial booking request.
    let url: String
    /// Cookie header value used for all requests.
    let cookie: String
    /// User-Agent header value used for all requests.
    let userAgent: String
    /// Callback to update UI with the current status.
    let onUpdate: (String) -> Void
}

/// A helper class that executes a simple ticket sniping workflow.
class TicketSniper {
    /// Starts the sniping sequence on a background thread.
    static func startSniping(parameters: SniperParameters) {
        DispatchQueue.global(qos: .background).async {
            // Step 1: send booking request
            parameters.onUpdate("发送预订请求中")
            guard let bookingURL = URL(string: parameters.url) else {
                DispatchQueue.main.async { parameters.onUpdate("预订地址无效") }
                return
            }
            var bookingRequest = URLRequest(url: bookingURL)
            bookingRequest.httpMethod = "POST"
            bookingRequest.setValue(parameters.cookie, forHTTPHeaderField: "Cookie")
            bookingRequest.setValue(parameters.userAgent, forHTTPHeaderField: "User-Agent")
            URLSession.shared.dataTask(with: bookingRequest) { data, _, error in
                DispatchQueue.main.async { parameters.onUpdate("解析订单号") }
                guard error == nil, let data = data, let body = String(data: data, encoding: .utf8) else {
                    DispatchQueue.main.async { parameters.onUpdate("预订请求失败") }
                    return
                }

                // Step 2: parse orderId from returned JSON.
                let orderId = Self.extractOrderId(from: body)
                // 提示开发者: 请将上方解析逻辑替换为真实的抓包值或正则解析结果。

                guard let id = orderId else {
                    DispatchQueue.main.async { parameters.onUpdate("未能解析订单号") }
                    return
                }

                DispatchQueue.main.async { parameters.onUpdate("发送确认请求") }
                // Step 3: build confirm URL. Replace the example with the real confirm endpoint.
                let confirmURLString = parameters.url + "/" + id + "/confirm"
                guard let confirmURL = URL(string: confirmURLString) else {
                    DispatchQueue.main.async { parameters.onUpdate("确认地址无效") }
                    return
                }
                var confirmRequest = URLRequest(url: confirmURL)
                confirmRequest.httpMethod = "POST"
                confirmRequest.setValue(parameters.cookie, forHTTPHeaderField: "Cookie")
                confirmRequest.setValue(parameters.userAgent, forHTTPHeaderField: "User-Agent")
                URLSession.shared.dataTask(with: confirmRequest) { _, _, _ in
                    DispatchQueue.main.async { parameters.onUpdate("到达支付页面") }
                }.resume()
            }.resume()
        }
    }

    /// Attempts to extract `orderId` from a JSON string using regular expression.
    private static func extractOrderId(from json: String) -> String? {
        let pattern = "\"orderId\"\\s*:\\s*\"([^\"]+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        let range = NSRange(location: 0, length: json.utf16.count)
        if let match = regex.firstMatch(in: json, options: [], range: range),
           let idRange = Range(match.range(at: 1), in: json) {
            return String(json[idRange])
        }
        return nil
    }
}
