import SwiftUI

struct LotteryListView: View {
    @State var lotteries: [Lottery]
    @State var presentCreateAlert = false
    @State var newLotteryName = ""
    
    let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: threeColumnGrid) {
                ForEach(lotteries) { lottery in
                    LotteryCellView(lottery: lottery)
                }
            }
            .navigationTitle("Lotteries")
            .toolbar {
                Button(role: .none) {
                    presentCreateAlert = true
                } label: {
                    Image(systemName: "plus.app")
                }
            }
            .alert("Create new lottery", isPresented: $presentCreateAlert) {
                TextField("Name", text: $newLotteryName)
                Button("Create") {
                    lotteries.append(.init(name: newLotteryName))
                }
            }
        }
    }
}

struct LotteryList_Previews: PreviewProvider {
    static var previews: some View {
        LotteryListView(lotteries: [
            .init(name: "Supper Lottery 1"),
            .init(name: "Extra large name for a Lottery 2"),
            .init(name: "Lottery 3"),
            .init(name: "Lottery 4"),
            .init(name: "Lottery 5"),
            .init(name: "Lottery 6"),
            .init(name: "Supper Lottery 1"),
            .init(name: "Extra large name for a Lottery 2"),
            .init(name: "Lottery 3"),
            .init(name: "Lottery 4"),
            .init(name: "Lottery 5"),
            .init(name: "Lottery 6"),
        ])
    }
}