import SwiftUI

struct LotteryDetailView: View {
    @StateObject var lottery: Lottery
    @State var numberOfTimes: Int = 1
    @State var displayResult: Bool = false
    
    var body: some View {
//        Picker("Number or times", selection: $numberOfTimes) {
        //                ForEach(1..<10) {
        //                    Text("\($0) times")
        //                }
        //            }
        VStack {
            Toggle("Weighted entries", isOn: $lottery.configuration.weightedEntries)
            Toggle("Balance victories", isOn: $lottery.configuration.balancedVictories)
            
        }
        .padding()
        
        
        List {
            Section("Last results") {
                ForEach($lottery.lastResults) { result in
                    LotteryResultCellView(result: result)
                }
            }
        }
        .listStyle(.sidebar)
        
        Button(action: {
            let result = LotteryResult(entry: raffleRandomEntry(), date: Date())
            lottery.lastResults.insert(result, at: 0)
            displayResult = true
        }, label: {
            Text("Raffle")
                .font(.headline)
                .frame(maxWidth: .infinity)
        })
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        .buttonStyle(.borderedProminent)
        
        .alert(isPresented: $displayResult) {
            Alert(title: Text("Congratulations, \(lottery.lastResults.last?.entry.name ?? "_")"))
        }
        .toolbar {
            Button(role: .none) {
                print("Info")
            } label: {
                Image(systemName: "info.circle")
            }

        }
        .navigationTitle(lottery.name)
    }
    
    private func raffleRandomEntry() -> LotteryEntry {
        let numberOfEntries = lottery.entries.count
        var entryIndexes = [Int]()
        
        var biggerVictoryNumber: UInt = 0
        if lottery.configuration.balancedVictories {
            lottery.entries.forEach { entry in
                if entry.winningCounter > biggerVictoryNumber {
                    biggerVictoryNumber = entry.winningCounter
                }
            }
        }
        
        for i in 0..<numberOfEntries {
            let entry = lottery.entries[i]
            if lottery.configuration.balancedVictories, biggerVictoryNumber == entry.winningCounter {
                continue // do not include top winners
            }
            
            if lottery.configuration.weightedEntries {
                entryIndexes.append(contentsOf: [Int](repeating: i, count: Int(entry.weight)))
            } else {
                entryIndexes.append(i)
            }
        }
        
        let randomNum = Int(arc4random_uniform(UInt32(entryIndexes.count)))
        let randomIndex = entryIndexes.index(entryIndexes.startIndex, offsetBy: randomNum)
        let randomEntryIndex = entryIndexes[randomIndex]
        return lottery.entries[randomEntryIndex]
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
