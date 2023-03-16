import SwiftUI

struct LotteryEntriesView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: LotteryMO
    @Binding var entriesSet: NSSet
    //@State var entries: [LotteryEntryMO]
    
    var entries: [LotteryEntryMO] {
        Array(entriesSet)
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
                    lotteryStore.addEntry(.init("abc"), in: lottery)
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .navigationTitle(lottery.name + " Entries")
    }
    
    private func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entries[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
    }
}

//struct LotteryEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            LotteryEntriesView(
//                lottery: .init(name: "Loteria ABC"),
//                entries: [
//                    .init("João", weight: 1, winningCounter: 0),
//                    .init("Maria", weight: 0, winningCounter: 1),
//                    .init("James", weight: 1, winningCounter: 0),
//                    .init("Ana", weight: 1.5, winningCounter: 2)
//                ]
//            )
//        }
//    }
//}
