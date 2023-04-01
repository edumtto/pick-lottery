import SwiftUI

struct CreateEntryView: View {
    enum FocusedField {
        case name, weight
    }
    @FocusState private var focusedField: FocusedField?
    
    @Environment(\.dismiss) var dismiss
    //@EnvironmentObject var lotteryStore: LotteryStore
    
    @StateObject var viewModel: CreateEntryViewModel
    //@FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ScrollView {
            VStack {
                nameInput
                weightInput
            }
            .padding()
        }
        Spacer()
        createButton
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
                .focused($focusedField, equals: .name)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .stroke(Color.accentColor)
                )
        }
        .padding(.bottom)
    }
    
    var weightInput: some View {
        VStack {
            Slider(
                value: $viewModel.weight,
                in: 0...10
            )
            Text("Weight: \(viewModel.weight.description)")
        }
    }
    
    var createButton: some View {
        Button {
            viewModel.createEntry()
            dismiss()
        } label: {
            Text("Create")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }
    
    
}

struct CreateEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateEntryView(viewModel: .init(lotteryStore: LotteryStore.preview, lottery: .example))
        }
    }
}
