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
                .stroke(backgroundColor, lineWidth: 0.5)
                .background(backgroundColor.brightness(0.2))
                .cornerRadius(8)
                .padding(2)
            
            VStack {
                if let emojiText = lottery.illustration {
                    Text(emojiText)
                        .font(.largeTitle)
                }
                
                Text(lottery.name)
                    .foregroundColor(.black)
                    .font(.headline)
                
                if let description = lottery.descriptionText {
                    Text(description)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .font(.caption)
                }
            }
            .padding(12)
        }
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryCellView(lottery: .example)
            .previewLayout(.fixed(width: 350, height: 100))
            .padding()
    }
}
