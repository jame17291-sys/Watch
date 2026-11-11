import Foundation

/// Pure time math for the analog face, kept separate from the view so it is easy to test.
struct ClockModel {
    let date: Date
    let calendar: Calendar

    init(date: Date, calendar: Calendar = .current) {
        self.date = date
        self.calendar = calendar
    }

    private var components: DateComponents {
        calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
    }

    /// Fractional seconds within the current minute, 0..<60.
    var seconds: Double {
        let c = components
        return Double(c.second ?? 0) + Double(c.nanosecond ?? 0) / 1_000_000_000
    }

    /// Fractional minutes within the current hour, 0..<60.
    var minutes: Double {
        Double(components.minute ?? 0) + seconds / 60
    }

    /// Fractional hours on a 12-hour dial, 0..<12.
    var hours: Double {
        Double((components.hour ?? 0) % 12) + minutes / 60
    }

    /// Rotation angles in degrees, measured clockwise from 12 o'clock.
    var secondAngle: Double { seconds / 60 * 360 }
    var minuteAngle: Double { minutes / 60 * 360 }
    var hourAngle: Double { hours / 12 * 360 }
}
