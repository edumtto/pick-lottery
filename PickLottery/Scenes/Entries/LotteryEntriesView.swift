import SwiftUI

struct LotteryEntriesView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @Binding var lottery: LotteryMO
    
    @State private var updateView = true
    @State private var showCreateEntry = false
    
    private var entries: [LotteryEntryMO] {
        Array(lottery.entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        List {
            ForEach(entries) { entry in
                LotteryEntryCell(entry: entry)
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(role: .none) {
                    showCreateEntry.toggle()
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .navigationTitle("Entries")
        .sheet(isPresented: $showCreateEntry) {
            NavigationStack {
                CreateEntryView(viewModel: .init(lotteryStore: lotteryStore, lottery: lottery))
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entries[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEntriesView(
                lottery: .constant(.example)
            )
        }
    }
}
