import SwiftUI

struct LotteryEntriesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    //@Binding var entries: NSSet
    @State var updateView = true
    let lottery: LotteryMO
    
    @FetchRequest var entries: FetchedResults<LotteryEntryMO>
    
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
                    lotteryStore.addEntry(.init("abc"), in: lottery)
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .navigationTitle("Entries")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entries[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
    }
    
    init(lottery: LotteryMO) {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        self._entries = FetchRequest(sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "lottery.id = %@", lottery.id.uuidString))
        self.lottery = lottery
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEntriesView(
                lottery: .example
            )
        }
    }
}
