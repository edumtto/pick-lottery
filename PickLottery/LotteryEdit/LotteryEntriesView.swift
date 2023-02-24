import SwiftUI

struct LotteryEntriesView: View {
    @StateObject var lottery: Lottery
    
    var body: some View {
        List {
            ForEach($lottery.entries) { entry in
                LotteryEntryCell(entry: entry)
            }
        }
        .navigationTitle(lottery.name + " Entries")
        .toolbar {
            Button("Edit") {
                
            }
            Button(role: .none) {
                
            } label: {
                Image(systemName: "plus.app")
            }
        }
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEntriesView(lottery:
                Lottery(
                    name: "Lottery 1",
                    entries:
                        [
                            .init("João", weight: 1, winningCounter: 0),
                            .init("Maria", weight: 0, winningCounter: 1),
                            .init("James", weight: 1, winningCounter: 0),
                            .init("Ana", weight: 1.5, winningCounter: 2)
                        ]
                )
            )
        }
    }
}
