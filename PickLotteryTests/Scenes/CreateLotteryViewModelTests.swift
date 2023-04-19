import XCTest
import Foundation
@testable import PickLottery
import SwiftUI

final class CreateLotteryViewModelTests: XCTestCase {
    private var sut: CreateLotteryViewModel!
    private var lotteryStore: LotteryStoreSpy!
    
    override func setUpWithError() throws {
        lotteryStore = LotteryStoreSpy()
        sut = CreateLotteryViewModel(lotteryStore: lotteryStore)
    }

    override func tearDownWithError() throws {
        sut = nil
        lotteryStore = nil
    }
    
    
    func testCreateLottery_whenNameInputEmpty_shouldShowValidationAlert() {
        sut.name = ""
        sut.description = "My first lottery"
        sut.color = .gray
        sut.emoji = "callendar"
        sut.raffleMode = .weightedEntries
        sut.entriesDescription = "john, cyntia"
        sut.showValidationAlert = false
        
        sut.createLottery()
        
        XCTAssert(sut.showValidationAlert)
    }

    func testCreateLottery_whenAllFieldsAreFilled_shouldAddLottery() throws {
        sut.name = "My Lottery"
        sut.description = "My first lottery"
        sut.color = .gray
        sut.emoji = "callendar"
        sut.raffleMode = .weightedEntries
        sut.entriesDescription = "john, cyntia"
        sut.showValidationAlert = false
        
        sut?.createLottery()
        
        XCTAssertEqual(1, lotteryStore.addLotteryCalls.count)
        let storedLottery = try XCTUnwrap(lotteryStore.addLotteryCalls.first)
        XCTAssertEqual(storedLottery.name, "My Lottery")
    }
    
    func testCreateLottery_whenOnlyNameIsFilled_shouldAddLottery() throws {
        sut.name = "My Lottery"
        sut.showValidationAlert = false
        
        sut?.createLottery()
        
        XCTAssertEqual(1, lotteryStore.addLotteryCalls.count)
        let storedLottery = try XCTUnwrap(lotteryStore.addLotteryCalls.first)
        XCTAssertEqual(storedLottery.name, "My Lottery")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
