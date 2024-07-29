// 

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            let saveURL = URL(filePath: "/Users/charles/Documents/Playground")
            let map = try Map.loadMap(url: saveURL.appending(path: "test.map"))
            try map.save(to: saveURL.appending(path: "test1.map"))
        }
        catch {
            Swift.print(error)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

