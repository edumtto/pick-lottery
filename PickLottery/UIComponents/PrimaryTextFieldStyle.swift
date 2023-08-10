import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    private let strokeColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(minHeight: 32)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
    
    init(strokeColor: Color = .primary) {
        self.strokeColor = strokeColor
    }
}

struct PLTextField_Previews: PreviewProvider {
    static var previews: some View {
        TextField("Test", text: .constant(""))
            .textFieldStyle(PrimaryTextFieldStyle())
            .padding()
    }
}
