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
    
    // 00E0 - Clears the screen
    func testClearScreen()
    {
        let instructions: [UInt8] = [0x00, 0xE0]
        cpu.load(instructions)
        
        cpu.display[0][0] = 1
        cpu.display[25][49] = 1
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        for i in 0..<32
        {
            for j in 0..<64
            {
                XCTAssertTrue(cpu.display[i][j] == 0)
            }
        }
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
    
    func testAddOverflow()
    {
        let instructions: [UInt8] = [0x6B, 0x03,
                                     0x6A, 0xFF,
                                     0x8B, 0xA4]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.V[0xB], 2)
        XCTAssertEqual(cpu.V[0xF], 1)
    }
    
    func testSubOverflow()
    {
        let instructions: [UInt8] = [0x6B, 0x03,
                                     0x6A, 0xFF,
                                     0x8B, 0xA5]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.V[0xB], 4)
        XCTAssertEqual(cpu.V[0xF], 0)
    }
    
    func testSubnOverflow()
    {
        let instructions: [UInt8] = [0x6B, 0x03,
                                     0x6A, 0xFF,
                                     0x8A, 0xB7]
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertEqual(cpu.V[0xA], 4)
        XCTAssertEqual(cpu.V[0xF], 0)
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
    
    func testBCD()
    {
        let instructions: [UInt8] = [0x6A, 0xAB,    // Sets V[10] to 171 (AB)
                                     0xAA, 0xAA,    // Sets I to the address AAA
                                     0xFA, 0x33]    // Stores the BCD value of V[10] at I
        
        cpu.load(instructions)
        
        for _ in 0..<instructions.count/2
        {
            cpu.step()
        }
        
        XCTAssertTrue(cpu.memory[cpu.I] == 1)
        XCTAssertTrue(cpu.memory[cpu.I + 1] == 7)
        XCTAssertTrue(cpu.memory[cpu.I + 2] == 1)
    }

}
