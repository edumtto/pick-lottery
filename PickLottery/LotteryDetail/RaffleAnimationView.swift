import SwiftUI
import Foundation

struct RaffleAnimationView: View {
    struct RotatingItem: Identifiable {
        let id: UUID = UUID()
        let name: String
        var offset: CGFloat
        var rotationDegrees: Double
        var scale: Double
        //var opacity: CGFloat
    }
    
//    let opacity = []
    let rotation: [Double] =  [72, 48, 24, 0, -24, -48, -72]
    let scale: [Double] =  [0.6, 0.7, 1, 1.2, 1, 0.7, 0.6]
    let offset: [CGFloat] =  [-12, 4, -8, 0, 8, -4, -12]
    
    let names: [String] = ["Ana", "Maurício", "Ricardo", "Edvania", "Tarcísio", "Marcelo", "Pedro"]
    @State var nameIndex: Int = 0
    
    @State var items: [RotatingItem] =
//        var list: [RotatingItem] = []
//        for i in 0..<names.count {
//            list.append(RotatingItem(name: names[i], offset: offset[i], rotationDegrees: rotation[i], scale: scale[i]))
//        }
//        return list
//    }()
//
    [
        .init(name: "Lana", offset: 12, rotationDegrees: 72, scale: 0.6),
        .init(name: "Ana", offset: 4, rotationDegrees: 48, scale: 0.7),
        .init(name: "João", offset: -8, rotationDegrees: 24, scale: 1),
        .init(name: "Maria", offset: 0, rotationDegrees: 0, scale: 1.2),
        .init(name: "Cristina", offset: 8, rotationDegrees: -24, scale: 1),
        .init(name: "Júlia", offset: -4, rotationDegrees: -48, scale: 0.7),
        .init(name: "Júlia", offset: -12, rotationDegrees: -72, scale: 0.6)
    ]
    
    let limitOffset: Double = 100
    let frameHeight: CGFloat = 52
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.right")
                .scaleEffect(2)
                .padding()
            VStack {
                ForEach(items) {
                    Text($0.name)
                        .padding()
                        .frame(maxHeight: frameHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .stroke(Color.accentColor)
                        )
                        //.offset(.init(width: 0, height: $0.offset))
                        .rotation3DEffect(
                            .degrees($0.rotationDegrees),
                            axis: (x: 1, y: 0, z: 0),
                            anchorZ: -30,
                            perspective: 0.3
                        )
//                        .scaleEffect(x: $0.scale, y: $0.scale)
                    
                }

            }
            .onTapGesture {
                animate(times: 3, duration: 0.5)
            }
        }
    }
    
    @State private var timer: Timer?
    
    func animate(times: Int, duration: Double) {
//        let animation = Animation.linear(duration: 0.1)
//        withAnimation(animation) {
////                items[i].offset = frameHeight
//
//
//            items.insert(.init(name: nextName(), offset: 0, rotationDegrees: 20, scale: 0.8), at: 0)
//            _ = items.popLast()
//
//
//            for i in 0..<items.count {
//                items[i].rotationDegrees = rotation[i]
//                items[i].scale = scale[i]
//                items[i].offset = offset[i]
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            withAnimation(.linear(duration: duration)) {
                    items.insert(.init(name: nextName(), offset: 0, rotationDegrees: 90, scale: 0.6), at: 0)
                    _ = items.popLast()
                    
//                    for i in 0..<items.count {
//                        items[i].rotationDegrees = rotation[i]
//                        items[i].scale = scale[i]
//                        items[i].offset = offset[i]
//                    }
                }
            }
    }
    
    
    func nextName() -> String {
        let name = names[nameIndex]
        nameIndex += 1
        if nameIndex >= names.count {
            nameIndex = 0
        }
        return name
    }
}

struct RaffleAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        RaffleAnimationView()
    }
}
