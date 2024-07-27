// 

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let point1 = Coordinate(xlocation: 0, ylocation: 1)
        let point2 = Coordinate(xlocation: 0,ylocation: 2)
        Swift.print("Distance between \(point1) && \(point2) is: \(point1.distance(to: point2))")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

