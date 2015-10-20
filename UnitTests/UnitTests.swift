import XCTest
@testable import Notice

class ObservableTests: XCTestCase {
    func testSubscribe() {
        let expectation = expectationWithDescription(__FUNCTION__)
        defer { waitForExpectationsWithTimeout(0, handler: nil) }

        let observable = Observable(false)

        observable.subscribe { value in
            XCTAssertFalse(value)
            expectation.fulfill()
        }

        observable.value = true
    }

    func testSubscribeSendsNewValues() {
        let expectation = expectationWithDescription(__FUNCTION__)
        defer { waitForExpectationsWithTimeout(0, handler: nil) }

        let observable = Observable(false)

        var initialCall = true

        observable.subscribe { value in
            if initialCall {
                initialCall = false
            } else {
                XCTAssertTrue(value)
                expectation.fulfill()
            }
        }

        observable.value = true
    }

    func testCallbackThread() {
        let expectation = expectationWithDescription(__FUNCTION__)
        defer { waitForExpectationsWithTimeout(1, handler: nil) }

        let observable = Observable(false)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let currentThread = NSThread.currentThread()

            observable.subscribe { value in
                XCTAssertEqual(currentThread, NSThread.currentThread())
                expectation.fulfill()
            }
        }
    }
}
