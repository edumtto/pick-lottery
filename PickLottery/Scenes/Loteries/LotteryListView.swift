import SwiftUI
import CoreData

struct LotteryListView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @State var presentCreateAlert = false
    @State var newLotteryName = ""
    @FetchRequest(sortDescriptors: []) var lotteries: FetchedResults<LotteryMO>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
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
                        .font(.title2)
                }
            }
            .sheet(isPresented: $presentCreateAlert) {
                NavigationStack {
                    AddLotteryView(viewModel: AddLotteryViewModel(lotteryStore: lotteryStore))
//                    CreateLotteryView(viewModel: .init(lotteryStore: lotteryStore))
                }
            }
        }
    }
}

struct LotteryList_Previews: PreviewProvider {
    static let storage = LotteryStore.preview
    
    static var previews: some View {
        LotteryListView()
            .environmentObject(storage)
            .environment(\.managedObjectContext, storage.container.viewContext)
    }
}
