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
        ZStack {
            formView
                .safeAreaPadding(.bottom, 100)
                .background(Color(UIColor.secondarySystemBackground))
                .tint(.accentColor)
                .scrollContentBackground(.hidden)
            
            VStack {
                Spacer()
                
                createButton
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .padding(.trailing, 16)
            }
            .padding(.bottom, 24)
        }
        
        .navigationTitle("New Lottery")
        .alert(isPresented: $viewModel.showValidationAlert) {
            Alert(title: Text("Enter with a name for the lottery"))
        }
    }
    
    var formView: some View {
        Form {
            Section("") {
                nameInput
                descriptionInput
            }
            
            Section("") {
                modeInput
            }
            
            Section("") {
                emojiInput
            }
            
            Section("Entries") {
                entriesInput
            }
        }
        .listSectionSpacing(8)
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
            ZStack(alignment: .topLeading) {
                if viewModel.entriesDescription.isEmpty {
                    Text("Type one entry per line")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                }
                TextEditor(text: $viewModel.entriesDescription)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .frame(minHeight: 120)
            }
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
