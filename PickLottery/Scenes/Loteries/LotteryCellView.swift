import SwiftUI

struct LotteryCellView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: LotteryMO
    
    
    var body: some View {
        HStack(alignment: .center) {
            if let emojiText = lottery.illustration {
                Text(emojiText)
                    .font(.largeTitle)
            }
            VStack(alignment: .leading) {
                Text(lottery.name)
                    .foregroundColor(.blackDynamic)
                    .font(.headline)
                    .shadow(color: .whiteDynamic, radius: 0.5)
                if let description = lottery.descriptionText {
                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                
            }
            Spacer()
        }
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryCellView(lottery: .example0)
            .border(.black)
            .previewLayout(.fixed(width: 350, height: 100))
            .padding()
    }
}
