import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.whiteDynamic)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(Color.primary)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .cornerRadius(8)
            .padding()
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
