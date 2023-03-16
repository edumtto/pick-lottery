import Foundation
import SwiftUI

struct LotteryEntryCell: View {
    var entry: LotteryEntryMO
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundColor(entry.color)
            Text(entry.name)
            Spacer()
            HStack(spacing: 0) {
                Image(systemName: entry.weight == 0 ? "scalemass" : "scalemass.fill")
                Text(String(format: "%.1f", entry.weight))
                
            }
            HStack(spacing: 0) {
                Image(systemName: entry.wins == 0 ? "trophy": "trophy.fill")
                Text("\(entry.wins)")
            }
        }.opacity(entry.weight == 0 ? 0.5 : 1)
    }
}

struct LotteryEntryCell_Previews: PreviewProvider {
    static var previews: some View {
        return LotteryEntryCell(entry: .example)
            .previewLayout(.sizeThatFits)
    }
}
