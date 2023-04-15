import SwiftUI

struct CreateLotteryView: View {
    enum FocusedField {
        case name, entries
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @State var name: String = ""
    @State var color: Color = .lotteryRandom
    @State var raffleMode: Lottery.RaffleMode = .fullRandom
    @State var entriesDescription: String = ""
    @State var showValidationAlert = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ScrollView {
            VStack {
                nameInput
                    .padding(.bottom)
                HStack {
                    modeInput
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

//    TODO:
//    var emojiInput: some View {
//
//    }
    
    var modeInput: some View {
        Picker("Raffle mode", selection: $raffleMode) {
            ForEach(Lottery.RaffleMode.options) {
                Text($0.description)
            }
        }
    }
    
    var colorInput: some View {
        ColorPicker("", selection: $color, supportsOpacity: false)
            .frame(width: 38)
    }
    
    var entriesInput: some View {
        TextField("Entries (ex: John, Ana, San ...)", text: $entriesDescription, axis: .vertical)
            .focused($focusedField, equals: .entries)
            .textFieldStyle(
                PrimaryTextFieldStyle(strokeColor: entriesDescription.isEmpty ? Color.gray : Color.accentColor)
            )
            
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
        
        let newLottery = Lottery(name: name, entries: entries, color: color, raffleMode: raffleMode)
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
