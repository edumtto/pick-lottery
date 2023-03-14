import SwiftUI

struct LotteryDetailView: View {
    @StateObject var lottery: Lottery
    @State var displayResult: Bool = false
    @State var animate: Bool = false
    
    @State var presentRaffleAnimation = false
    @State var selectedLotteryEntry: LotteryEntry? {
        didSet {
            presentRaffleAnimation = true
        }
    }
    @State var isRaffleAnimationFinished = false
    
    var body: some View {
        ZStack {
            VStack {
                raffleDescription
                    .padding(.bottom, -6)
                List {
                    Section("Winners") {
                        ForEach($lottery.lastResults.reversed()) { result in
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
                    entries: lottery.entries,
                    targetEntry: selectedLotteryEntry,
                    isRaffleAnimationFinished: $isRaffleAnimationFinished)
                if isRaffleAnimationFinished {
                    ConfettiAnimationView()
                }
            }
        })
        .toolbar {
            Button("Clear results") {
                lottery.lastResults.removeAll()
            }
        }
        .navigationTitle(lottery.name)
    }
    
    var raffleDescription: some View {
        VStack {
            NavigationLink {
                LotteryEntriesView(lotteryName: lottery.name, entries: lottery.entries)
            } label: {
                HStack {
                    Text("\(lottery.entries.count) entries")
                        .fontWeight(.medium)
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.bottom)
            
            HStack {
                Text(lottery.raffleMode.description)
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
                lottery.lastResults.append(result)
                displayResult = true
            }, label: {
                Text("Raffle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(lottery.color.opacity(0.1))
    }
    
    
    
//    var pastWinners: [LotteryResult] {
//        if currentWinner == nil {
//            return lottery.lastResults
//        }
//        var pastWinners = lottery.lastResults
//        pastWinners.remove(at: 0)
//        return pastWinners
//    }
    
    private func raffleRandomEntry() -> LotteryEntry {
        let numberOfEntries = lottery.entries.count
        var entryIndexes = [Int]()
        
        switch lottery.raffleMode {
        case .balancedVictories:
            var biggerVictoryNumber: UInt = 0
            lottery.entries.forEach { entry in
                if entry.winningCounter > biggerVictoryNumber {
                    biggerVictoryNumber = entry.winningCounter
                }
            }
            
            for i in 0..<numberOfEntries {
                let entry = lottery.entries[i]
                if entry.winningCounter < biggerVictoryNumber {
                    entryIndexes.append(i)
                }
            }
            
        case .weightedEntries:
            for i in 0..<numberOfEntries {
                let entry = lottery.entries[i]
                entryIndexes.append(contentsOf: [Int](repeating: i, count: Int(entry.weight)))
            }
        case .fullRandom:
            entryIndexes = [Int](0..<numberOfEntries)
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
                entries: [.init("Marcos"), .init("Miguel"), .init("Samantha")],
                lastResults: [
                    .init(entry: .init("João", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init("Maria", weight: 0, winningCounter: 1), date: Date()),
                    .init(entry: .init("James", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init("Ana", weight: 1, winningCounter: 0), date: Date())
                ]
            ))
        }
    }
}
