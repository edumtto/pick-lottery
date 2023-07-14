import SwiftUI

struct AddLotteryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    @StateObject var viewModel: AddLotteryViewModel
    
    private let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            suggestionsView
                .padding()
            Spacer()
            
            NavigationLink("Criar") {
                CreateLotteryView(viewModel: .init(lotteryStore: lotteryStore))
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationTitle("Add lottery")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    var suggestionsView: some View {
        VStack {
            HStack {
                Text("Suggestions:")
                    .font(.title2)
                Spacer()
            }
            ScrollView {
                LazyVGrid(columns: twoColumnGrid, spacing: 8) {
                    ForEach(viewModel.suggestions) { suggestion in
                        LotterySuggestionsCellView(lottery: suggestion)
                            .onTapGesture {
                                dismiss()
                                viewModel.addLottery(suggestion)
                            }
                    }
                }
            }
        }
    }
}

struct SugestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddLotteryView(viewModel: AddLotteryViewModel(lotteryStore: LotteryStore.preview))
        }
    }
}
