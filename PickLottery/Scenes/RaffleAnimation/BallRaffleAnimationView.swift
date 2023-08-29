import SwiftUI

struct BallAnimationView: View, RaffleAnimationView {
    @Binding var presentRaffleAnimation: Bool
    @Binding var isRaffleAnimationFinished: Bool
    let targetEntry: LotteryEntryMO
    
    @State var isZoomed = false
    
//    private var ballText: (column: String, number: String) {
//        let splitedString = targetEntry.name.split(separator: " ")
//        if splitedString.count == 2 {
//            return (column: String(splitedString[0]), number: String(splitedString[1]))
//        }
//        return (column: "", number: targetEntry.name)
//    }
    
    var body: some View {
        ZStack {
            targetEntry.color
            
            GeometryReader { proxy in
                VStack {
                    Text(targetEntry.name)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                }
                .padding(18)
                .background {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.white, .gray],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(radius: 8, y: 8)
                }
                .position(
                    x: proxy.size.width / 2,
                    y: isZoomed ? proxy.size.height / 2 : proxy.size.height
                )
                .scaleEffect(isZoomed ? 1 : 0)
                .animation(.easeOut, value: isZoomed)
            }
                
        }
        .onAppear {
            isZoomed = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                presentRaffleAnimation = false
//            }
        }
//        .onTapGesture {
//            presentRaffleAnimation = false
//        }
        .ignoresSafeArea()
    }
}

struct BallAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BallAnimationView(presentRaffleAnimation: .constant(true), isRaffleAnimationFinished: .constant(true), targetEntry: .example)
    }
}
