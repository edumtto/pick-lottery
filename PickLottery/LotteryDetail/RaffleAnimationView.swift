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
    let entries: [LotteryEntry]
    let targetEntry: LotteryEntry
    
    @Binding var isRaffleFinished: Bool
    
    @State private var nextEntryIndex: Int = 0
    @State private var displayedItem: RaffleItem = .init(.init(""))
    @State private var timer: Timer?
    @State private var raffleFinishedAnimation = false
    
    var body: some View {
        ZStack {
            Text(displayedItem.name)
                .font(.headline)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 32, height: 52)

                .offset(.init(width: 0, height: displayedItem.offset))
                .scaleEffect(raffleFinishedAnimation ? 1.4 : 1)
            resultTextView

        }
        .onAppear {
            animateRaffle(times: 50, interval: 0.02)
        }
    }
    
    var resultTextView: some View {
        VStack {
            Text("Congratulations!")
                
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .stroke(displayedItem.color)
            Spacer()
        }.opacity(raffleFinishedAnimation ? 1 : 0)
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
                animateRaffle(times: times - times / 2, interval: 1.2 * interval)
            }
        }
    }
    
    private func endAnimation() {
        timer?.invalidate()
        timer = nil
        if displayedItem.id != targetEntry.id {
            displayedItem = .init(targetEntry)
        }
        withAnimation {
            raffleFinishedAnimation = true
        }
        isRaffleFinished = true
    }
    
    private func moveOneItem() {
        displayedItem = .init(nextEntry())
    }
    
    private func nextEntry() -> LotteryEntry {
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
        RaffleAnimationView(entries: entriesMock, targetEntry: entriesMock[1], isRaffleFinished: .constant(false))
    }
}
