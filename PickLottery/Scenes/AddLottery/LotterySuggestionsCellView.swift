import SwiftUI

struct LotterySuggestionsCellView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: Lottery
    
    private var backgroundColor: Color {
        Color(hex: lottery.color) ?? .primary
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 8, height: 8))
                .stroke(backgroundColor, lineWidth: 0.5)
                .background(backgroundColor.brightness(0.2))
                .cornerRadius(8)
                .padding(2)
            
            VStack {
                if let emojiText = lottery.illustration?.rawValue {
                    Text(emojiText)
                        .font(.largeTitle)
                }
                
                Text(lottery.name)
                    .foregroundColor(.black)
                    .font(.headline)
                
                if let description = lottery.description {
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

struct LotterySuggestionsCellView_Previews: PreviewProvider {
    static var lottery: Lottery {
        let entries: [Lottery.Entry] = [1, 2, 3, 4, 5, 6].map { Lottery.Entry.init(String($0)) }
        return Lottery(name: "Dice", description: "Roll a tradicional six face dice", illustration: .dice, entries: entries, results: .init())
    }
    
    static var previews: some View {
        LotterySuggestionsCellView(lottery: lottery)
    }
}
