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
            .alert(isPresented: $viewModel.showValidationAlert) {
                Alert(title: Text("Enter with a name for the lottery"))
            }
            .onAppear {
                focusedField = .name
            }
    }
    
    var nameInput: some View {
        TextField("Name", text: $viewModel.name)
            .textFieldStyle(PrimaryTextFieldStyle())
            .focused($focusedField, equals: .name)
    }
    
    var descriptionInput: some View {
        TextField("Description (opcional)", text: $viewModel.description)
            .textFieldStyle(
                PrimaryTextFieldStyle(strokeColor: viewModel.description.isEmpty ? Color.gray : Color.primary)
            )
    }
    
    var modeInput: some View {
        Picker("Raffle mode", selection: $viewModel.raffleMode) {
            ForEach(viewModel.raffleModes) {
                Text($0.description)
            }
        }
        .frame(minWidth: 100)
    }
    
    var emojiInput: some View {
        Picker(viewModel.emoji, selection: $viewModel.emoji) {
            ForEach(viewModel.illustrations) {
                Text($0.rawValue)
            }
        }
    }
    
    var colorInput: some View {
        ColorPicker("", selection: $viewModel.color, supportsOpacity: false)
            .frame(width: 38)
    }
    
    var entriesInput: some View {
        VStack(alignment: .leading) {
            TextField("Entries (opcional)", text: $viewModel.entriesDescription, axis: .vertical)
                .textFieldStyle(
                    PrimaryTextFieldStyle(strokeColor: viewModel.entriesDescription.isEmpty ? Color.gray : Color.primary)
                )
                .textInputAutocapitalization(.never)
            Text("  Ex: John, Mary, San ...")
                .font(.caption)
        }
        
    }
    
    var createButton: some View {
        Button("Create"){
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
