import SwiftUI

struct AddLotteryView: View {
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
    }
    
    var suggestionsView: some View {
        VStack {
            Text("Suggestions")
            //ScrollView {
            LazyVGrid(columns: twoColumnGrid, spacing: 8) {
                ForEach(viewModel.suggestions) { suggestion in
                    LotterySuggestionsCellView(lottery: suggestion)
                }
            }
        }
    }
}

struct SugestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddLotteryView(viewModel: AddLotteryViewModel())
        }
    }
}

