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
        cpu.step()
        XCTAssertEqual(cpu.V[10], 2)
    }

}
