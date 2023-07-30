import SwiftUI
import Combine

struct LotteryDetailView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: LotteryDetailViewModel
    
    var body: some View {
        VStack {
            raffleResults
            Spacer()
            raffleDescription
        }
        .sheet(isPresented: $viewModel.presentRaffleAnimation) {
            NavigationStack {
                RaffleAnimationView(
                    entries: viewModel.entries,
                    targetEntry: viewModel.selectedLotteryEntry,
                    isRaffleAnimationFinished: $viewModel.isRaffleAnimationFinished)
            }
        }
        .sheet(isPresented: $viewModel.presentRaffleModeDescription) {
            NavigationStack {
                Text(viewModel.modeDetailedDescription)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                Spacer()
                    .navigationTitle(viewModel.modeDescription)
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
            HStack {
                Text("Last results:")
                    .font(.headline)
                Spacer()
            }
            
                
            ScrollView {
//                if viewModel.lastResults.isEmpty {
//                    Text("No results yet! Tap \"Raffle\" to run the lottery.")
//                        .foregroundColor(.gray)
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
                    NavigationLink {
                        LotteryEntriesView(
                            viewModel: .init(
                                lottery: $viewModel.lottery,
                                lotteryStore: lotteryStore
                            )
                        )
                    } label: {
                        rafflePropertyLabel(title: "Entries", description: String(viewModel.lottery.entries.count))
                    }
                    
                    Button {
                        viewModel.presentRaffleModeDescription.toggle()
                    } label: {
                        rafflePropertyLabel(title: "Mode", description: viewModel.modeDescription)
                    }
                }
                .padding()
                raffleButton
                    .padding()
            }
        }
        .background(viewModel.color.brightness(0.2).ignoresSafeArea())
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
    
    func rafflePropertyLabel(title: String, description: String) -> some View {
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

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryDetailView(viewModel: LotteryDetailViewModel(lottery: .example0, lotteryStore: LotteryStore.preview))
        }
    }
}
