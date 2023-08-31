import SwiftUI

struct LotteryCellView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: LotteryMO
    
    private var backgroundColor: Color {
        Color(hex: lottery.hexColor) ?? .gray
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 16, height: 16))
                .stroke(backgroundColor, lineWidth: 0.4)
                .background(
                    backgroundColor.brightness(0.2).opacity(0.5)
                )
                .cornerRadius(16)
                
            
            HStack(alignment: .center) {
                if let emojiText = lottery.illustration {
                    Text(emojiText)
                        .font(.largeTitle)
                        .shadow(color: .whiteDynamic, radius: 1)
                }
                
                Text(lottery.name)
                    .foregroundColor(.blackDynamic)
                    .font(.headline)
                    .shadow(color: .whiteDynamic, radius: 0.5)
                    
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.leading, 8)
            .padding(.trailing, 8)
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
