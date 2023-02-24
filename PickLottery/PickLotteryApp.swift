import SwiftUI

@main
struct PickLotteryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LotteryListView(lotteries: [
                .init(name: "Supper Lottery 1", entries:  [
                    .init(name: "João", weight: 1, winningCounter: 0),
                    .init(name: "Maria", weight: 0, winningCounter: 1),
                    .init(name: "James", weight: 1, winningCounter: 0),
                    .init(name: "Ana", weight: 1.5, winningCounter: 2)
                ],
                lastResults: [
                    .init(entry: .init(name: "João", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init(name: "Maria", weight: 0, winningCounter: 1), date: Date()),
                    .init(entry: .init(name: "James", weight: 1, winningCounter: 0), date: Date()),
                    .init(entry: .init(name: "Ana", weight: 1, winningCounter: 0), date: Date())
                ]),
                .init(name: "Extra large name for a Lottery 2"),
                .init(name: "Lottery 3"),
                .init(name: "Lottery 4"),
                .init(name: "Lottery 5"),
                .init(name: "Lottery 6"),
                .init(name: "Supper Lottery 1"),
                .init(name: "Extra large name for a Lottery 2"),
                .init(name: "Lottery 3"),
                .init(name: "Lottery 4"),
                .init(name: "Lottery 5"),
                .init(name: "Lottery 6"),
            ])
            //ContentView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
