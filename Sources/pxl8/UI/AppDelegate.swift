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

      let mainMenu = NSMenu()
      let mainAppMenuItem = NSMenuItem(title: "pxl8", action: nil, keyEquivalent: "")
      mainMenu.addItem(mainAppMenuItem)

      let appMenu =   NSMenu()
      mainAppMenuItem.submenu =   appMenu

      appMenu.addItem(withTitle: "Load", action: #selector(load), keyEquivalent: "o")

      appMenu.addItem(NSMenuItem.separator())
      appMenu.addItem(withTitle: "Hide pxl8", action: "hide:", keyEquivalent: "h")

      appMenu.addItem(NSMenuItem.separator())
      appMenu.addItem(withTitle: "Quit pxl8", action: "terminate:", keyEquivalent: "q")

      NSApplication.shared().mainMenu = mainMenu
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool
  {
      return true
  }

  func load()
  {
      let fileBrowser = NSOpenPanel()
      
      fileBrowser.begin(completionHandler: { returnCode in
          if (returnCode == NSFileHandlingPanelOKButton) {
              let rom = fopen(fileBrowser.url?.path, "r")
              fclose(rom)
          }
      })
  }
}
