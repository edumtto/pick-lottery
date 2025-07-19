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
            Group {
                if lotteries.isEmpty {
                    emptyState
                } else {
                    lotteryGrid
                }
            }
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
    
    private var lotteryGrid: some View {
        List {
//            Section(header: Text("DEFAULT")) {
                ForEach(lotteries) { lottery in
                    NavigationLink {
                        LotteryDetailView(viewModel: .init(lottery: lottery, lotteryStore: lotteryStore))
                    } label: {
                        LotteryCellView(lottery: lottery)
                    }
                    .listRowSeparator(.hidden)
                }
//            }
//            .listSectionSpacing(8)
        }
        .listRowSpacing(4)
        .listStyle(.plain)
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
        LotteryListView(viewModel: LotteryListViewModel(lotteryStore: storage))
            .environmentObject(storage)
            .environment(\.managedObjectContext, storage.container.viewContext)
    }
}
