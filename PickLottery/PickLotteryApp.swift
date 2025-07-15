import SwiftUI

@main
struct PickLotteryApp: App {
    @StateObject private var lotteryStore = LotteryStore.shared

    var body: some Scene {
        WindowGroup {
            LotteryListView(viewModel:  LotteryListViewModel(lotteryStore: lotteryStore))
                .environmentObject(lotteryStore)
                .environment(\.managedObjectContext, lotteryStore.container.viewContext)
        }
    }
}

