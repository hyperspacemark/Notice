import Foundation

public struct SubscriptionOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let new = SubscriptionOptions(rawValue: 1)
    public static let initial = SubscriptionOptions(rawValue: 2)
}

public struct Subscription<Value>: Hashable {
    let send: (Value) -> Void
    private let uuid = UUID().uuidString

    init(send: @escaping (Value) -> Void) {
        self.send = send
    }

    public var hashValue: Int {
        return uuid.hashValue
    }
    
    public static func ==(lhs: Subscription<Value>, rhs: Subscription<Value>) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

