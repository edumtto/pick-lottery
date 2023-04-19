import Foundation
@testable import PickLottery
import XCTest

final class LotteryDetailViewModelTests: XCTestCase {
    private var sut: LotteryDetailViewModel!
    private var lotteryStore: LotteryStoreSpy!
    private let lotteryMock: LotteryMO = .example
    
    override func setUpWithError() throws {
        lotteryStore = LotteryStoreSpy()
        sut = LotteryDetailViewModel(lottery: lotteryMock, lotteryStore: lotteryStore)
    }

    override func tearDownWithError() throws {
        sut = nil
        lotteryStore = nil
    }
    
    func testLastResults_shouldReturnOrderedResults() {
        let lastResults = sut.lastResults
        
        XCTAssertEqual(2, lastResults.count)
        XCTAssertEqual("Monday", lastResults[0].entry.name)
        XCTAssertEqual("Wednesday", lastResults[1].entry.name)
    }
    
    func testEntries_shouldReturnOrderedEntries() {
        let entries = sut.entries
        
        XCTAssertEqual(5, entries.count)
        XCTAssertEqual("Friday", entries[0].name)
        XCTAssertEqual("Wednesday", entries[4].name)
    }
    
    func testRaffleButtonAction_shouldAddResult() throws {
        sut.presentRaffleAnimation = false
        
        let expectation = XCTestExpectation(description: "add result called")
        sut.raffleButtonAction {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        let addedLotteryCall = try XCTUnwrap(lotteryStore.addResultCalls.last)
        let addedLottey = addedLotteryCall.lottery
        let selectedEntry = addedLotteryCall.entry
        
        XCTAssert(addedLottey.entries.contains(selectedEntry))
    }
    
    func testClearResults() {
        sut.clearResults()
        
        XCTAssertEqual(lotteryStore.clearResultsCalls, [lotteryMock])
    }
    
    func testDeleteLottery() {
        sut.deleteLottery()
        
        XCTAssertEqual(lotteryStore.removeLotteryCalls, [lotteryMock])
    }
}
