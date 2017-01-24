import XCTest
@testable import Notice

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

        let expectation = self.expectation(description: "Subscription Observable")
        obs.subscribe { value in
            XCTAssertEqual(value, 2)
            expectation.fulfill()
        }

        obs.value = 2

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsSubscriptionsWithInitialValueOnChange() {
        let obs = Observable(initial: 1)

        var timesCalled = 0
        let expectation = self.expectation(description: "Subscription Observable")
        obs.subscribe([.initial]) { value in
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

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSubscribeAddsHandlerToSubscriptions() {
        let obs = Observable(initial: 1)

        let subscription = obs.subscribe(handler: { _ in })

        XCTAssertTrue(obs.subscriptions.contains(subscription))
    }

    func testSubscribeCallsWithInitialValueIfOptionIncluded() {
        let obs = Observable(initial: 1)

        let expectation = self.expectation(description: "Event Subscription")
        obs.subscribe([.initial]) { value in
            XCTAssertEqual(value, 1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUnsubscribeRemovesSubscriberFromSubscriptions() {
        let obs = Observable(initial: 1)
        let subscription = obs.subscribe(handler: { _ in })

        obs.unsubscribe(subscription)

        XCTAssertFalse(obs.subscriptions.contains(subscription))
    }

    func testChangesetObservableSendsOldAndNewValues() {
        let obs = Observable(initial: 1)

        let expectation = self.expectation(description: "Changeset Subscription")
        obs.changesets().subscribe { value in
            XCTAssertEqual(value.old, 1)
            XCTAssertEqual(value.new, 2)
            expectation.fulfill()
        }

        obs.value = 2
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
