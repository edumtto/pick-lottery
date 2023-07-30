import SwiftUI

struct AddLotteryView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var lotteryStore: LotteryStore
    @StateObject var viewModel: AddLotteryViewModel
    
    var body: some View {
        VStack {
            suggestionsView
                .padding()
            Spacer()
            
            NavigationLink("New lottery") {
                CreateLotteryView(isPresented: $isPresented, viewModel: .init(lotteryStore: lotteryStore))
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationTitle("Add lottery")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented = false
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
                LazyVStack {
                    ForEach(viewModel.suggestions) { suggestion in
                        LotterySuggestionsCellView(lottery: suggestion)
                            .onTapGesture {
                                isPresented = false
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
            AddLotteryView(isPresented: .constant(true), viewModel: AddLotteryViewModel(lotteryStore: LotteryStore.preview))
        }
    }
}
