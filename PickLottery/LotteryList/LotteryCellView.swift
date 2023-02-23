import SwiftUI

struct LotteryCellView: View {
    var lottery: Lottery
    
    var body: some View {
        NavigationLink {
            LotteryDetailView(lottery: lottery)
        } label: {
            ZStack {
                lottery.color.opacity(0.2)
                
                Text(lottery.name)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }

        
        .cornerRadius(8)
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryCellView(lottery: .init(name: "Loteria com nome muito grande, gigantesco para caramba"))
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
