import Foundation
import Observation

/// Countdown timer state. Uses a wall-clock end date so it stays accurate when
/// the app is suspended and resumed.
@Observable
final class TimerModel {
    enum State: Equatable {
        case idle
        case running(endsAt: Date)
        case paused(remaining: TimeInterval)
    }

    var state: State = .idle
    var duration: TimeInterval = 5 * 60

    var isRunning: Bool {
        if case .running = state { return true }
        return false
    }

    func remaining(at now: Date = .now) -> TimeInterval {
        switch state {
        case .idle:
            return duration
        case .running(let endsAt):
            return max(0, endsAt.timeIntervalSince(now))
        case .paused(let remaining):
            return remaining
        }
    }

    var isFinished: Bool {
        if case .running(let endsAt) = state { return endsAt <= .now }
        return false
    }

    func start(now: Date = .now) {
        switch state {
        case .idle:
            state = .running(endsAt: now.addingTimeInterval(duration))
        case .paused(let remaining):
            state = .running(endsAt: now.addingTimeInterval(remaining))
        case .running:
            break
        }
    }

    func pause(now: Date = .now) {
        guard case .running = state else { return }
        state = .paused(remaining: remaining(at: now))
    }

    func reset() {
        state = .idle
    }

    func adjust(by delta: TimeInterval) {
        guard case .idle = state else { return }
        duration = min(max(60, duration + delta), 24 * 60 * 60)
    }

    static func format(_ interval: TimeInterval) -> String {
        let total = Int(interval.rounded(.up))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
