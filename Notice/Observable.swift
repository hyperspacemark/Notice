import Foundation

public struct SubscriptionOptions: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let New = SubscriptionOptions(rawValue: 1)
    public static let Initial = SubscriptionOptions(rawValue: 2)
}

public struct Observable<T> {

    // MARK: - Types

    public typealias SubscriptionType = Subscription<T>


    // MARK: - Properties

    private let eventQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)

    public var value: T {
        didSet {
            dispatch_sync(eventQueue) {
                self.subscribers.send(self.value)
            }
        }
    }


    // MARK: - Initialization

    public init(initial value: T) {
        self.value = value
    }


    // MARK: - Subscribers

    private var subscribers = Subscriptions<T>()

    public mutating func subscribe(options: SubscriptionOptions = [.New], handler: SubscriptionType.EventHandler) -> SubscriptionType {
        let subscription = Subscription(handler: handler)

        if options.contains(.Initial) {
            subscription.handler(value)
        }
        
        subscribers.add(subscription)
        return subscription
    }

    public mutating func unsubscribe(subscriber: SubscriptionType) {
        subscribers.remove(subscriber)
    }
}
