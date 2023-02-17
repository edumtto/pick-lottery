import SwiftUI

struct CustomLotteryView: View {
    @State var entries: [CustomEntry] = [
        .init(name: "João", weight: 1, winningCounter: 0),
        .init(name: "Maria", weight: 0, winningCounter: 1),
        .init(name: "James", weight: 1, winningCounter: 0),
        .init(name: "Ana", weight: 1.5, winningCounter: 2)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Toggle("Consider weight", isOn: .constant(false))
                    Button(role: .none) {
                        print("Info")
                    } label: {
                        Image(systemName: "info.circle")
                    }

                }
                HStack {
                    Toggle("Distritute victories", isOn: .constant(false))
                    Button(role: .none) {
                        print("Info")
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                
                Button("Raffle") {
                    
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .padding()
            
            List {
                ForEach($entries) { entry in
                    CustomLotteryCell(entry: entry)
                }
            }
            .navigationTitle("Game name")
            .toolbar {
                Button("Import") {
                    
                }
                Button("Edit") {
                    
                }
                Image(systemName: "plus.app")
            }
        }
    }
}

struct CustomLottery_Previews: PreviewProvider {
    static var previews: some View {
        CustomLotteryView()
    }
}
