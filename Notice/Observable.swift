import Foundation

public final class Observable<Value> {

    // MARK: - Public Properties

    public var value: Value {
        didSet {
            eventQueue.sync {
                subscriptions.forEach { $0.send(value) }
            }
        }
    }


    // MARK: - Initialization

    public init(initial value: Value) {
        self.value = value
    }


    // MARK: - Public Methods

    @discardableResult
    public func subscribe(_ options: SubscriptionOptions = [.new], handler: @escaping (Value) -> Void) -> Subscription<Value> {
        let subscription = Subscription<Value>(send: handler)
        subscriptions.insert(subscription)

        if options.contains(.initial) {
            subscription.send(value)
        }

        return subscription
    }

    public func unsubscribe(_ subscriber: Subscription<Value>) {
        subscriptions.remove(subscriber)
    }


    // MARK: - Internal Properties
    
    var subscriptions = Set<Subscription<Value>>()

    
    // MARK: - Private Properties

    private let eventQueue = DispatchQueue.global(qos: .default)
}

extension Observable {
    public typealias Changeset = (old: Value?, new: Value)

    /// Returns changes of the parent Observable as tuples of old and new values.
    public func changesets() -> Observable<Changeset> {
        let observable = Observable<Changeset>(initial: (old: nil, new: value))
        subscribe { value in
            observable.value = (old: observable.value.new, new: value)
        }
        return observable
    }
}
