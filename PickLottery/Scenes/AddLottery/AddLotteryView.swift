import SwiftUI

struct AddLotteryView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var lotteryStore: LotteryStore
    @StateObject var viewModel: AddLotteryViewModel
    
    var body: some View {
        ZStack {
            suggestionsView
                .safeAreaPadding(.bottom, 100)
                .scrollContentBackground(.hidden)
            
            // Floating button container
            VStack {
                Spacer()
                
                NavigationLink("New lottery") {
                    CreateLotteryView(isPresented: $isPresented, viewModel: .init(lotteryStore: lotteryStore))
                }
                .buttonStyle(PrimaryButtonStyle())
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                .padding(.trailing, 16)
            }
            .padding(.bottom, 24)
            
        }
        .navigationTitle("Suggestions")
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
            List {
                ForEach(viewModel.suggestions) { suggestion in
                    LotterySuggestionsCellView(lottery: suggestion)
                        .onTapGesture {
                            isPresented = false
                            viewModel.addLottery(suggestion)
                        }
                }
            }
            .listRowSpacing(8)
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
