import SwiftUI

struct LotteryResultCellView: View {
    let result: LotteryResultMO
    
    private var dateTime: String {
        if Calendar.current.isDateInToday(result.date) {
            return result.date.formatted(date: .omitted, time: .shortened)
        } else {
            return result.date.formatted(date: .abbreviated, time: .omitted)
        }
       
    }
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundColor(result.entry.color)
            Text(result.entry.name)
            Spacer()
            Text(dateTime)
                .foregroundColor(.gray)
            //formatted(date: .abbreviated, time: .shortened))
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
