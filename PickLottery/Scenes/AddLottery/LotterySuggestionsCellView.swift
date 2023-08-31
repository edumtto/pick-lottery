import SwiftUI

struct LotterySuggestionsCellView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: Lottery
    
    private var backgroundColor: Color {
        Color(hex: lottery.color) ?? .gray
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .init(width: 16, height: 16))
                .stroke(backgroundColor, lineWidth: 0.4)
                .background(
                    backgroundColor.brightness(0.2).opacity(0.5)
                )
                .cornerRadius(16)
                .padding(2)
            
            HStack {
                if let emojiText = lottery.illustration {
                    Text(emojiText)
                        .font(.largeTitle)
                        .shadow(color: .white, radius: 0.5)
                }
                VStack {
                    HStack {
                        Text(lottery.name)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.blackDynamic)
                            .font(.headline)
                        Spacer()
                    }
                    if let description = lottery.description {
                        HStack {
                            Text(description)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.blackDynamic)
                                .font(.caption)
                            Spacer()
                        }
                    }
                }
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }
            .padding(12)
        }
    }
}

struct LotterySuggestionsCellView_Previews: PreviewProvider {
    static var lottery: Lottery {
        let entries: [Lottery.Entry] = [1, 2, 3, 4, 5, 6].map { Lottery.Entry.init(String($0)) }
        return Lottery(name: "Dice", description: "Roll a tradicional six face dice", illustration: "🎲", entries: entries, results: .init())
    }

    static var previews: some View {
        LotterySuggestionsCellView(lottery: lottery)
    }
}
