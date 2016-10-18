//
//  MainView.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-18.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Cocoa

class MainView: NSView {
    
    private var cpu: CPU
    {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        return appDelegate.cpu
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Set background to black
        NSColor.black.setFill()
        NSRectFill(self.bounds)
        
        // Set pixel color to white
        NSColor.white.setFill()
        
        let pixelWidth = self.bounds.size.width / 64
        let pixelHeight = self.bounds.size.height / 32
        
        for row in 0..<32 {
            for column in 0..<64
            {
                if cpu.display[row][column] != 0 {
                    let pixel = NSMakeRect(CGFloat(column) * pixelWidth,
                                           CGFloat(row) * pixelHeight,
                                           pixelWidth,
                                           pixelHeight)
                    NSRectFill(pixel)
                }
            }
        }
    }
    
}
