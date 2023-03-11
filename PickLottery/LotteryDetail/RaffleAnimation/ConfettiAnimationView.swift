import SwiftUI

struct ConfettiAnimationView: View {
    @State private var confetti: [Confetti] = .init(repeating: Confetti(), count: 10)
    @State private var timer: Timer?
    @State var counter: Int = 0
    let maxConfetti: Int = 50
    
    var body: some View {
        ZStack {
            ForEach(confetti) { confetti in
                VStack {
                    Rectangle()
                        .fill(confetti.color)
                        .frame(width: confetti.size, height: 2 * confetti.size)
                        .rotationEffect(.degrees(confetti.rotationInitial2D))
                        .rotation3DEffect(
                            .degrees(confetti.rotationIncremental3D),
                            axis: confetti.rotationAxis, perspective: 0.5
                        )
                }
                .position(confetti.position)
            }
        }
        .onChange(of: counter) { _ in
            animate(.linear(duration: 1))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                timer?.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                counter += 1
                if counter < maxConfetti {
                    confetti.append(Confetti())
                }
            }
        }
    }
    
    func animate(_ animation: Animation) {
        withAnimation(animation) {
            for i in 0..<confetti.count {
                let c = confetti[i]
                confetti[i].position = CGPoint(
                    x: c.position.x + c.incrementalDistance.x,
                    y: c.position.y + c.incrementalDistance.y
                )
                confetti[i].rotationIncremental3D += 30
            }
        }
    }
}

struct ConfettiAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiAnimationView()
    }
}

fileprivate struct Confetti: Identifiable {
    let id: UUID = UUID()
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var rotationInitial2D: Double
    var rotationIncremental3D: Double = 0
    let incrementalDistance: (x: Double, y: Double)
    let rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat)
    
    init() {
        color = Color(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.5...1),
            brightness: Double.random(in: 0.5...1)
        )
        
        position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: -20
        )
        incrementalDistance = (x: Double.random(in: -6...6), y: Double.random(in: 15...45))
        size = incrementalDistance.y / 3
        rotationInitial2D = Double.random(in: 5...40) / 3
        
        switch Int.random(in: 0...2) {
        case 0:
            rotationAxis = (x: 1, y: 0, z: 0.5)
        case 1:
            rotationAxis = (x: 0.3, y: 1, z: 0.5)
        default:
            rotationAxis = (x: 0, y: 0.5, z: 1)
        }
    }
}
