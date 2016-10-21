//
//  AppDelegate.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    let window = NSWindow()
    let display = Display()
    let cpu = CPU()

    func applicationDidFinishLaunching(_ notification: Notification){
        NSApp.activate(ignoringOtherApps: true)
        
        window.setContentSize(NSSize(width:64*5, height:32*5))
        window.contentAspectRatio = NSSize(width: 64, height: 32)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "pxl8"
        window.contentView = display
        window.center()
        window.makeKeyAndOrderFront(window)
        
        cpu.screen = display
        
        let mainMenu = NSMenu()
        let mainAppMenuItem = NSMenuItem(title: "pxl8", action: nil, keyEquivalent: "")
        mainMenu.addItem(mainAppMenuItem)
        
        let appMenu = NSMenu()
        mainAppMenuItem.submenu = appMenu
        
        let recentItemsMenu = NSMenu()
        let recentFilesMenuItem = NSMenuItem(title: "Load Recent", action: nil, keyEquivalent: "")
        recentFilesMenuItem.submenu = recentItemsMenu
        
        appMenu.addItem(withTitle: "Load", action: #selector(load), keyEquivalent: "o")
        appMenu.addItem(recentFilesMenuItem)
        
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Hide pxl8", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit pxl8", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
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
                if let fileURL = fileBrowser.url?.absoluteString.replacingOccurrences(of: "file:///", with: "/") {
                    self.cpu.load(ROM: fileURL)
                    self.cpu.run()
                }
            }
        })
    }
}
