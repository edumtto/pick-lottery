import SwiftUI

struct LotteryEntriesView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: LotteryEntriesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.entries) { entry in
                LotteryEntryCell(entry: entry)
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .scrollContentBackground(.hidden)
        
        .listRowSeparatorTint(viewModel.color, edges: .all)
        .background(viewModel.color.brightness(backgroundBrighness).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(role: .none) {
                    viewModel.showCreateEntry.toggle()
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .navigationTitle("Entries")
        .sheet(isPresented: $viewModel.showCreateEntry) {
            NavigationStack {
                CreateEntryView(
                    viewModel: .init(
                        lotteryStore: viewModel.lotteryStore,
                        lottery: viewModel.lottery
                    )
                )
                .accentColor(.navBarDynamic)
            }
        }
    }
    
    private var backgroundBrighness: Double {
        colorScheme == .dark ? -0.2 : 0.2
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEntriesView(
                viewModel: .init(
                    lottery: .constant(.example0),
                    lotteryStore: LotteryStore.preview
                )
            )
        }
    }
}
