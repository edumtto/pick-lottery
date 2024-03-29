import Foundation
import SwiftUI

extension Color {
    static let whiteDynamic = Color("WhiteDynamic")
    static let blackDynamic = Color("BlackDynamic")
    
    static var lotteryPallete: [Color] {
        [Int](0...24)
            .map { Double($0) / 24.0 }
            .map {
                Color(
                    hue: $0,
                    saturation: 0.6,
                    brightness: 0.7
                )
            }
    }
    
    static var lotteryRandom: Color {
        Color.lotteryPallete[Int.random(in: 0..<20)]
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
    var cgColor: CGColor {
        UIColor(self).cgColor
    }
    
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
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
    static func itemView(_ color: Color) -> some View {
        HStack {
            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(Color.entryRandom)
            Text(color.toHex() ?? "")
                .padding(2)
                .background(color)
        }
    }
    
    static let randomColor = Color.lotteryRandom
    
    static var previews: some View {
        Group {
            LazyVStack {
                ForEach(Color.lotteryPallete, id: \.hashValue) { color in
                    itemView(color)
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
