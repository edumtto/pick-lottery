import SwiftUI

struct RaffleAnimationView2: View {
    @Binding var isRaffleAnimationFinished: Bool
    
    var body: some View {
        box
    }
    
    var box: some View {
        ZStack {
            Rectangle()
                .position(x: 50, y: 200)
                .frame(width: 200, height: 150)
                .rotation3DEffect(.degrees(4), axis: (x: 0, y: -1, z: 0))
                .foregroundColor(.brown)
            Rectangle()
                .position(x: 154, y: 214)
                .frame(width: 100, height: 160)
                .rotation3DEffect(.degrees(16), axis: (x: 0, y: 1, z: 0))
        }
    }
    
//    var box: some View {
//        Path { path in
//            var width: CGFloat = 200.0
//            let height = 150.0
//            path.move(
//                to: CGPoint(
//                    x: width,
//                    y: height * (0.20)
//                )
//            )
//            path.addLine(
//                to: CGPoint(
//                    x: width,
//                    y: height
//                )
//            )
//            path.addLine(
//                to: CGPoint(
//                    x: 0,
//                    y: height * (0.80)
//                )
//            )
//            path.addLine(
//                to: CGPoint(
//                    x: 0,
//                    y: 0
//                )
//            )
//        }
//        .fill(.brown)
//        .background(.gray)
//    }
}

struct RaffleAnimationView2_Previews: PreviewProvider {
    static var previews: some View {
        RaffleAnimationView2(isRaffleAnimationFinished: .constant(false))
    }
}
