import Foundation

public struct SubscriptionOptions: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let New = SubscriptionOptions(rawValue: 1)
    public static let Initial = SubscriptionOptions(rawValue: 2)
}

public struct Observable<T> {

    // MARK: - Types

    public typealias NewEventType = NewEvent<T>
    public typealias NewOldEventType = NewOldEvent<T>


    // MARK: - Properties

    private let eventQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)

    public var value: T {
        didSet {
            dispatch_sync(eventQueue) {
                self.newSubscribers.send(NewEvent(value: self.value))
                self.newOldSubscribers.send(NewOldEvent(value: self.value, oldValue: oldValue))
            }
        }
    }


    // MARK: - Initialization

    public init(initial value: T) {
        self.value = value
    }


    // MARK: - Subscribers

    private var newSubscribers = Subscriptions<NewEventType>()
    private var newOldSubscribers = Subscriptions<NewOldEventType>()

    public mutating func subscribe(options: SubscriptionOptions = [.New], handler: NewEventType.HandlerType) -> Subscription<NewEventType> {
        let subscriber = Subscription<NewEventType>(handler: handler)

        if options.contains(.Initial) {
            subscriber.handle(NewEvent(value: self.value))
        }

        newSubscribers.add(subscriber)
        return subscriber
    }

    public mutating func unsubscribe(subscriber: Subscription<NewEventType>) {
        newSubscribers.remove(subscriber)
    }

    public mutating func subscribeNewOld(options: SubscriptionOptions = [.New], handler: NewOldEventType.HandlerType) -> Subscription<NewOldEventType> {
        let subscriber = Subscription<NewOldEventType>(handler: handler)

        if options.contains(.Initial) {
            subscriber.handle(NewOldEventType(value: self.value))
        }

        newOldSubscribers.add(subscriber)
        return subscriber
    }

    public mutating func unsubscribe(subscriber: Subscription<NewOldEventType>) {
        newOldSubscribers.remove(subscriber)
    }
}
