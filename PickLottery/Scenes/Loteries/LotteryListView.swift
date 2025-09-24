import SwiftUI
import CoreData

struct LotteryListView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @StateObject var viewModel: LotteryListViewModel
    @State var presentCreateAlert = false
    @State var newLotteryName = ""
    
    @FetchRequest(sortDescriptors: [.init(keyPath: \LotteryMO.name, ascending: true)], animation: .default)
    private var lotteries: FetchedResults<LotteryMO>
    
    private let oneColumnGrid = [GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        NavigationStack {
            List {
                if lotteries.isEmpty {
                    defaultSets
                } else {
                    customSets
                    defaultSets
                }
            }
            .listRowSpacing(4)
//            .listStyle(.plain)
            .navigationTitle("Sets")
            .toolbar {
                Button(role: .none) {
                    presentCreateAlert = true
                } label: {
                    Image(systemName: "plus")
                        .tint(.accentColor)
                }
            }
            .sheet(isPresented: $presentCreateAlert) {
                NavigationStack {
                    CreateLotteryView(isPresented: $presentCreateAlert, viewModel: .init(lotteryStore: lotteryStore))
                }
            }
        }
    }
    
    private var customSets: some View {
            Section(header: Text("CUSTOM")) {
                ForEach(lotteries) { lottery in
                    NavigationLink {
                        LotteryDetailView(viewModel: .init(lottery: lottery, lotteryStore: lotteryStore))
                    } label: {
                        LotteryCellView(emoji: lottery.illustration, name: lottery.name, description: lottery.descriptionText)
                    }
                    .listRowSeparator(.hidden)
                }
            }
    }
    
    private var defaultSets: some View {
            Section(header: Text("DEFAULT")) {
                ForEach(viewModel.defaultLotterySets) { lottery in
                    NavigationLink {
//                        LotteryDetailView(viewModel: .init(lottery: lottery, lotteryStore: lotteryStore))
                        Text("aaa")
                    } label: {
                        LotteryCellView(emoji: lottery.illustration, name: lottery.name, description: lottery.description)
                    }
                    .listRowSeparator(.hidden)
                }
            }

    }
}

struct LotteryList_Previews: PreviewProvider {
    static let storage = LotteryStore.preview
    
    static var previews: some View {
        LotteryListView(viewModel: LotteryListViewModel(lotteryStore: storage))
            .environmentObject(storage)
            .environment(\.managedObjectContext, storage.container.viewContext)
    }
}
