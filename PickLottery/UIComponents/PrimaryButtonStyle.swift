import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    private let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.whiteDynamic)
            .font(.headline)
            .frame(minWidth: 160, minHeight: 40)
            .background(backgroundColor)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .cornerRadius(16)
            
    }
    
    init(backgroundColor: Color = Color.accentColor) {
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
