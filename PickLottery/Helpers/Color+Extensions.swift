import Foundation
import SwiftUI

extension Color {
    static var confettiRandom: Color {
        .init(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.2...0.5),
            brightness: Double.random(in: 0.5...1)
        )
    }
    
    static var lotteryRandom: Color {
        .init(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.2...0.3),
            brightness: Double.random(in: 0.8...1)
        )
    }
    
    static var entryRandom: Color {
        .init(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.4...0.8),
            brightness: Double.random(in: 0.5...0.9)
        )
    }
}

//
// Source: https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swift
//
extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}


struct RandomColor_Previews: PreviewProvider {
    static func itemView() -> some View {
        HStack {
            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(Color.entryRandom)
            Text("Text goes here")
                .padding()
                .background(Color.lotteryRandom)
        }
    }
    
    static let randomColor = Color.lotteryRandom
    
    static var previews: some View {
        Group {
            VStack {
                ForEach(0..<11) { _ in
                    itemView()
                }
            }
            .previewDisplayName("Random colors")
            
            VStack {
                Text("Original color")
                    .padding()
                    .background(randomColor)
                
                Text("Recovered color")
                    .padding()
                    .background(Color(hex: randomColor.toHex()!))
            }
            .previewDisplayName("Converting colors")
        }
    }
}
