import SwiftUI
import WatchKit

/// Countdown timer page. Digital Crown adjusts the duration while idle.
struct TimerView: View {
    @State private var model = TimerModel()
    @State private var crownMinutes: Double = 5

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { context in
            let remaining = model.remaining(at: context.date)
            VStack(spacing: 10) {
                Text(TimerModel.format(remaining))
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(remaining == 0 && model.isRunning ? .red : .primary)
                    .contentTransition(.numericText())

                if model.isRunning, remaining == 0 {
                    Text("Done")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .onAppear { WKInterfaceDevice.current().play(.success) }
                }

                HStack(spacing: 8) {
                    Button(role: .destructive) {
                        model.reset()
                        crownMinutes = model.duration / 60
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .disabled({ if case .idle = model.state { return true } else { return false } }())

                    Button {
                        if model.isRunning {
                            model.pause()
                        } else {
                            model.start()
                            WKInterfaceDevice.current().play(.start)
                        }
                    } label: {
                        Image(systemName: model.isRunning ? "pause.fill" : "play.fill")
                    }
                    .tint(model.isRunning ? .orange : .green)
                }
                .buttonStyle(.bordered)
            }
            .focusable()
            .digitalCrownRotation(
                $crownMinutes,
                from: 1, through: 180, by: 1,
                sensitivity: .medium,
                isContinuous: false,
                isHapticFeedbackEnabled: true
            )
            .onChange(of: crownMinutes) { _, newValue in
                guard case .idle = model.state else { return }
                model.duration = newValue.rounded() * 60
            }
        }
        .navigationTitle("Timer")
    }
}

#Preview {
    TimerView()
}
