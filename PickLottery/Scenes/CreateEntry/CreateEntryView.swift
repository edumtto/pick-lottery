import SwiftUI

struct CreateEntryView: View {
    enum FocusedField {
        case name, weight
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: FocusedField?
    @StateObject var viewModel: CreateEntryViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .center) {
                    TextField("Entry name", text: $viewModel.name)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    colorInput
                }
                weightInput
            }
            .padding()
        }
        Spacer()
        Button("Create"){
            viewModel.createEntry()
            dismiss()
        }
        .buttonStyle(PrimaryButtonStyle())
        .navigationTitle("New entry")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(isPresented: $viewModel.showValidationAlert) {
            Alert(title: Text("Enter with a name for the lottery"))
        }
        .onAppear {
            focusedField = .name
        }
    }
    
    var nameInput: some View {
        VStack {
            TextField("Entry name", text: $viewModel.name)
                .frame(height: 38)
                .focused($focusedField, equals: .name)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
    }
    
    var weightInput: some View {
        VStack {
            HStack {
                Image(systemName: "scalemass.fill")
                    .foregroundColor(.gray)
                Text(String(format: "%.1f", viewModel.weight))
                Slider(
                    value: $viewModel.weight,
                    in: 0...10
                )
            }
            Text("* Define the chance of wining. 1.0 is the default.")
                .font(.caption)
        }
        .padding(.top)
    }
    
    var colorInput: some View {
        ColorPicker("", selection: $viewModel.color, supportsOpacity: false)
            .frame(width: 38)
    }
}

struct CreateEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateEntryView(viewModel: .init(lotteryStore: LotteryStore.preview, lottery: .example0))
        }
    }
}
