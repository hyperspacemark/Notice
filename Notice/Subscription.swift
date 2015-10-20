public class Subscription<T>: Hashable {
    public typealias EventHandler = T -> Void

    weak var observer: Observer<T>?
    private let UUID = NSUUID().UUIDString

    init(handler: EventHandler) {
        self.observer = Observer(handler: handler)
    }

    public var hashValue: Int {
        return UUID.hashValue
    }

    func send(value: T) {
        observer?.notify(value)
    }
}

public func ==<T>(lhs: Subscription<T>, rhs: Subscription<T>) -> Bool {
    return lhs.UUID == rhs.UUID
}
