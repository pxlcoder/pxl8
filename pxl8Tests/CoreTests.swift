//
//  CoreTests.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import XCTest
@testable import pxl8

class CoreTests: XCTestCase {

    var cpu: CPU!
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cpu = CPU()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStoreConstant()
    {
        let instructions: [UInt8] = [0x6A, 0x02]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }

        XCTAssertEqual(cpu.V[10], 2)
    }
    
    func testAdd()
    {
        let instructions: [UInt8] = [0x71, 0x70]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.V[1], 112)
    }
    
    func testStoreCopy()
    {
        let instructions: [UInt8] = [0x6B, 0x03,
                                     0x81, 0xB0]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.V[1], 3)
    }
    
    func testAddToI()
    {
        let instructions: [UInt8] = [0x6B, 0x03,
                                     0xFB, 0x1E]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.I, 3)
    }

}
