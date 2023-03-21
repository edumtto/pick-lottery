import Foundation
import SwiftUI

struct LotteryEntryCell: View {
    var entry: LotteryEntryMO
    
    var wins: Int {
        entry.results?.count ?? .zero
    }
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundColor(entry.color)
            Text(entry.name)
            Spacer()
            if wins == 1 {
                trophyImage
            } else if wins > 1 {
                HStack(spacing: 0) {
                    Text("\(wins)x")
                    trophyImage
                }
            }
            HStack(spacing: 0) {
                Image(systemName: "scalemass.fill")
                    .foregroundColor(.gray)
                Text(String(format: "%.1f", entry.weight))
            }
            .padding(.leading, 8)
        }.opacity(entry.weight == 0 ? 0.5 : 1)
    }
    
    var trophyImage: some View {
        Image(systemName: "trophy.fill")
            .foregroundColor(.yellow)
    }
}

struct LotteryEntryCell_Previews: PreviewProvider {
    static var previews: some View {
        return LotteryEntryCell(entry: .example)
            .previewLayout(.sizeThatFits)
    }
}
