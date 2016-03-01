public protocol Event {
    typealias ValueType
    typealias HandlerType

    var value: ValueType { get }
    func handle(handler: HandlerType)
}

public struct NewEvent<T>: Event {
    public let value: T

    public func handle(handler: T -> Void) {
        handler(value)
    }
}

public struct NewOldEvent<T>: Event {
    public let value: T
    public let oldValue: T?

    init(value: T, oldValue: T? = nil) {
        self.value = value
        self.oldValue = oldValue
    }

    public func handle(handler: (old: T?, new: T) -> Void) {
        handler(old: oldValue, new: value)
    }
}
