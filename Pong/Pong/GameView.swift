import SwiftUI
import Foundation

struct GameView: View {
    private let paddleWidth: CGFloat = 90
    private let paddleHeight: CGFloat = 16
    private let ballRadius: CGFloat = 10
    private let paddleMoveStep: CGFloat = 26
    private let maxBallSpeed: CGFloat = 640

    @State private var boardSize: CGSize = .zero
    @State private var paddleX: CGFloat = 0
    @State private var ballPos: CGPoint = .zero
    @State private var ballVelocity: CGVector = CGVector(dx: 220, dy: -260)
    @State private var score: Int = 0
    @AppStorage("pong.bestScore") private var bestScore: Int = 0
    @State private var isRunning: Bool = false
    @State private var isGameOver: Bool = false

    @FocusState private var isFocused: Bool

    private let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.ignoresSafeArea()

                Canvas { context, size in
                    let wallPath = Path(CGRect(x: 0, y: 0, width: size.width, height: 6))
                    context.fill(wallPath, with: .color(.gray))

                    let ballRect = CGRect(
                        x: ballPos.x - ballRadius,
                        y: ballPos.y - ballRadius,
                        width: ballRadius * 2,
                        height: ballRadius * 2
                    )
                    context.fill(Path(ellipseIn: ballRect), with: .color(.white))

                    let paddleRect = CGRect(
                        x: paddleX - paddleWidth / 2,
                        y: size.height - paddleHeight - 24,
                        width: paddleWidth,
                        height: paddleHeight
                    )
                    context.fill(Path(roundedRect: paddleRect, cornerRadius: 4), with: .color(.green))
                }

                VStack {
                    HStack {
                        Text("Score: \(score)")
                        Spacer()
                        Text("Meilleur: \(bestScore)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }

                if !isRunning {
                    VStack(spacing: 16) {
                        Text(isGameOver ? "Perdu !" : "Pong contre un mur")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        if isGameOver {
                            Text("Score : \(score)")
                                .foregroundColor(.white)
                        }
                        Text("Flèches ← → pour bouger la raquette")
                            .foregroundColor(.gray)
                        Button(isGameOver ? "Rejouer" : "Jouer") {
                            startGame(in: proxy.size)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .onAppear {
                boardSize = proxy.size
                resetPositions(in: proxy.size)
                isFocused = true
            }
            .focusable()
            .focused($isFocused)
            .onKeyPress(.leftArrow) {
                movePaddle(by: -paddleMoveStep, in: proxy.size)
                return .handled
            }
            .onKeyPress(.rightArrow) {
                movePaddle(by: paddleMoveStep, in: proxy.size)
                return .handled
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            step(in: boardSize)
        }
    }

    private func resetPositions(in size: CGSize) {
        boardSize = size
        paddleX = size.width / 2
        ballPos = CGPoint(x: size.width / 2, y: size.height / 2)
        ballVelocity = CGVector(dx: 220, dy: -260)
        score = 0
    }

    private func startGame(in size: CGSize) {
        resetPositions(in: size)
        isGameOver = false
        isRunning = true
        isFocused = true
    }

    private func movePaddle(by delta: CGFloat, in size: CGSize) {
        guard size.width > 0 else { return }
        let halfWidth = paddleWidth / 2
        paddleX = min(max(paddleX + delta, halfWidth), size.width - halfWidth)
    }

    private func step(in size: CGSize) {
        guard size.width > 0, size.height > 0 else { return }

        var newX = ballPos.x + ballVelocity.dx / 60.0
        var newY = ballPos.y + ballVelocity.dy / 60.0
        var newVelocity = ballVelocity

        if newX - ballRadius <= 0 {
            newX = ballRadius
            newVelocity.dx = abs(newVelocity.dx)
        } else if newX + ballRadius >= size.width {
            newX = size.width - ballRadius
            newVelocity.dx = -abs(newVelocity.dx)
        }

        if newY - ballRadius <= 6 {
            newY = ballRadius + 6
            newVelocity.dy = abs(newVelocity.dy)
        }

        let paddleTop = size.height - paddleHeight - 24
        let halfPaddle = paddleWidth / 2
        if newVelocity.dy > 0,
           newY + ballRadius >= paddleTop,
           newY + ballRadius <= paddleTop + paddleHeight + 12,
           newX >= paddleX - halfPaddle,
           newX <= paddleX + halfPaddle {
            newY = paddleTop - ballRadius
            let offset = (newX - paddleX) / halfPaddle
            let speed = min(maxBallSpeed, hypot(newVelocity.dx, newVelocity.dy) * 1.05)
            let angle = offset * (.pi / 3)
            newVelocity = CGVector(dx: speed * sin(angle), dy: -abs(speed * cos(angle)))
            score += 1
            bestScore = max(bestScore, score)
        }

        if newY - ballRadius > size.height {
            isRunning = false
            isGameOver = true
            return
        }

        ballPos = CGPoint(x: newX, y: newY)
        ballVelocity = newVelocity
    }
}

#Preview {
    GameView()
}
