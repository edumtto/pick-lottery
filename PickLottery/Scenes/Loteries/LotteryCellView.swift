import SwiftUI

struct LotteryCellView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: LotteryMO
    
    private var backgroundColor: Color {
        (Color(hex: lottery.hexColor) ?? .primary)
    }
    
    var body: some View {
        NavigationLink {
            LotteryDetailView(viewModel: .init(lottery: lottery, lotteryStore: lotteryStore))
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: .init(width: 8, height: 8))
                    .stroke(backgroundColor, lineWidth: 0.5)
                    .background(backgroundColor.brightness(0.2))
                    .cornerRadius(8)
                    .padding(2)
                
                HStack {
                    if let emojiText = lottery.illustration {
                        Text(emojiText)
                            .font(.largeTitle)
                    }
                    VStack {
                        HStack {
                            Text(lottery.name)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                .font(.headline)
                            Spacer()
                        }
                        if let description = lottery.descriptionText {
                            HStack {
                                Text(description)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                                    .font(.caption)
                                Spacer()
                            }
                        }
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(backgroundColor)
                }
                .padding(12)
            }
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
