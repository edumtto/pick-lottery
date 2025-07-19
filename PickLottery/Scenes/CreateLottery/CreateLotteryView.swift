import EmojiPicker
import SwiftUI

struct CreateLotteryView: View {
    private enum FocusedField {
        case name
    }
    
    @Binding var isPresented: Bool
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @StateObject var viewModel: CreateLotteryViewModel
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        Form {
            Section() {
                nameInput
                descriptionInput
                modeInput
            }
            
            Section("Entries") {
                entriesInput
            }
            
            Section("Appearance") {
                emojiInput
                colorInput
            }
            
        }
        .tint(.accentColor)
        .scrollContentBackground(.hidden)
        Spacer()
        createButton
            .navigationTitle("New Set")
            .alert(isPresented: $viewModel.showValidationAlert) {
                Alert(title: Text("Enter with a name for the lottery"))
            }
    }
    
    
    var nameInput: some View {
        TextField("Name", text: $viewModel.name)
            .focused($focusedField, equals: .name)
    }
    
    var descriptionInput: some View {
        TextField("Description (optional)", text: $viewModel.description)
    }
    
    var modeInput: some View {
        Picker("Raffle Mode", selection: $viewModel.raffleMode) {
            ForEach(viewModel.raffleModes) {
                Text($0.description)
            }
        }
    }
    
    var emojiInput: some View {
        LabeledContent("Icon") {
            NavigationLink {
                EmojiPickerView(selectedEmoji: $viewModel.emoji, selectedColor: .accentColor)
                    .navigationTitle("Illustrations")
                
            } label: {
                HStack {
                    Spacer()
                    Text(viewModel.emoji?.value ?? "")
                        .font(.title)
                }
            }
        }
    }
    
    var colorInput: some View {
        LabeledContent("Color") {
            NavigationLink {
                ColorPickerView(colors: Color.lotteryPallete, selectedColor: $viewModel.color)
            } label: {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 32, height: 32)
                        .foregroundColor(viewModel.color)
                }
            }
        }
    }
    
    var entriesInput: some View {
        VStack(alignment: .leading) {
            TextField("John, Mary, San ...", text: $viewModel.entriesDescription, axis: .vertical)
                .textInputAutocapitalization(.never)
        }
        
    }
    
    var createButton: some View {
        Button("Create") {
            viewModel.createLottery()
            if !viewModel.showValidationAlert {
                isPresented = false
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct CreateLotteryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateLotteryView(isPresented: .constant(true), viewModel: .init(lotteryStore: LotteryStore.preview))
        }
    }
}
