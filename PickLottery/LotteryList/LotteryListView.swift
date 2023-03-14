import SwiftUI
import CoreData

struct LotteryListView: View {
    @State var lotteries: [Lottery]
//    @FetchRequest(sortDescriptors: []) var lotteries: FetchedResults<LotteryMO>
    
    @State var presentCreateAlert = false
    @State var newLotteryName = ""
    @EnvironmentObject var lotteryStore: LotteryStore
    
    let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: threeColumnGrid) {
                    ForEach(lotteries) { lottery in
                        LotteryCellView(lottery: lottery)
                    }
                }
            }
            .padding()
            .navigationTitle("Lotteries")
            .toolbar {
                Button(role: .none) {
                    presentCreateAlert = true
                } label: {
                    Image(systemName: "plus.app")
                        .tint(.accentColor)
                }
            }
            .sheet(isPresented: $presentCreateAlert) {
                NavigationStack {
                    CreateLotteryView(lotteries: $lotteries)
                }
            }
            .onAppear {
                lotteries = lotteryStore.fetchLotteries()
            }
        }
    }
}

struct LotteryList_Previews: PreviewProvider {
    static var previews: some View {
        LotteryListView(
            lotteries: [
                .init(
                    name: "🎲 Dice",
                    entries:  [.init("1"), .init("2"), .init("3"), .init("4"), .init("5"), .init("6")]
                )
            ]
        )
    }
}
