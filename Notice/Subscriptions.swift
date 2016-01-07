protocol SubscriptionsType {
    typealias ValueType

    var subscriptions: Set<Subscription<ValueType>> { get set }

    mutating func add(subscription: Subscription<ValueType>)
    mutating func remove(subscription: Subscription<ValueType>)
    func send(value: ValueType)
}

extension SubscriptionsType {
    mutating func add(subscription: Subscription<ValueType>) {
        subscriptions.insert(subscription)
    }

    mutating func remove(subscription: Subscription<ValueType>) {
        subscriptions.remove(subscription)
    }
}

class Subscriptions<T>: SubscriptionsType {
    typealias ValueType = T

    var subscriptions = Set<Subscription<ValueType>>()

    func send(value: ValueType) {
        subscriptions.forEach { $0.handler(value) }
    }
}
