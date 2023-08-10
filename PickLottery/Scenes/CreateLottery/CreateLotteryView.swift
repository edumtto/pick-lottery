import MCEmojiPicker
import SwiftUI

struct CreateLotteryView: View {
    private enum FocusedField {
        case name
    }
    
    @Binding var isPresented: Bool
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @State var emojiPickerIsPresented: Bool = false
    @StateObject var viewModel: CreateLotteryViewModel
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
                    .gesture(selectorTapGesture, including: .all)
                
                entriesInput
            }
            .padding()
        }
        Spacer()
        createButton
            .navigationTitle("New lottery")
            .alert(isPresented: $viewModel.showValidationAlert) {
                Alert(title: Text("Enter with a name for the lottery"))
            }
            .onAppear {
                focusedField = .name
            }
    }
    
    private var selectorTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                UIApplication.shared.connectedScenes
                    .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                    .last?
                    .endEditing(true)
            }
    }
    
    var nameInput: some View {
        TextField("Name", text: $viewModel.name)
            .textFieldStyle(PrimaryTextFieldStyle())
            .focused($focusedField, equals: .name)
    }
    
    var descriptionInput: some View {
        TextField("Description", text: $viewModel.description)
            //.textFieldStyle(PrimaryTextFieldStyle())
            .textFieldStyle(
                PrimaryTextFieldStyle(strokeColor: viewModel.description.isEmpty ? Color.gray : Color.primary)
            )
    }
    
    var modeInput: some View {
        HStack {
            Picker("Raffle mode", selection: $viewModel.raffleMode) {
                ForEach(viewModel.raffleModes) {
                    Text($0.description)
                }
            }
            
        }
        .frame(minWidth: 120, minHeight: 34)
        .padding(.top, 4)
        .padding(.bottom, 4)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
    }
    
    var emojiInput: some View {
        Button {
            emojiPickerIsPresented.toggle()
        } label: {
            Text(viewModel.emoji)
                .font(.title)
        }
        .emojiPicker(
            isPresented: $emojiPickerIsPresented,
            selectedEmoji: $viewModel.emoji
        )
        .frame(minWidth: 34, minHeight: 34)
        .padding(4)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
    }
    
    var colorInput: some View {
        ColorPicker("", selection: $viewModel.color, supportsOpacity: false)
            .frame(width: 34, height: 34)
            .padding(.top, 4)
            .padding(.trailing, 8)
            .padding(.bottom, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 1)
            )
    }
    
    var entriesInput: some View {
        VStack(alignment: .leading) {
            TextField("Entries (comma-separared)", text: $viewModel.entriesDescription, axis: .vertical)
                //.textFieldStyle(PrimaryTextFieldStyle())
                .textFieldStyle(
                    PrimaryTextFieldStyle(strokeColor: viewModel.entriesDescription.isEmpty ? Color.gray : Color.primary)
                )
                .textInputAutocapitalization(.never)
            Text("  Ex: John, Mary, San ...")
                .font(.caption)
        }
        
    }
    
    var createButton: some View {
        Button("Create") {
            viewModel.createLottery()
            isPresented = false
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
