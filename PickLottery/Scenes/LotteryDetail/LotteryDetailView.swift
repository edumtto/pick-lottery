import SwiftUI
import Combine

struct LotteryDetailView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: LotteryDetailViewModel
    
    var body: some View {
        ZStack {
            VStack {
                raffleDescription
                Spacer()
                raffleResults
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    raffleButton
                        .padding()
                }
            }
        }
        .sheet(isPresented: $viewModel.presentRaffleAnimation) {
            if let selectedEntry = viewModel.selectedLotteryEntry {
                NavigationStack {
                    DefaultRaffleAnimationView(
                        entries: viewModel.entries,
                        targetEntry: selectedEntry,
                        isRaffleAnimationFinished: $viewModel.isRaffleAnimationFinished)
                }
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
                    Button {
                        viewModel.clearResults()
                    } label: {
                        Label("Clear results", systemImage: "eraser")
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
    
    private var raffleResults: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Last results:")
                    .font(.headline)
                Spacer()
            }
            .padding()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.lastResults) { result in
                        LotteryResultCellView(result: result)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
    
    private var raffleDescription: some View {
        VStack {
            HStack {
                Button {
                    viewModel.presentRaffleModeDescription.toggle()
                } label: {
                    propertyLabel(title: viewModel.modeDescription, illustration: "exclamationmark.circle")
                }
                
                NavigationLink {
                    LotteryEntriesView(
                        viewModel: .init(
                            lottery: $viewModel.lottery,
                            lotteryStore: lotteryStore
                        )
                    )
                } label: {
                    propertyLabel(title: String(viewModel.lottery.entries.count), illustration: "list.triangle")
                }
                Spacer()
            }
            .padding()
            Divider()
                .frame(height: 1)
                .overlay(viewModel.color)
        }
        .background(
            viewModel.color
            .brightness(backgroundBrighness)
            .ignoresSafeArea()
        )
    }
    
    private var backgroundBrighness: Double {
        colorScheme == .dark ? -0.2 : 0.2
    }
    
    private var raffleButton: some View {
        Button(action: {
            viewModel.raffleButtonAction()
        }, label: {
            Text("Draw")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 70, minHeight: 70)
                .background(Color.primary)
                .cornerRadius(16)
        })
        .shadow(color: .whiteDynamic, radius: 16)
        .disabled(viewModel.lottery.entries.count == .zero)
    }
    
    private func propertyLabel(title: String, illustration: String) -> some View {
        HStack {
            Image(systemName: illustration)
                .tint(.primary)
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .padding(2)
                .cornerRadius(8)
        }
        .padding(8)
        .background(.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(viewModel.color, lineWidth: 1)
        )
    }
}

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryDetailView(viewModel: LotteryDetailViewModel(lottery: .example0, lotteryStore: LotteryStore.preview))
        }
    }
}
