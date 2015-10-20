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
                self.onceSubscribers.send(self.value)
            }
        }
    }


    // MARK: - Initialization

    public init(initial value: T) {
        self.value = value
    }


    // MARK: - Subscribers

    private var subscribers = Subscriptions<T>()
    private var onceSubscribers = OnceSubscriptions<T>()

    public mutating func subscribe(handler: SubscriptionType.EventHandler) -> SubscriptionType {
        let subscription = Subscription(handler: handler)
        subscription.handler(value)
        subscribers.add(subscription)
        return subscription
    }

    public mutating func subscribeOnce(handler: SubscriptionType.EventHandler) {
        onceSubscribers.add(Subscription(handler: handler))
    }

    public mutating func unsubscribe(subscriber: SubscriptionType) {
        subscribers.remove(subscriber)
    }
}
