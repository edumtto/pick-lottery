import AVFoundation
import Foundation
import SwiftUI

fileprivate struct RaffleItem: Identifiable {
    let id: UUID
    let name: String
    let color: Color
    let offset: CGFloat
    
    init(_ entry: LotteryEntryMO, offset: CGFloat = 0) {
        id = entry.id
        name = entry.name
        color = entry.color
        self.offset = offset
    }
    
    init(id: UUID = .init(), name: String = "", color: Color = .white, offset: CGFloat = 0) {
        self.id = id
        self.name = name
        self.color = color
        self.offset = offset
    }
}

struct RaffleAnimationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    let entries: [LotteryEntryMO]
    let targetEntry: LotteryEntryMO
    
    @Binding var isRaffleAnimationFinished: Bool
    
    @State private var nextEntryIndex: Int = 0
    @State private var displayedItem: RaffleItem = .init()
    @State private var timer: Timer?
    @State private var winnerAnimation = false
    
    private let audioPlayer = AudioPlayer(sound: .pick)
    private let voiceSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(winnerAnimation ? targetEntry.color : .clear)
                .scaleEffect(winnerAnimation ? 3 : 0)

            Text(displayedItem.name)
                .padding()
                
                .multilineTextAlignment(.center)
                .font(.system(size: 42))
                .foregroundColor(fontColor)
                .scaleEffect(winnerAnimation ? 1 : 0.75)
                .fontWeight(winnerAnimation ? .bold : .regular)
                .background(winnerAnimation ? .white : .clear)
                .cornerRadius(4)
                .shadow(radius: winnerAnimation ? 8 : 0)
            resultTextView
        }
        .navigationBarItems(
            leading:
                Button("Close") {
                    dismiss()
                }.tint(.white),
            trailing:
                ShareLink(
                    item: "The lottery result is \"\(displayedItem.name)\"."
                ).tint(.white)
        )
        .onAppear {
            animateRaffle(times: 20, interval: 0.08)
        }
    }
    
    private var fontColor: Color {
        colorScheme == .dark && !winnerAnimation ? .white : .black
    }
    
    private var voiceUtterance: AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: targetEntry.name)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        return utterance
    }
    
    private var resultTextView: some View {
        VStack {
            Text("Picked:")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            Spacer()
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.compact.down")
                        .scaleEffect(2)
                        .tint(.white)
                }
            }
        }
        .opacity(winnerAnimation ? 1 : 0)
        .padding()
    }
    
    private func animateRaffle(times: Int, interval: Double) {
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
        // Sound effect
        audioPlayer?.play()
        
        timer?.invalidate()
        timer = nil
        if displayedItem.id != targetEntry.id {
            displayedItem = .init(targetEntry)
        }
        withAnimation {
            winnerAnimation = true
        }
        
        isRaffleAnimationFinished = true
        
        // Text do speech        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(600),
            execute: .init(block: {
            voiceSynthesizer.speak(voiceUtterance)
            })
        )
    }
    
    private func moveOneItem() {
        displayedItem = .init(nextEntry())
    }
    
    private func nextEntry() -> LotteryEntryMO {
        if entries.isEmpty {
            return .init()
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
    static let entries = LotteryMO.example0.entries.allObjects as! [LotteryEntryMO]
    
    static var previews: some View {
        NavigationStack {
            RaffleAnimationView(
                entries: entries,
                targetEntry: entries[1],
                isRaffleAnimationFinished: .constant(false)
            )
        }
    }
}
