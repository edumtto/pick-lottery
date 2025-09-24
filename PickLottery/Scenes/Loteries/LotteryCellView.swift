import SwiftUI

struct LotteryCellView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var lotteryStore: LotteryStore
    let emoji: String?
    let name: String
    let description: String?
    
    
    var body: some View {
        HStack(alignment: .center) {
            if let emojiText = emoji {
                Text(emojiText)
                    .font(.largeTitle)
            }
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundColor(.blackDynamic)
                    .font(.headline)
                    .shadow(color: .whiteDynamic, radius: 0.5)
                if let description = description {
                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                
            }
            Spacer()
//            Menu {
//                Button("Draw", action: draw)
//                Button("Details", action: draw)
//            } label: {
//                // The label that appears in the menu bar
//                Label("", systemImage: "ellipsis")
//            }
        }
    }
    
    func draw() {
        
    }
}

struct LotteryCellView_Previews: PreviewProvider {
    static var previews: some View {
        let lottery: LotteryMO = .example0
        LotteryCellView(emoji: lottery.illustration, name: lottery.name, description: lottery.descriptionText)
            .border(.black)
            .previewLayout(.fixed(width: 350, height: 100))
            .padding()
    }
}
