import Foundation

public struct Observable<T> {

    // MARK: - Properties

    private let eventQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)

    public var value: T {
        didSet {
            dispatch_sync(eventQueue) {
                self.new.invoke(self.value)
                self.newOld.invoke((old: oldValue, new: self.value))
            }
        }
    }


    // MARK: - Initialization

    public init(initial value: T) {
        self.value = value
    }


    // MARK: - Subscribers

    public lazy var new: NewEvent<T> = {
        return NewEvent<T>(value: self.value)
    }()

    public lazy var newOld: NewOldEvent<T> = {
        return NewOldEvent<T>(value: self.value)
    }()
}
