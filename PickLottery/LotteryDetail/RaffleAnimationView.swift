import SwiftUI
import Foundation

struct RaffleItem: Identifiable {
    let id: UUID
    let name: String
    let color: Color
    let offset: CGFloat
    
    init(_ entry: LotteryEntry, offset: CGFloat = 0) {
        id = entry.id
        name = entry.name
        color = entry.color
        self.offset = offset
    }
}

struct RaffleAnimationView: View {
    @Environment(\.dismiss) var dismiss
    
    let entries: [LotteryEntry]
    let targetEntry: LotteryEntry?
    
    @Binding var isRaffleAnimationFinished: Bool
    
    @State private var nextEntryIndex: Int = 0
    @State private var displayedItem: RaffleItem = .init(.init(""))
    @State private var timer: Timer?
    @State private var winnerAnimation = false
    
    var body: some View {
        ZStack {
            Text(displayedItem.name)
                .font(.system(size: winnerAnimation ? 36 : 28))
                .padding()
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .stroke(displayedItem.color)
                .frame(height: 128)
                .frame(width: UIScreen.main.bounds.width - 32, height: 52)
            resultTextView
        }
        .background(.white)
        .onAppear {
            animateRaffle(times: 20, interval: 0.08)
        }
    }
    
    var resultTextView: some View {
        VStack {
            Text("Congratulations!🏆")
                .font(.title)
                .padding()
            Spacer()
            HStack {
                ShareLink(item: "The lottery winner is \"\(displayedItem.name)\".")
                .buttonStyle(.borderedProminent)
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .opacity(winnerAnimation ? 1 : 0)
        .padding()
    }
    
    func animateRaffle(times: Int, interval: Double) {
        if times <= 1 {
            endAnimation()
            return
        }
        
        var counter = times
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            counter -= 1
            moveOneItem()
            
            if counter == 0 {
                animateRaffle(times: Int(Double(times) * 0.2), interval: 1.3 * interval)
            }
        }
    }
    
    private func endAnimation() {
        timer?.invalidate()
        timer = nil
        if let targetEntry = targetEntry, displayedItem.id != targetEntry.id {
            displayedItem = .init(targetEntry)
        }
        withAnimation {
            winnerAnimation = true
        }
        isRaffleAnimationFinished = true
    }
    
    private func moveOneItem() {
        displayedItem = .init(nextEntry())
    }
    
    private func nextEntry() -> LotteryEntry {
        if entries.isEmpty {
            return .init("")
        }
        
        let entry = entries[nextEntryIndex]
        nextEntryIndex += 1
        if nextEntryIndex >= entries.count {
            nextEntryIndex = 0
        }
        return entry
    }
}

struct RaffleAnimationView_Previews: PreviewProvider {
    static let entriesMock: [LotteryEntry] = [
        .init("João", weight: 1, winningCounter: 0),
        .init("Maria", weight: 0, winningCounter: 1),
        .init("James", weight: 1, winningCounter: 0),
        .init("Ana", weight: 1.5, winningCounter: 2)
    ]
    
    static var previews: some View {
        RaffleAnimationView(entries: entriesMock, targetEntry: entriesMock[1], isRaffleAnimationFinished: .constant(false))
    }
}
