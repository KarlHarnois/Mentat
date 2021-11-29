enum LoggerEventAttribute: String {
    case curl
    case httpMethod = "http-method"
    case message
    case payload
    case statusCode = "status-code"
    case subcategory
    case url
}
