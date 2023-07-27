import SwiftUI

struct LotterySuggestionsCellView: View {
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: Lottery
    
    private var backgroundColor: Color {
        Color(hex: lottery.color) ?? .primary
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 8, height: 8))
                .stroke(backgroundColor, lineWidth: 2)
                .background(backgroundColor.brightness(0.2))
                .cornerRadius(8)
                .padding(2)
            
            HStack {
                if let emojiText = lottery.illustration?.rawValue {
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
                    if let description = lottery.description {
                        HStack {
                            Text(description)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                .font(.caption)
                            Spacer()
                        }
                    }
                }
                Image(systemName: "plus")
                    .foregroundColor(backgroundColor)
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
