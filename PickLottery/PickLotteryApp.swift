import SwiftUI

@main
struct PickLotteryApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LotteryListView(
                lotteries: [
                    .init(
                        name: "Supper Lottery 1",
                        entries:  [
                            .init("João", weight: 1, winningCounter: 0),
                            .init("Maria", weight: 0, winningCounter: 1),
                            .init("James", weight: 1, winningCounter: 0),
                            .init("Ana", weight: 1.5, winningCounter: 2)
                        ],
                        lastResults: [
                            .init(entry: .init("João"), date: Date()),
                            .init(entry: .init("Maria"), date: Date()),
                            .init(entry: .init("James"), date: Date()),
                            .init(entry: .init("Ana"), date: Date())
                        ]
                    ),
                    .init(
                        name: "🎲\nDice",
                        entries:  [.init("1"), .init("2"), .init("3"), .init("4"), .init("5"), .init("6")]
                    )
//                    .init(name: "Extra large name for a Lottery 2"),
//                    .init(name: "Lottery 3"),
//                    .init(name: "Lottery 4"),
//                    .init(name: "Lottery 5"),
//                    .init(name: "Lottery 6"),
//                    .init(name: "Supper Lottery 1"),
//                    .init(name: "Extra large name for a Lottery 2"),
//                    .init(name: "Lottery 3"),
//                    .init(name: "Lottery 4"),
//                    .init(name: "Lottery 5"),
//                    .init(name: "Lottery 6"),
                ]
            )
            //ContentView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
