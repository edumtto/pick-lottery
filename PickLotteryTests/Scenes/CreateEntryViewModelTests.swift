import Foundation
@testable import PickLottery
import XCTest

final class CreateEntryViewModelTests: XCTestCase {
    private var sut: CreateEntryViewModel!
    private var lotteryStore: LotteryStoreSpy!
    private let lotteryMock: LotteryMO = .example
    
    override func setUpWithError() throws {
        lotteryStore = LotteryStoreSpy()
        sut = CreateEntryViewModel(lotteryStore: lotteryStore, lottery: lotteryMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        lotteryStore = nil
    }
    
    func testCreateEntry_whenNameIsFilled_shouldAddEntry() {
        sut.name = "abc"
        
        sut.createEntry()
        
        XCTAssertEqual(lotteryStore.addEntryCalls.count, 1)
        XCTAssertEqual(lotteryStore.addEntryCalls[0].entry.name, "abc")
    }
    
    func testCreateEntry_whenNameIsNotFilled_shouldShowValidationAlert() {
        sut.name = ""
        sut.showValidationAlert = false
        
        sut.createEntry()
        
        XCTAssertEqual(lotteryStore.addEntryCalls.count, 0)
        XCTAssert(sut.showValidationAlert)
    }
}
