import SwiftUI

struct LotteryResultCellView: View {
    let result: LotteryResultMO
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundColor(result.entry.color)
            Text(result.entry.name)
            Spacer()
            Text(result.date.formatted(date: .abbreviated, time: .shortened))
        }
    }
}

struct LotteryResultCellView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryResultCellView(
            result: LotteryMO.example0.results.allObjects[0] as! LotteryResultMO
        )
        .previewLayout(.sizeThatFits)
    }
}
