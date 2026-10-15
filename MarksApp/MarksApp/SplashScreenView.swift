import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var haloPulse = false

    var body: some View {
        ZStack {
            // Deep obsidian & midnight sapphire ambient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.07, blue: 0.14),
                    Color(red: 0.09, green: 0.11, blue: 0.22),
                    Color(red: 0.04, green: 0.05, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Glowing ambient radial halo
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.42, green: 0.36, blue: 0.98).opacity(haloPulse ? 0.45 : 0.25),
                    Color(red: 0.12, green: 0.65, blue: 0.95).opacity(haloPulse ? 0.25 : 0.10),
                    Color.clear
                ]),
                center: .center,
                startRadius: 20,
                endRadius: 260
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Animated App Icon with holographic glow
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGradient.opacity(0.35))
                        .frame(width: 160, height: 160)
                        .blur(radius: 24)

                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: AppTheme.brandIndigo.opacity(0.6), radius: 24, x: 0, y: 12)
                        .scaleEffect(isAnimating ? 1.04 : 0.96)
                }

                // Brand Typography
                VStack(spacing: 10) {
                    Text("Gradify")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(white: 0.88)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Text("Academic Performance Intelligence")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white.opacity(0.72))
                        .tracking(0.5)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 16)

                Spacer()

                // Smooth glowing progress bar
                VStack(spacing: 12) {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 120, height: 4)

                        Capsule()
                            .fill(AppTheme.primaryGradient)
                            .frame(width: isAnimating ? 120 : 20, height: 4)
                            .animation(.easeInOut(duration: 1.8), value: isAnimating)
                    }

                    Text("Loading records...")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white.opacity(0.45))
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.65)) {
                isAnimating = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                haloPulse = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
