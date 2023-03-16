import SwiftUI

struct LotteryCellView: View {
    let lottery: LotteryMO
    
    private var headerColor: Color {
        (Color(hex: lottery.hexColor) ?? .primary)
            .opacity(0.2)
    }
    
    var body: some View {
        NavigationLink {
            LotteryDetailView(lottery: lottery)
        } label: {
            ZStack {
                headerColor
                
                Text(lottery.name)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding()
            }
            .frame(minHeight: 100)
        }
        .cornerRadius(8)
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        let lottery = LotteryMO()
        lottery.name = "Teste 1 2 3"
        
        return LotteryCellView(lottery: lottery)
    }
}
