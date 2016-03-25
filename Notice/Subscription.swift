public struct SubscriptionOptions: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let New = SubscriptionOptions(rawValue: 1)
    public static let Initial = SubscriptionOptions(rawValue: 2)
}

public struct Subscription<HandlerType>: Hashable {
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
