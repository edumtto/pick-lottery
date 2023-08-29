import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    private let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.whiteDynamic)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(backgroundColor)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .cornerRadius(16)
            .padding()
    }
    
    init(backgroundColor: Color = Color.primary) {
        self.backgroundColor = backgroundColor
    }
}

struct PrimaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Create") {
            debugPrint("created")
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}
