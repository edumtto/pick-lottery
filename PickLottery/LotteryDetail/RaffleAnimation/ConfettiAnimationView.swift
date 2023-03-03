import SwiftUI

struct ConfettiAnimationView: View {
    var body: some View {
        ConfettiView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}

struct ConfettiAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiAnimationView()
    }
}

struct ConfettiView: View {
    @State private var confetti: [Confetti] = []
    
    var body: some View {
        ZStack {
            ForEach(confetti) { confetti in
                VStack {
                    Rectangle()
                        .fill(confetti.color)
                        .frame(width: confetti.size, height: 2 * confetti.size)
                        //.rotationEffect(.degrees(confetti.rotationAngle))
                        .rotationEffect(.degrees(confetti.rotationBase))
                        .rotation3DEffect(.degrees(confetti.rotationAnimation), axis: confetti.axis, perspective: 0.5)
                        .onAppear {
                            animate()
                        }
                }
                .position(confetti.position)
                
            }
        }
        .onAppear {
            // Add confetti every 0.1 seconds
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                confetti.append(Confetti())
            }
        }
    }
    
    func animate() {
        withAnimation(.linear(duration: 1)) {
            for i in 0..<confetti.count {
                let c = confetti[i]
                confetti[i].position = CGPoint(x: c.position.x, y: c.position.y + c.duration)
                confetti[i].rotationAnimation += 30
            
            }
        }
    }
}

struct Confetti: Identifiable {
    let id: UUID = UUID()
    
    let color: Color
    let size: CGFloat
    
    var position: CGPoint
    var rotationBase: Double
    var rotationAnimation: Double = 0
    let duration: TimeInterval
    
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    
    init() {
        self.color = Color(hue: Double.random(in: 0...1), saturation: Double.random(in: 0.5...1), brightness: Double.random(in: 0.5...1))
        
        self.position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: -20)
        self.duration = TimeInterval.random(in: 20...50) / 3
        self.size = duration
        self.rotationBase = Double.random(in: 5...40) / 3
        
        switch Int.random(in: 0...2) {
        case 0:
            self.axis = (x: 1, y: 0, z: 0.5)
        case 1:
            self.axis = (x: 0.3, y: 1, z: 0.5)
        default:
            self.axis = (x: 0, y: 0.5, z: 1)
        }
    }
}

