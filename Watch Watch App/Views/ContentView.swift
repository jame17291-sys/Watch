import SwiftUI

/// Root view. Three swipeable pages: clock face, activity, timer.
struct ContentView: View {
    @State private var selection: Page = .clock

    enum Page: Hashable {
        case clock, activity, timer
    }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { ClockFaceView() }
                .tag(Page.clock)
            NavigationStack { ActivityView() }
                .tag(Page.activity)
            NavigationStack { TimerView() }
                .tag(Page.timer)
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView()
}
