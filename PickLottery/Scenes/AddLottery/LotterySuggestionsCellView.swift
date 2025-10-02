import SwiftUI

struct LotterySuggestionsCellView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var lotteryStore: LotteryStore
    let lottery: Lottery
    
    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerSize: .init(width: 16, height: 16))
//                .stroke(Color.black, lineWidth: 0.4)
//                .cornerRadius(16)
//                .padding(2)
            
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
                    if let description = lottery.description {
                        Text(description)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    
                    //                    .foregroundColor(.black)
                }
                Spacer()
                Image(systemName: "plus")
            }
//            .padding()
        }
//    }
}

struct LotterySuggestionsCellView_Previews: PreviewProvider {
    static var lottery: Lottery {
        let entries: [Lottery.Entry] = [1, 2, 3, 4, 5, 6].map { Lottery.Entry.init(String($0)) }
        return Lottery(name: "Dice", description: "Roll a tradicional six face dice", illustration: "🎲", entries: entries, results: .init())
    }

    static var previews: some View {
        VStack {
            LotterySuggestionsCellView(lottery: lottery)
            LotterySuggestionsCellView(lottery: lottery)
            LotterySuggestionsCellView(lottery: lottery)
            LotterySuggestionsCellView(lottery: lottery)
            Spacer()
        }
      
    }
}
