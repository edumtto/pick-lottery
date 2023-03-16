import SwiftUI

struct LotteryEntriesView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @Binding var entries: NSSet
    let lottery: LotteryMO
    
    var entryList: [LotteryEntryMO] {
        Array(entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        List {
            ForEach(entryList) { entry in
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
                    lotteryStore.addEntry(.init("abc"), in: lottery)
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .navigationTitle(lottery.name + " Entries")
    }
    
    private func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entryList[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEntriesView(
                entries: .constant(LotteryMO.example.entries),
                lottery: .example
            )
        }
    }
}
