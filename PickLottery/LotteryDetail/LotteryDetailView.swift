import SwiftUI
import Combine

final class LotteryDetailViewModel: ObservableObject {
    @Published var lottery: LotteryMO
    @Published var animate: Bool = false
    @Published var presentRaffleAnimation = false
    @Published var isRaffleAnimationFinished = false
    var selectedLotteryEntry: LotteryEntryMO? {
        didSet {
            presentRaffleAnimation = true
        }
    }
    
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
    
    init(lottery: LotteryMO) {
        self.lottery = lottery
    }
    
    func raffleRandomEntry() -> LotteryEntryMO {
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

struct LotteryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @StateObject var viewModel: LotteryDetailViewModel
    
    var color: Color {
        Color(hex: viewModel.lottery.hexColor) ?? Color.primary
    }
    
    var body: some View {
        ZStack {
            VStack {
                raffleDescription
                    .padding(.bottom, -6)
                ScrollView {
                    LazyVStack {
                        Text("Winners")
                            .font(.headline)
                        ForEach(viewModel.lastResults) { result in
                            LotteryResultCellView(result: result)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.presentRaffleAnimation) {
            ZStack {
                RaffleAnimationView(
                    entries: viewModel.entries,
                    targetEntry: viewModel.selectedLotteryEntry,
                    isRaffleAnimationFinished: $viewModel.isRaffleAnimationFinished)
                if viewModel.isRaffleAnimationFinished {
                    ConfettiAnimationView()
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Menu("Options") {
                    Button("Clear results") {
                        lotteryStore.clearResults(in: viewModel.lottery)
                        viewModel.selectedLotteryEntry = nil
                    }
                    Button {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            lotteryStore.removeLottery(viewModel.lottery)
                        }
                    } label: {
                        Label("Delete lottery", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle(viewModel.lottery.name)
    }
    
    var raffleDescription: some View {
        VStack {
            NavigationLink {
                LotteryEntriesView(entries: $viewModel.lottery.entries, lottery: viewModel.lottery)
            } label: {
                HStack {
                    Text("\(viewModel.lottery.entries.count) entries")
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Image(systemName: "chevron.right")
                        .tint(.black)
                }
            }
            .padding(.bottom)
            
            HStack {
                Text(Lottery.RaffleMode(rawValue: viewModel.lottery.raffleMode)?.description ?? "")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                Button(role: .none) {
                    print("Info")
                } label: {
                    Image(systemName: "info.circle")
                        .fontWeight(.medium)
                        .tint(.black)
                }
            }
            .padding(.bottom)
            
            Button(action: {
                viewModel.isRaffleAnimationFinished = false
                
                let selectedEntry = viewModel.raffleRandomEntry()
                viewModel.selectedLotteryEntry = selectedEntry
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    lotteryStore.addResult(id: .init(), date: Date(), entry: selectedEntry, in: viewModel.lottery)
                }
            }, label: {
                Text("Raffle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .padding(.bottom)
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.lottery.entries.count == .zero)
        }
        .padding()
        .background(color)
    }
}

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryDetailView(viewModel: LotteryDetailViewModel(lottery: .example))
        }
    }
}
