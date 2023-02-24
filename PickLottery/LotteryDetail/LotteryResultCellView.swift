import SwiftUI

struct LotteryResultCellView: View {
    @Binding var result: LotteryResult
    
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
            result:.constant(.init(entry: .init("Joao"),
                                   date: Date()))
        )
    }
}
