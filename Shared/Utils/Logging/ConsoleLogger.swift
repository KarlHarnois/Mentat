import Foundation

final class ConsoleLogger: Logger {
    private let queue: DispatchQueue

    init(queue: DispatchQueue? = nil) {
        self.queue = queue ?? .init(label: "ConsoleLogger")
    }

    func log(_ event: LoggerEvent) {
        queue.async {
            print("[\(event.category)]\n\(self.format(event.attributes))\n")
        }
    }

    private func format(_ attributes: [LoggerEventAttribute: String?]) -> String {
        var lines = [String]()
        var payloadLine: String?
        var curlLine: String?

        attributes.forEach { key, value in
            let line = "    [\(key)] \(value ?? "<nil>")"

            if key == .curl {
                curlLine = line
            } else if key == .payload {
                payloadLine = line
            } else {
                let index = lines.firstIndex(where: { $0 > line })
                lines.insert(line, at: index ?? lines.endIndex)
            }
        }

        if let line = payloadLine {
            lines.append(line)
        }

        if let line = curlLine {
            lines.append(line)
        }

        return lines.joined(separator: "\n")
    }
}
