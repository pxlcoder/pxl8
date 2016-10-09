import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
  let window = NSWindow()

  func applicationDidFinishLaunching(_ notification: Notification){
      NSApp.activate(ignoringOtherApps: true)

      window.setContentSize(NSSize(width:64*5, height:32*5))
      window.styleMask = [.titled, .closable, .miniaturizable]
      window.title = "pxl8"
      window.center()
      window.makeKeyAndOrderFront(window)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool
  {
      return true
  }
}
