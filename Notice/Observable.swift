import Foundation

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

    public mutating func subscribe(handler: SubscriptionType.EventHandler) -> SubscriptionType {
        let subscription = Subscription(handler: handler)
        subscribers.add(subscription)
        return subscription
    }

    public mutating func unsubscribe(subscriber: SubscriptionType) {
        subscribers.remove(subscriber)
    }
}
