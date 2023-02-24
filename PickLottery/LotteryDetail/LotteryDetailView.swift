import SwiftUI

struct LotteryDetailView: View {
    @StateObject var lottery: Lottery
    @State var numberOfTimes: Int = 1
    @State var displayResult: Bool = false
    
    var body: some View {
        VStack {
            Toggle("Variable weight for entries", isOn: .constant(false))
            Toggle("Distritute victories", isOn: .constant(false))
//            Picker("Number or times", selection: $numberOfTimes) {
//                ForEach(1..<10) {
//                    Text("\($0) times")
//                }
//            }
            Button("Raffle") {
                let result = LotteryResult(entry: raffleRandomEntry(), date: Date())
                lottery.lastResults.insert(result, at: 0)
                displayResult = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
            .toolbar {
                Button(role: .none) {
                    print("Info")
                } label: {
                    Image(systemName: "info.circle")
                }

            }
        }
        .navigationTitle(lottery.name)
        .padding()
        
        List {
            Section("Last results") {
                ForEach($lottery.lastResults) { result in
                    LotteryResultCellView(result: result)
                }
            }
        }
        .listStyle(.sidebar)
        
        .alert(isPresented: $displayResult) {
            Alert(title: Text("Congratulations, \(lottery.lastResults.last?.entry.name ?? "_")"))
        }
    }
    
    private func raffleRandomEntry() -> LotteryEntry {
        let entries = lottery.entries
        let randomNum = Int(arc4random_uniform(UInt32(entries.count)))
        let randomIndex = entries.index(entries.startIndex, offsetBy: randomNum)
        return entries[randomIndex]
    }
}

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryDetailView(lottery: Lottery(
                name: "Lottery 1",
                entries: [],
                lastResults: [
                    .init(entry: .init(name: "João", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init(name: "Maria", weight: 0, winningCounter: 1), date: Date()),
                    .init(entry: .init(name: "James", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init(name: "Ana", weight: 1, winningCounter: 0), date: Date())
                ]
            ))
        }
    }
}
