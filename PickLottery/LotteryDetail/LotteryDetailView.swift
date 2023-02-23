import SwiftUI

struct LotteryDetailView: View {
    @StateObject var lottery: Lottery
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LotteryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryDetailView(lottery: Lottery(
            name: "Lottery 1",
            entries:
                [
                    .init(name: "João", weight: 1, winningCounter: 0),
                    .init(name: "Maria", weight: 0, winningCounter: 1),
                    .init(name: "James", weight: 1, winningCounter: 0),
                    .init(name: "Ana", weight: 1.5, winningCounter: 2)
                ]
        ))
    }
}
