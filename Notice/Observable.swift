import Foundation

public class Observable<T> {

    // MARK: - Properties

    private let eventQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)

    public var value: T {
        didSet {
            dispatch_sync(eventQueue) {
                self.invoke(self.value)
            }
        }
    }

    public var subscriptions = Set<Subscription<T -> Void>>()


    // MARK: - Initialization

    public init(initial value: T) {
        self.value = value
    }


    // MARK: Subscription

    public func subscribe(options: SubscriptionOptions = [.New], handler: (T -> Void)) -> Subscription<(T -> Void)> {
        let subscription = Subscription<(T -> Void)>(handler: handler)
        subscriptions.insert(subscription)

        if options.contains(.Initial) {
            subscription.handler(value)
        }

        return subscription
    }

    public func unsubscribe(subscriber: Subscription<(T -> Void)>) {
        subscriptions.remove(subscriber)
    }

    internal func invoke(value: T) {
        for subscription in subscriptions {
            subscription.handler(value)
        }
    }
}

extension Observable {
    public typealias Changeset = (oldValue: T?, newValue: T)

    /// Returns changes of the parent Observable as tuples of old and new values.
    public func changesets() -> Observable<Changeset> {
        let observable = Observable<Changeset>(initial: (nil, value))
        subscribe { value in
            let changeset: Changeset = (oldValue: observable.value.newValue, newValue: value)
            observable.value = changeset
        }
        return observable
    }
}
