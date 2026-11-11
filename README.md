# Watch

A standalone Apple Watch app written in SwiftUI. No iPhone companion app is
required; it installs directly on watchOS 10 or later.

## Pages

Swipe vertically between three pages:

1. **Clock** – an analog face with hour ticks, numerals, a sweeping second hand
   and the weekday and date underneath.
2. **Activity** – step and stand-hour rings with local goals. Values are stored
   on the watch so the page works without HealthKit entitlements.
3. **Timer** – a countdown timer. Turn the Digital Crown to set the minutes,
   tap play to start. The end time is wall-clock based so it stays correct when
   the app is suspended.

## Project layout

```
Watch.xcodeproj/               Xcode project (single watchOS app target)
Watch Watch App/
  WatchApp.swift               @main entry point
  Views/ContentView.swift      Vertical TabView holding the three pages
  Views/ClockFaceView.swift    Analog clock face
  Views/ActivityView.swift     Activity rings
  Views/TimerView.swift        Countdown timer UI
  Models/ClockModel.swift      Hand angle math
  Models/TimerModel.swift      Timer state machine
  Assets.xcassets/             App icon slot and accent colour
```

## Install on your Apple Watch

You need a Mac with Xcode 16 or later and an Apple ID (a free account is enough
for installing on your own devices).

1. Clone this repository and open `Watch.xcodeproj` in Xcode.
2. Select the **Watch Watch App** target, open **Signing & Capabilities**, and
   choose your Team. Xcode will create a provisioning profile automatically.
   Change the bundle identifier if Xcode reports it is already taken.
3. Pair your iPhone with the Mac over USB or Wi‑Fi, and make sure the watch is
   on your wrist, unlocked and paired to that iPhone.
4. In the run-destination menu at the top of Xcode choose your Apple Watch
   (it appears under the paired iPhone). The first time, Xcode may ask you to
   enable Developer Mode on the watch: on the watch go to
   **Settings → Privacy & Security → Developer Mode**, turn it on and restart.
5. Press **Run** (⌘R). Xcode builds the app and installs it over the air. The
   first install can take a couple of minutes.
6. If the watch shows an "Untrusted Developer" prompt, confirm it on the watch
   under **Settings → General → Device Management**.

To try it without hardware, pick any Apple Watch simulator as the destination
and press Run.

## Add an app icon

Drop a 1024×1024 PNG onto the **AppIcon** slot in
`Watch Watch App/Assets.xcassets`. The build works without one, but App Store
submission requires it.
