import XCTest
@testable import Notice

class EventTests: XCTestCase {
    func testSubscribeAddsHandlerToSubscriptions() {
        var event = TestEvent(value: 1)

        let subscription = event.subscribe(handler: { _ in })

        XCTAssertTrue(event.subscriptions.contains(subscription))
    }

    func testSubscribeCallsWithInitialValueIfOptionIncluded() {
        var event = TestEvent(value: 1)

        let expectation = expectationWithDescription("Event Subscription")
        event.subscribe([.Initial]) { value in
            XCTAssertEqual(value, 1)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testUnsubscribeRemovesSubscriberFromSubscriptions() {
        var event = TestEvent(value: 1)
        let subscription = event.subscribe(handler: { _ in })

        event.unsubscribe(subscription)

        XCTAssertFalse(event.subscriptions.contains(subscription))
    }
}

struct TestEvent: Event {
    typealias EventHandler = Int -> Void

    var subscriptions = Set<Subscription<EventHandler>>()
    var value: Int

    init(value: Int) {
        self.value = value
    }
}
