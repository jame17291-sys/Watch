import SwiftUI

/// Simple daily activity rings backed by local goals. Values are kept in app storage
/// so the page is usable without HealthKit entitlements; wire HealthKit in later if wanted.
struct ActivityView: View {
    @AppStorage("steps") private var steps: Int = 0
    @AppStorage("stepGoal") private var stepGoal: Int = 8_000
    @AppStorage("standHours") private var standHours: Int = 0

    private var stepProgress: Double {
        guard stepGoal > 0 else { return 0 }
        return min(Double(steps) / Double(stepGoal), 1)
    }

    private var standProgress: Double {
        min(Double(standHours) / 12, 1)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ZStack {
                    ring(progress: stepProgress, color: .green, lineWidth: 10)
                        .frame(width: 96, height: 96)
                    ring(progress: standProgress, color: .cyan, lineWidth: 10)
                        .frame(width: 70, height: 70)
                    VStack(spacing: 0) {
                        Text("\(steps)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        Text("steps")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)

                Stepper("Steps +500", onIncrement: { steps += 500 },
                        onDecrement: { steps = max(0, steps - 500) })
                    .font(.footnote)

                Stepper("Stand hrs \(standHours)",
                        onIncrement: { standHours = min(12, standHours + 1) },
                        onDecrement: { standHours = max(0, standHours - 1) })
                    .font(.footnote)

                Button("Reset today", role: .destructive) {
                    steps = 0
                    standHours = 0
                }
                .font(.footnote)
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Activity")
    }

    private func ring(progress: Double, color: Color, lineWidth: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.25), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.4), value: progress)
        }
    }
}

#Preview {
    ActivityView()
}
