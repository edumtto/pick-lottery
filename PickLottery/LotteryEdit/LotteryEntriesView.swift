import SwiftUI

struct LotteryEntriesView: View {
    let lotteryName: String
    @State var entries: [LotteryEntry]
    
    var body: some View {
        List {
            ForEach($entries) { entry in
                LotteryEntryCell(entry: entry)
            }
        }
        .navigationTitle(lotteryName + " Entries")
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
            LotteryEntriesView(
                lotteryName: "Lottery 1",
                entries: [
                    .init("João", weight: 1, winningCounter: 0),
                    .init("Maria", weight: 0, winningCounter: 1),
                    .init("James", weight: 1, winningCounter: 0),
                    .init("Ana", weight: 1.5, winningCounter: 2)
                ]
            )
        }
    }
}
