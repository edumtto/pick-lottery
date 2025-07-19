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
                raffleButton
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
                Menu {
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
                } label: {
                    Image(systemName: "ellipsis")
                        .tint(.accentColor)
                }
            }
        }
        .navigationTitle(viewModel.lottery.name)
    }
    
    private var raffleResults: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(viewModel.lastResults) { result in
                    LotteryResultCellView(result: result)
                }
            }
            .listStyle(.plain)
        }
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(viewModel.color, lineWidth: 2)
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 16))
//        .padding(.leading)
//        .padding(.trailing)
        .padding(.top)
    }
    
    private var raffleDescription: some View {
        VStack {
            if let description = viewModel.lottery.descriptionText {
                HStack {
                    Text(description)
                    Spacer()
                }
                .padding(.bottom)
            }
            
            HStack {
                Button {
                    viewModel.presentRaffleModeDescription.toggle()
                } label: {
                    propertyLabel(
                        title: viewModel.modeDescription,
                        illustration: "dice")
                }
                
                NavigationLink {
                    LotteryEntriesView(
                        viewModel: .init(
                            lottery: $viewModel.lottery,
                            lotteryStore: lotteryStore
                        )
                    )
                } label: {
                    propertyLabel(
                        title: viewModel.entriesAmmountText,
                        illustration: "list.triangle")
                }
                Spacer()
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
    
    private var backgroundBrighness: Double {
        colorScheme == .dark ? -0.2 : 0.2
    }
    
    private var raffleButton: some View {
        Group {
            if viewModel.isEntriesEmpty {
                NavigationLink("Register entries") {
                    LotteryEntriesView(
                        viewModel: .init(
                            lottery: $viewModel.lottery,
                            lotteryStore: lotteryStore
                        )
                    )
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .accentColor))
            } else {
                Button(viewModel.drawButtonTitle) {
                    viewModel.raffleButtonAction()
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .accentColor))
            }
        }
    }
    
    private func propertyLabel(title: String, illustration: String) -> some View {
        HStack {
            Image(systemName: illustration)
                .tint(.gray)
            Text(title)
                .tint(.gray)
                .fontWeight(.medium)
                .padding(2)
                .cornerRadius(8)
        }
        .padding(4)
        .font(.footnote)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
//                .inset(by: 0.5)
                .stroke(.black, lineWidth: 0.5)
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
