public class Subscription<EventType: Event>: Hashable {
    public typealias EventHandler = EventType.HandlerType

    let handler: EventHandler
    private let UUID = NSUUID().UUIDString

    init(handler: EventHandler) {
        self.handler = handler
    }

    public var hashValue: Int {
        return UUID.hashValue
    }

    func handle(event: EventType) {
        event.handle(handler)
    }
}

public func ==<EventType: Event>(lhs: Subscription<EventType>, rhs: Subscription<EventType>) -> Bool {
    return lhs.UUID == rhs.UUID
}
