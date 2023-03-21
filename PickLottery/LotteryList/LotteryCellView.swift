import SwiftUI

struct LotteryCellView: View {
    let lottery: LotteryMO
    
    private var backgroundColor: Color {
        (Color(hex: lottery.hexColor) ?? .primary)
    }
    
    
    var body: some View {
        NavigationLink {
            LotteryDetailView(viewModel: .init(lottery: lottery))
        } label: {
            ZStack {
                backgroundColor
                
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
        LotteryCellView(lottery: .example)
            .previewLayout(.fixed(width: 150, height: 150))
            .padding()
    }
}
