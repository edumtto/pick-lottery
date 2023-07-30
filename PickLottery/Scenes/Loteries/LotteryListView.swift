import SwiftUI
import CoreData

struct LotteryListView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @State var presentCreateAlert = false
    @State var newLotteryName = ""
    @FetchRequest(sortDescriptors: []) var lotteries: FetchedResults<LotteryMO>
    
    private let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if lotteries.isEmpty {
                    emptyState
                } else {
                    lotteryGrid
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
                    AddLotteryView(isPresented: $presentCreateAlert, viewModel: AddLotteryViewModel(lotteryStore: lotteryStore))
                }
            }
        }
    }
    
    private var lotteryGrid: some View {
        LazyVGrid(columns: twoColumnGrid, spacing: 8) {
            ForEach(lotteries) { lottery in
                NavigationLink {
                    LotteryDetailView(viewModel: .init(lottery: lottery, lotteryStore: lotteryStore))
                } label: {
                    LotteryCellView(lottery: lottery)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack {
            Spacer()
            HStack{
                Text("Nothing here! Tap in the")
                Image(systemName: "plus.app")
                Text("icon")
            }
            Text("to add or create a new lottery.")
        }
        .foregroundColor(.gray)
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
