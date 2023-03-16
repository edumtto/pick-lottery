import SwiftUI

struct LotteryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @StateObject var lottery: LotteryMO
    @State var displayResult: Bool = false
    @State var animate: Bool = false
    
    @State var presentRaffleAnimation = false
    @State var selectedLotteryEntry: LotteryEntryMO? {
        didSet {
            presentRaffleAnimation = true
        }
    }
    @State var isRaffleAnimationFinished = false
    
    var lastResults: [LotteryResultMO] {
        Array(lottery.results)
            .compactMap { $0 as? LotteryResultMO }
            .sorted { $0.date > $1.date }
    }
    
    var entries: [LotteryEntryMO] {
        Array(lottery.entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ZStack {
            VStack {
                raffleDescription
                    .padding(.bottom, -6)
                List {
                    Section("Winners") {
                        ForEach(lastResults) { result in
                            LotteryResultCellView(result: result)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(isPresented: $presentRaffleAnimation, content: {
            ZStack {
                RaffleAnimationView(
                    entries: entries,
                    targetEntry: selectedLotteryEntry,
                    isRaffleAnimationFinished: $isRaffleAnimationFinished)
                if isRaffleAnimationFinished {
                    ConfettiAnimationView()
                }
            }
        })
        .toolbar {
            ToolbarItem {
                Menu("Options") {
                    Button("Clear results") {
                        lotteryStore.clearResults(in: lottery)
                    }
                    Button {
                        lotteryStore.removeLottery(lottery)
                        dismiss()
                    } label: {
                        Label("Delete lottery", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle(lottery.name)
    }
    
    var raffleDescription: some View {
        VStack {
            NavigationLink {
                LotteryEntriesView(lottery: lottery, entriesSet: $lottery.entries)
            } label: {
                HStack {
                    Text("\(lottery.entries.count) entries")
                        .fontWeight(.medium)
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.bottom)
            
            HStack {
                Text(Lottery.RaffleMode(rawValue: lottery.raffleMode)?.description ?? "")
                    .foregroundColor(.accentColor)
                    .fontWeight(.medium)
                Button(role: .none) {
                    print("Info")
                } label: {
                    Image(systemName: "info.circle")
                        .fontWeight(.medium)
                }
            }
            .padding(.bottom)
            
            Button(action: {
                selectedLotteryEntry = nil
                isRaffleAnimationFinished = false
                
                let selectedEntry = raffleRandomEntry()
                selectedLotteryEntry = selectedEntry
                let result = LotteryResult(entry: selectedEntry, date: Date())
                //lottery.lastResults.append(result)
                lotteryStore.addResult(result, in: lottery)
                displayResult = true
            }, label: {
                Text("Raffle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            //.disabled(lottery.entries.isEmpty)
        }
        .padding()
        //.background(lottery.color.opacity(0.1))
    }
    
    
    
//    var pastWinners: [LotteryResult] {
//        if currentWinner == nil {
//            return lottery.lastResults
//        }
//        var pastWinners = lottery.lastResults
//        pastWinners.remove(at: 0)
//        return pastWinners
//    }
    
    private func raffleRandomEntry() -> LotteryEntryMO {
        let numberOfEntries = lottery.entries.count
        var entryIndexes = [Int]()
        let raffleMode = Lottery.RaffleMode(rawValue: lottery.raffleMode) ?? .fullRandom
        
        switch raffleMode {
        case .balancedVictories:
            var biggerVictoryNumber: UInt = 0
            entries.forEach { entry in
                if entry.wins > biggerVictoryNumber {
                    biggerVictoryNumber = UInt(entry.wins)
                }
            }
            
            for i in 0..<numberOfEntries {
                let entry = entries[i]
                if entry.wins < biggerVictoryNumber {
                    entryIndexes.append(i)
                }
            }
            
        case .weightedEntries:
            for i in 0..<numberOfEntries {
                let entry = entries[i]
                entryIndexes.append(contentsOf: [Int](repeating: i, count: Int(entry.weight)))
            }
        case .fullRandom:
            entryIndexes = [Int](0..<numberOfEntries)
        }
        
        let randomNum = Int(arc4random_uniform(UInt32(entryIndexes.count)))
        let randomIndex = entryIndexes.index(entryIndexes.startIndex, offsetBy: randomNum)
        let randomEntryIndex = entryIndexes[randomIndex]
        return entries[randomEntryIndex]
    }
}

//struct LotteryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            LotteryDetailView(lottery: Lottery(
//                name: "Lottery 1",
//                entries: [.init("Marcos"), .init("Miguel"), .init("Samantha")],
//                lastResults: [
//                    .init(entry: .init("João", weight: 1, winningCounter: 0), date: Date()),
//                    .init(entry: .init("Maria", weight: 0, winningCounter: 1), date: Date()),
//                    .init(entry: .init("James", weight: 1, winningCounter: 0), date: Date()),
//                    .init(entry: .init("Ana", weight: 1, winningCounter: 0), date: Date())
//                ]
//            ))
//        }
//    }
//}
