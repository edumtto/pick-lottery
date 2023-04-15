import SwiftUI

struct CreateLotteryView: View {
    private enum FocusedField {
        case name
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var color: Color = .lotteryRandom
    @State private var emoji: String = Lottery.Illustration.random.rawValue
    @State private var raffleMode: Lottery.RaffleMode = .fullRandom
    @State private var entriesDescription: String = ""
    @State private var showValidationAlert = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ScrollView {
            VStack {
                nameInput
                descriptionInput
                    .padding(.bottom)
                HStack {
                    modeInput
                    emojiInput
                    colorInput
                }
                    .padding(.bottom)
                entriesInput
            }
            .padding()
        }
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
            .onAppear {
                focusedField = .name
            }
    }
    
    var nameInput: some View {
        TextField("Name", text: $name)
            .textFieldStyle(PrimaryTextFieldStyle())
            .focused($focusedField, equals: .name)
    }
    
    var descriptionInput: some View {
        TextField("Description (opcional)", text: $description)
            .textFieldStyle(
                PrimaryTextFieldStyle(strokeColor: description.isEmpty ? Color.gray : Color.accentColor)
            )
    }
    
    var modeInput: some View {
        Picker("Raffle mode", selection: $raffleMode) {
            ForEach(Lottery.RaffleMode.options) {
                Text($0.description)
            }
        }
        .frame(minWidth: 100)
    }
    
    var emojiInput: some View {
        Picker(emoji, selection: $emoji) {
            ForEach(Lottery.Illustration.allCases) {
                Text($0.rawValue)
            }
        }
    }
    
    var colorInput: some View {
        ColorPicker("", selection: $color, supportsOpacity: false)
            .frame(width: 38)
    }
    
    var entriesInput: some View {
        VStack(alignment: .leading) {
            TextField("Entries (opcional)", text: $entriesDescription, axis: .vertical)
                .textFieldStyle(
                    PrimaryTextFieldStyle(strokeColor: entriesDescription.isEmpty ? Color.gray : Color.accentColor)
                )
                .textInputAutocapitalization(.never)
            Text("  Ex: John, Mary, San ...")
                .font(.caption)
        }
        
    }
    
    var createButton: some View {
        Button("Create"){
            createLottery()
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    
    private func createLottery() {
        if name.isEmpty {
            showValidationAlert = true
            focusedField = .name
            return
        }
        
        let entries: [Lottery.Entry] = entriesDescription
            .components(separatedBy: ",")
            .compactMap {
                let entryName = $0.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                return entryName.isEmpty ? nil : Lottery.Entry(entryName)
            }
        
        let newLottery = Lottery(
            name: name,
            description: description,
            illustration: .init(rawValue: emoji),
            entries: entries,
            color: color,
            raffleMode: raffleMode
        )
        lotteryStore.addLottery(newLottery)
        
        dismiss()
    }
}

struct CreateLotteryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateLotteryView()
        }
    }
}
