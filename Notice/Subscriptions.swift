protocol SubscriptionsType {
    typealias EventType: Event

    var subscriptions: Set<Subscription<EventType>> { get set }

    mutating func add(subscription: Subscription<EventType>)
    mutating func remove(subscription: Subscription<EventType>)
    func send(value: EventType)
}

extension SubscriptionsType {
    mutating func add(subscription: Subscription<EventType>) {
        subscriptions.insert(subscription)
    }

    mutating func remove(subscription: Subscription<EventType>) {
        subscriptions.remove(subscription)
    }
}

class Subscriptions<EventType: Event>: SubscriptionsType {
    var subscriptions = Set<Subscription<EventType>>()

    func send(event: EventType) {
        subscriptions.forEach { $0.handle(event) }
    }
}
