import Foundation

final class AddLotteryViewModel: ObservableObject {
    var lotteryStore: LotteryStorageProvider
    
    @Published var suggestions: [Lottery] = {
        let lotterySuggestions: [LotterySuggestion] = JSONLoader.load(
            fileName: "lotterySuggestions",
            keyDecodingStrategy: .convertFromSnakeCase
        )
        
        return lotterySuggestions.map(\.lottery)
    }()
    
    func addLottery(_ newLottery: Lottery) {
        lotteryStore.addLottery(newLottery)
    }
    
    init(lotteryStore: LotteryStorageProvider) {
        self.lotteryStore = lotteryStore
    }
}
