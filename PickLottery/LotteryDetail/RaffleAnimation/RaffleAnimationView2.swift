import SwiftUI

struct RaffleAnimationView2: View {
    @State var rotation: Double = 0
    @State var angles: [Double] = [-180, -160, -140, -120,-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100, 120, 140, 160, 180]
    
    let names: [String] = ["Ana", "Maurício", "Ricardo", "Edvania", "Tarcísio", "Marcelo", "Pedro"]
    @State var nameIndex: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(angles, id: \.self) {
                    itemView(rotationOffset: $0)
                }
            }
            Spacer()
            Slider(value: $rotation, in:.init(uncheckedBounds: (lower: -360, upper: 360)))
        }
        .onTapGesture {
            withAnimation(.linear(duration: 5)) {
                rotation = -360
            }
        }
    }
    
    func itemView(rotationOffset: Double) -> some View {
        return Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(height: 40)
            .border(.red)
            .background(.white)
        //.rotationEffect(.degrees(rotation), anchor: .init(x: -1, y: -1))
            .rotation3DEffect(
                .degrees(rotationOffset + rotation),
                axis: (x: 1, y: 0, z: 0),
                anchorZ: -110, perspective: 0.3
            )
            .opacity(itemOpacity(rotationOffset: rotationOffset + rotation))
    }
    
    func itemOpacity(rotationOffset: Double) -> Double {
        let angleReference: Int = Int(rotationOffset) % 360
        if angleReference < -90 && angleReference > -270 {
            return 0.5
        }
//        let angleReference: Int = abs(Int(rotationOffset)) % 360
//        if angleReference < 90 {
//            return 1
//        }
//        if angleReference > 270 {
//            return 1
//        }
        return 1
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

struct RaffleAnimationView2_Previews: PreviewProvider {
    static var previews: some View {
        RaffleAnimationView2()
    }
}
