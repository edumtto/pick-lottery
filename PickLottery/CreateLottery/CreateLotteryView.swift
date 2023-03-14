import SwiftUI

struct CreateLotteryView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var lotteries: [Lottery]
    @State var name: String = ""
    @State var raffleMode: Lottery.RaffleMode = .fullRandom
    @State var entriesDescription: String = ""
    @State var showValidationAlert = false
    
    @EnvironmentObject var lotteryStore: LotteryStore
    
    var body: some View {
        nameInput
        modeInput
        entriesInput
        Spacer()
        createButton
        .navigationTitle("New lottery")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Enter with a name for the lottery"))
        }
    }
    
    var nameInput: some View {
        VStack {
            HStack {
                Text("Name:")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.bottom, -4)
            TextField("New lottery", text: $name)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .stroke(Color.accentColor)
                )
        }
        .padding()
    }
    
    var modeInput: some View {
        VStack {
            HStack {
                Text("Rule:")
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                Picker("Raffle mode", selection: $raffleMode) {
                    ForEach(Lottery.RaffleMode.options) {
                        Text($0.description)
                    }
                }
                Spacer()
            }
            .padding(.top, -12)
            .padding(.leading, -12)
        }
        .padding()
    }
    
    var entriesInput: some View {
        VStack {
            HStack {
                Text("Entries (opcional):")
                    .font(.subheadline)
                Spacer()
            }
            .padding(.bottom, -4)
            
            TextField("John, Ana, ...", text: $entriesDescription, axis: .vertical)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .stroke(entriesDescription == "" ? Color.gray : Color.accentColor)
                )
        }
        .padding()
    }
    
    var createButton: some View {
        Button {
            createLottery()
        } label: {
            Text("Create")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }
    
    private func createLottery() {
        if name.isEmpty {
            showValidationAlert = true
            return
        }
        
        let entries: [LotteryEntry] = entriesDescription
            .components(separatedBy: ",")
            .compactMap {
                let entryName = $0.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                return entryName.isEmpty ? nil : LotteryEntry(entryName)
            }
        
        let newLottery = Lottery(name: name, entries: entries, raffleMode: raffleMode)
        
        lotteryStore.addLottery(newLottery)
        lotteries = lotteryStore.fetchLotteries()
        
        dismiss()
    }
}

struct CreateLotteryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateLotteryView(lotteries: .constant([]))
        }
    }
}
