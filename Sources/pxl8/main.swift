import Cocoa

NSApplication.shared()

let appDelegate = AppDelegate()
NSApp.delegate = appDelegate

NSApp.setActivationPolicy(.regular)
NSApp.run()
