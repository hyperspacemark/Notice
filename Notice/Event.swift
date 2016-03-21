public struct SubscriptionOptions: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let New = SubscriptionOptions(rawValue: 1)
    public static let Initial = SubscriptionOptions(rawValue: 2)
}

public protocol Event {
    typealias ValueType

    var subscriptions: Set<Subscription<ValueType -> Void>> { get set }
    var value: ValueType { get set }

    mutating func subscribe(options: SubscriptionOptions, handler: ValueType -> Void) -> Subscription<ValueType -> Void>
    mutating func unsubscribe(subscriber: Subscription<ValueType -> Void>)
}


extension Event {
    public typealias EventHandler = ValueType -> Void

    public mutating func subscribe(options: SubscriptionOptions = [.New], handler: EventHandler) -> Subscription<EventHandler> {
        let subscription = Subscription<EventHandler>(handler: handler)
        subscriptions.insert(subscription)

        if options.contains(.Initial) {
            subscription.handler(value)
        }

        return subscription
    }

    public mutating func unsubscribe(subscriber: Subscription<EventHandler>) {
        subscriptions.remove(subscriber)
    }

    mutating func invoke(value: ValueType) {
        self.value = value

        for subscription in subscriptions {
            subscription.handler(value)
        }
    }
}


public struct NewEvent<T>: Event {
    public typealias EventHandler = T -> Void

    public var subscriptions = Set<Subscription<EventHandler>>()
    public var value: T

    public init(value: T) {
        self.value = value
    }
}


public struct NewOldEvent<T>: Event {
    public typealias EventHandler = (old: T?, new: T) -> Void

    public var subscriptions = Set<Subscription<EventHandler>>()
    public var value: (old: T?, new: T)

    public init(value: T) {
        self.value = (old: nil, new: value)
    }
}
