public class Subscription<HandlerType>: Hashable {
    let handler: HandlerType
    private let UUID = NSUUID().UUIDString

    init(handler: HandlerType) {
        self.handler = handler
    }

    public var hashValue: Int {
        return UUID.hashValue
    }
}

public func ==<HandlerType>(lhs: Subscription<HandlerType>, rhs: Subscription<HandlerType>) -> Bool {
    return lhs.UUID == rhs.UUID
}
