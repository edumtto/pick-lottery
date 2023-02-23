import SwiftUI

struct LotteryEditView: View {
    @StateObject var lottery: Lottery
    @State var numberOfTimes: Int = 1
    
    var body: some View {
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
            Picker("Number or times", selection: $numberOfTimes) {
                ForEach(1..<10) {
                    Text("\($0) times")
                }
            }
            Button("Raffle") {
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
           
        }
        .padding()
        
        List {
            ForEach($lottery.entries) { entry in
                LotteryEntryCell(entry: entry)
            }
        }
        .navigationTitle(lottery.name)
        .toolbar {
            Button("Import") {
                
            }
            Button("Edit") {
                
            }
            Button(role: .none) {
                
            } label: {
                Image(systemName: "plus.app")
            }
        }
    }
}

struct LotteryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LotteryEditView(lottery:
                Lottery(
                    name: "Lottery 1",
                    entries:
                        [
                            .init(name: "João", weight: 1, winningCounter: 0),
                            .init(name: "Maria", weight: 0, winningCounter: 1),
                            .init(name: "James", weight: 1, winningCounter: 0),
                            .init(name: "Ana", weight: 1.5, winningCounter: 2)
                        ]
                )
            )
        }
    }
}
