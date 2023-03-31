import SwiftUI
import Combine

struct LotteryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: LotteryDetailViewModel
    
    var body: some View {
        VStack {
            raffleResults
            Spacer()
            raffleDescription
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
        .sheet(isPresented: $viewModel.presentEntryEditor) {
            NavigationStack {
                LotteryEntriesView(lottery: viewModel.lottery)
            }
        }
        .sheet(isPresented: $viewModel.presentRaffleModeDescription) {
            NavigationStack {
                Text("Explanation...")
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem {
                Menu("Options") {
                    Button("Clear results") {
                        viewModel.clearResults()
                    }
                    Button {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            viewModel.deleteLottery()
                        }
                    } label: {
                        Label("Delete lottery", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle(viewModel.lottery.name)
    }
    
    var raffleResults: some View {
        VStack(alignment: .leading) {
            Text("Last winners:")
                .font(.headline)
            ScrollView {
//                if viewModel.lastResults.isEmpty {
//                    Text("No results yet! Tap \"Raffle\" to run the lottery.")
//                } else {
                    LazyVStack {
                        ForEach(viewModel.lastResults) { result in
                            LotteryResultCellView(result: result)
                        }
                    }
//                }
            }
        }
        .padding()
    }
    
    var raffleDescription: some View {
        VStack {
            Divider()
                .frame(height: 2)
                .overlay(viewModel.color)
            
            HStack {
                VStack(alignment: .leading) {
                    raffleProperty(title: "Entries", description: String(viewModel.lottery.entries.count), action: {
                        viewModel.presentEntryEditor.toggle()
                    })
                    
                    raffleProperty(title: "Mode", description: viewModel.modeDescription, action: {
                        viewModel.presentRaffleModeDescription.toggle()
                    })
                }
                .padding()
                raffleButton
                    .padding()
            }
        }
        .background(viewModel.color.opacity(0.2))
    }
    
    var raffleButton: some View {
        Button(action: {
            viewModel.raffleButtonAction()
        }, label: {
            Text("Raffle")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 70, minHeight: 70)
                .background(Color.accentColor)
                .cornerRadius(16)
            
        })
        .disabled(viewModel.lottery.entries.count == .zero)
    }
    
    func raffleProperty(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title + ":")
                    .foregroundColor(.black)
                Text(description)
                    .foregroundColor(Color.accentColor)
                    .fontWeight(.medium)
                    .underline()
                    .padding(2)
                Spacer()
            }
        }
    }
}

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryDetailView(viewModel: LotteryDetailViewModel(lottery: .example, lotteryStore: LotteryStore.preview))
        }
    }
}
