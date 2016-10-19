//
//  Display.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-18.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Cocoa

class Display: NSView {
    
    private var cpu: CPU
    {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        return appDelegate.cpu
    }
    
    private var keyMap: [UInt16: UInt8] = [18: 0x1, 19: 0x2, 20: 0x3, 21: 0xC,
                                           12: 0x4, 13: 0x5, 14: 0x6, 15: 0xD,
                                            0: 0x7,  1: 0x8,  2: 0x9,  3: 0xE,
                                            6: 0xA,  7: 0x0,  8: 0xB,  9: 0xF]
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        let key = keyMap[event.keyCode]
        
        if let key = key {
            cpu.key[key] = 1
        }
    }
    
    override func keyUp(with event: NSEvent) {
        let key = keyMap[event.keyCode]
        
        if let key = key {
            cpu.key[key] = 0
        }
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
                                           self.bounds.size.height - CGFloat(row) * pixelHeight,
                                           pixelWidth,
                                           pixelHeight)
                    NSRectFill(pixel)
                }
            }
        }
    }
    
}
