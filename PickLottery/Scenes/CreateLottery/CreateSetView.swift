import EmojiPicker
import SwiftUI

struct CreateSetView: View {
    private enum FocusedField {
        case name
    }
    
    @Binding var isPresented: Bool
    @EnvironmentObject var lotteryStore: LotteryStore
    
    @StateObject var viewModel: CreateLotteryViewModel
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header section with icon and color
                    headerSection
                    
                    // Main form content
                    VStack(spacing: 24) {
                        basicInfoSection
                        entriesSection
                        modeSection
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 80)
                }
                .padding(.top, 20)
            }
            .navigationTitle("New Lottery")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: cancelButton,
                trailing: createButton
            )
            .background(Color(.systemGroupedBackground))
        }
        .alert(isPresented: $viewModel.showValidationAlert) {
            Alert(title: Text("Name Required"),
                  message: Text("Please enter a name for your lottery"))
        }
    }
    
    // MARK: - Header Section
    var headerSection: some View {
        VStack(spacing: 16) {
            // Icon display
            Button(action: { /* Navigate to emoji picker */ }) {
                ZStack {
                    Circle()
                        .fill(viewModel.color.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    if let emoji = viewModel.emoji {
                        Text(emoji.value)
                            .font(.system(size: 40))
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(viewModel.color)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Color picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Color.lotteryPallete, id: \.self) { color in
                        Button(action: { viewModel.color = color }) {
                            Circle()
                                .fill(color)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .opacity(viewModel.color == color ? 1 : 0)
                                )
                                .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Basic Info Section
    var basicInfoSection: some View {
        VStack(spacing: 16) {
            // Name input with modern styling
            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextField("Enter lottery name", text: $viewModel.name)
                    .focused($focusedField, equals: .name)
                    .textFieldStyle(ModernTextFieldStyle())
            }
            
            // Description input
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextField("Add a description (optional)", text: $viewModel.description)
                    .textFieldStyle(ModernTextFieldStyle())
            }
        }
    }
    
    // MARK: - Entries Section
    var entriesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Entries")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            TextField("John, Mary, Sam...", text: $viewModel.entriesDescription, axis: .vertical)
                .textInputAutocapitalization(.never)
                .textFieldStyle(ModernTextFieldStyle(minHeight: 80))
        }
    }
    
    // MARK: - Mode Section
    var modeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mode")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(viewModel.raffleModes) { mode in
                    ModeSelectionRow(
                        isSelected: viewModel.raffleMode == mode,
                        action: { viewModel.raffleMode = mode }
                    )
                }
            }
        }
    }
    
    // MARK: - Navigation Buttons
    var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
        .foregroundColor(.secondary)
    }
    
    var createButton: some View {
        Button("Create") {
            viewModel.createLottery()
            if !viewModel.showValidationAlert {
                isPresented = false
            }
        }
        .font(.headline)
        .foregroundColor(viewModel.name.isEmpty ? .secondary : viewModel.color)
        .disabled(viewModel.name.isEmpty)
    }
}

// MARK: - Supporting Views

struct ModernTextFieldStyle: TextFieldStyle {
    let minHeight: CGFloat
    
    init(minHeight: CGFloat = 44) {
        self.minHeight = minHeight
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: minHeight)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
    }
}

struct ModeSelectionRow: View {
    let mode: Lottery.RaffleMode = .fullRandom // Assuming this is your mode type
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.description)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
//                    
//                    if let description = mode.detailedDescription {
//                        Text(description)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .font(.title3)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        CreateLotteryView(isPresented: .constant(true), viewModel: .init(lotteryStore: LotteryStore.preview))
    }
}
