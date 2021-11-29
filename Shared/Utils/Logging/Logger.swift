protocol Logger {
    func log(_ event: LoggerEvent)
}

extension Logger {
    func log(_ loggable: Loggable) {
        let event = LoggerEvent(
            category: loggable.loggerCategory,
            attributes: loggable.loggerAttributes
        )
        log(event)
    }
}
