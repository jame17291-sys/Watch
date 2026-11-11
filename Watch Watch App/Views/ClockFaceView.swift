import SwiftUI

/// Analog face with a digital readout and date underneath.
struct ClockFaceView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 10.0)) { context in
            let model = ClockModel(date: context.date)
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                ZStack {
                    dial(size: size)
                    hand(length: size * 0.26, width: 6, angle: model.hourAngle, color: .primary)
                    hand(length: size * 0.38, width: 4, angle: model.minuteAngle, color: .primary)
                    hand(length: size * 0.42, width: 1.5, angle: model.secondAngle, color: .accentColor)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 7, height: 7)
                    VStack(spacing: 0) {
                        Spacer()
                        Text(context.date, format: .dateTime.weekday(.abbreviated).day())
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, size * 0.1)
                    }
                    .frame(width: size, height: size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .navigationTitle("Watch")
        .ignoresSafeArea(edges: .bottom)
    }

    private func dial(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                .frame(width: size * 0.92, height: size * 0.92)
            ForEach(0..<60, id: \.self) { tick in
                let isHour = tick % 5 == 0
                Rectangle()
                    .fill(isHour ? Color.primary : Color.secondary.opacity(0.5))
                    .frame(width: isHour ? 2 : 1, height: isHour ? 10 : 5)
                    .offset(y: -size * 0.44)
                    .rotationEffect(.degrees(Double(tick) * 6))
            }
            ForEach([12, 3, 6, 9], id: \.self) { hour in
                Text("\(hour)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .offset(numeralOffset(for: hour, radius: size * 0.33))
            }
        }
    }

    private func numeralOffset(for hour: Int, radius: CGFloat) -> CGSize {
        let angle = Double(hour) / 12 * 2 * .pi - .pi / 2
        return CGSize(width: cos(angle) * radius, height: sin(angle) * radius)
    }

    private func hand(length: CGFloat, width: CGFloat, angle: Double, color: Color) -> some View {
        Capsule()
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(.degrees(angle))
            .shadow(radius: 1)
    }
}

#Preview {
    ClockFaceView()
}
