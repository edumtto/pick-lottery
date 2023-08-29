import SwiftUI

struct ColorPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    private let columnGrid = [
        GridItem(.adaptive(minimum: 48, maximum: 48))
    ]
    
    let colors: [Color]
    @Binding var selectedColor: Color
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnGrid, spacing: 8) {
                ForEach(colors, id: \.hashValue) { color in
                    Button {
                        selectedColor = color
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 48, height: 48)
                            .foregroundColor(color)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Colors")
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(colors: Color.lotteryPallete, selectedColor: .constant(.pink))
    }
}
