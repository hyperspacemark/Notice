import XCTest
import Notice

class ObservableTests: XCTestCase {
    
    func testSetsInitialValue() {
        let obs = Observable(initial: 1)

        XCTAssertEqual(obs.value, 1)
    }

    func testAllowsValuesToBeChanged() {
        let obs = Observable(initial: 1)

        obs.value = 2

        XCTAssertEqual(obs.value, 2)
    }

    func testCallsSubscriptionsOnValueChange() {
        let obs = Observable(initial: 1)

        let expectation = expectationWithDescription("Subscription Observable")
        obs.subscribe { value in
            XCTAssertEqual(value, 2)
            expectation.fulfill()
        }

        obs.value = 2

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testCallsSubscriptionsWithInitialValueOnChange() {
        let obs = Observable(initial: 1)

        var timesCalled = 0
        let expectation = expectationWithDescription("Subscription Observable")
        obs.subscribe([.Initial]) { value in
            if timesCalled == 0 {
                XCTAssertEqual(value, 1)
            } else if timesCalled == 1 {
                XCTAssertEqual(value, 2)
            }

            timesCalled += 1

            if timesCalled == 2 {
                expectation.fulfill()
            }
        }

        obs.value = 2

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testSubscribeAddsHandlerToSubscriptions() {
        let obs = Observable(initial: 1)

        let subscription = obs.subscribe(handler: { _ in })

        XCTAssertTrue(obs.subscriptions.contains(subscription))
    }

    func testSubscribeCallsWithInitialValueIfOptionIncluded() {
        let obs = Observable(initial: 1)

        let expectation = expectationWithDescription("Event Subscription")
        obs.subscribe([.Initial]) { value in
            XCTAssertEqual(value, 1)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testUnsubscribeRemovesSubscriberFromSubscriptions() {
        let obs = Observable(initial: 1)
        let subscription = obs.subscribe(handler: { _ in })

        obs.unsubscribe(subscription)

        XCTAssertFalse(obs.subscriptions.contains(subscription))
    }

    func testChangesetObservableSendsOldAndNewValues() {
        let obs = Observable(initial: 1)

        let expectation = expectationWithDescription("Changeset Subscription")
        obs.changesets().subscribe { value in
            XCTAssertEqual(value.oldValue, 1)
            XCTAssertEqual(value.newValue, 2)
            expectation.fulfill()
        }

        obs.value = 2
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
