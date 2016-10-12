//
//  InstructionSet.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

class InstructionSet
{
    // 0NNN - Calls RCA 1802 program at address NNN
    func RCA(nnn: UInt16)
    {
        print("Warning! Not implemented.")
    }
    
    // 00E0 - Clears the screen
    func CLR(_ cpu: CPU)
    {
        for row in 0..<32 {
            for column in 0..<64 {
                cpu.display[row][column] = 0
            }
        }
    }
    
    // 00EE - Returns from a subroutine
    
    // 1NNN - Jumps to address NNN
    
    // 2NNN - Calls subroutine at NNN
    
    // 3XNN - Skips the next instruction if VX equals NN
    
    // 4XNN - Skips the next instruction if VX doesn't equal NN
    
    // 5XY0 - Skips the next instruction if VX equals VY
    
    // 6XNN - Sets VX to NN
    
    static func CONST(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.V[x] = nn
    }
    
    // 7XNN - Adds NN to VX
    
    // 8XY0 - Sets VX to the value of VY
    
    static func COPY(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[y]
    }
    
    // 8XY1 - Sets VX to VX or VY
    
    static func OR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] | cpu.V[y]
    }
    
    // 8XY2 - Sets VX to VX and VY
    
    static func AND(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] & cpu.V[y]
    }
    
    // 8XY3 - Sets VX to VX xor VY
    
    static func XOR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] ^ cpu.V[y]
    }
    
    // 8XY4 - Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
    static func ADD(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] &+ cpu.V[y]
    }
    
    // 8XY5 - VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
    static func SUB(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] &- cpu.V[y]
    }
    
    // 8XY6 - Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.
    static func SHFTR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        
    }
    
    // 8XY7 - Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
    static func DIFF(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[y] &- cpu.V[x]
    }
    
    // 8XYE - Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.
    static func SHFTL(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        
    }
    
    // 9XY0 - Skips the next instruction if VX doesn't equal VY
    // ANNN - Sets I to the address NNN
    // BNNN - Jumps to the address NNN plus V0
    // CXNN - Sets VX to the result of a bitwise and operation on a random number and NN
    // DXYN - Draws at sprite
    // EX9E - Skips the next instruction if the key stored in VX is pressed
    // EXA1 - Skips the next instruction if the key stored in VX isn't pressed
    // FX07 - Sets VX to the value of the delay timer
    // FX0A - A key press is awaited, and then stored in VX
    // FX15 - Sets the delay timer to VX
    // FX18 - Sets the sound timer to VX
    // FX1E - Adds VX to I
    // FX29 - Sets I to the location of the sprite for the character in VX
    // FX33 - Stores the binary coded decimal representation of VX in I
    // FX55 - Stores V0 to VX in memory starting at address I
    // FX65 - Fills V0 to VX with values from memory starting at address I
}
