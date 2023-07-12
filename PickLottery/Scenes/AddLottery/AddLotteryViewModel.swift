import Foundation

final class AddLotteryViewModel: ObservableObject {
    @Published var suggestions: [Lottery] = [
        .init(name: "Test 1", description: "Bla bla bla", illustration: .book),
        .init(name: "Test 2", description: "Bla bla bla", illustration: .clock),
        .init(name: "Test 3", description: "Bla bla bla", illustration: .fruit)
    ]
    
    
    
}
