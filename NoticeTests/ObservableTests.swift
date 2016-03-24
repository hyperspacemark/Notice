import XCTest
import Notice

class ObservableTests: XCTestCase {
    
    func testSetsInitialValue() {
        let obs = Observable(initial: 1)

        XCTAssertEqual(obs.value, 1)
    }

    func testAllowsValuesToBeChanged() {
        var obs = Observable(initial: 1)

        obs.value = 2

        XCTAssertEqual(obs.value, 2)
    }

    func testCallsSubscriptionsOnValueChange() {
        var obs = Observable(initial: 1)

        let expectation = expectationWithDescription("Subscription Observable")
        obs.new.subscribe { value in
            XCTAssertEqual(value, 2)
            expectation.fulfill()
        }

        obs.value = 2

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testCallsSubscriptionsWithInitialValueOnChange() {
        var obs = Observable(initial: 1)

        var timesCalled = 0
        let expectation = expectationWithDescription("Subscription Observable")
        obs.new.subscribe([.Initial]) { value in
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

    func testCallsNewOldEventSubscribersWithForNewAndOldValues() {
        var obs = Observable(initial: 1)

        let expectation = expectationWithDescription("Subscription Observable")
        obs.newOld.subscribe { (old, new) -> Void in
            XCTAssertEqual(old, 1)
            XCTAssertEqual(new, 2)
            expectation.fulfill()
        }

        obs.value = 2

        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
}
