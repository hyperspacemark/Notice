class Observer<T> {
    let handler: T -> Void
    init(handler: T -> Void) {
        self.handler = handler
    }

    func notify(value: T) {
        handler(value)
    }
}
