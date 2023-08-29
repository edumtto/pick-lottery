import SwiftUI

struct LotteryCellView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: LotteryMO
    
    private var backgroundColor: Color {
        Color(hex: lottery.hexColor) ?? .primary
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 8, height: 8))
                .stroke(backgroundColor, lineWidth: 2)
                .background(backgroundColor)
                .cornerRadius(16)
                
            
            VStack(spacing: 4) {
                if let emojiText = lottery.illustration {
                    Text(emojiText)
                        .font(.largeTitle)
                        .shadow(color: .white, radius: 1)
                        .padding(.top, 8)
                }
                
                Text(lottery.name)
                    .foregroundColor(.white)
                    .font(.headline)
                    .shadow(radius: 1)
                    .padding(.bottom, 8)
                    
                
//                if let description = lottery.descriptionText {
//                    Text(description)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                        .font(.caption)
//                        .shadow(radius: 1)
//                        .padding(.top, 4)
//                }
            }
            .padding(8)
        }
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryCellView(lottery: .example0)
            .previewLayout(.fixed(width: 350, height: 100))
            .padding()
    }
}
