//
//  main.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Cocoa

NSApplication.shared()

let appDelegate = AppDelegate()
NSApp.delegate = appDelegate

NSApp.setActivationPolicy(.regular)
NSApp.run()
