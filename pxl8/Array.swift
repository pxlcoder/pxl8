//
//  Array.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

extension Array
{
    subscript(index: UInt8) -> Element
        {
        get
        {
            return self[Int(index)]
        }
        set
        {
            self[Int(index)] = newValue
        }
    }
    
    subscript(index: UInt16) -> Element
        {
        get
        {
            return self[Int(index)]
        }
        set
        {
            self[Int(index)] = newValue
        }
    }
}
