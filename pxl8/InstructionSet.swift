//
//  InstructionSet.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Foundation

class InstructionSet
{
    // 0NNN - Calls RCA 1802 program at address NNN
    static func RCA(nnn: UInt16)
    {
        print("Warning! Not implemented.")
    }
    
    // 00E0 - Clears the screen
    static func CLR(_ cpu: CPU)
    {
        for row in 0..<32 {
            for column in 0..<64 {
                cpu.display[row][column] = 0
            }
        }
        
        cpu.pc += 2
    }
    
    // 00EE - Returns from a subroutine
    static func RET(_ cpu: CPU)
    {
        cpu.sp -= 1
        cpu.pc = cpu.stack[cpu.sp]
    }
    
    // 1NNN - Jumps to address NNN
    static func JUMP(_ cpu: CPU, nnn: UInt16)
    {
        cpu.pc = nnn
    }
    
    // 2NNN - Calls subroutine at NNN
    static func CALL(_ cpu: CPU, nnn: UInt16)
    {
        cpu.stack[cpu.sp] = cpu.pc + 2
        cpu.sp += 1
        cpu.pc = nnn
    }
    
    // 3XNN - Skips the next instruction if VX equals NN
    static func SKPEQ(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.pc += 2
        
        if (cpu.V[x] == nn) {
            cpu.pc += 2
        }
    }
    
    // 4XNN - Skips the next instruction if VX doesn't equal NN
    static func SKPNE(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.pc += 2
        
        if (cpu.V[x] != nn) {
            cpu.pc += 2
        }
    }
    
    // 5XY0 - Skips the next instruction if VX equals VY
    static func SKPEQ(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.pc += 2
        
        if (cpu.V[x] == cpu.V[y]) {
            cpu.pc += 2
        }
    }
    
    // 6XNN - Sets VX to NN
    static func CONST(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.V[x] = nn
        cpu.pc += 2
    }
    
    // 7XNN - Adds NN to VX
    static func ADD(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.V[x] = cpu.V[x] &+ nn
        cpu.pc += 2
    }
    
    // 8XY0 - Sets VX to the value of VY
    static func COPY(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY1 - Sets VX to VX or VY
    static func OR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] | cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY2 - Sets VX to VX and VY
    static func AND(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] & cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY3 - Sets VX to VX xor VY
    static func XOR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] ^ cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY4 - Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
    static func ADD(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] &+ cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY5 - VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
    static func SUB(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[x] &- cpu.V[y]
        cpu.pc += 2
    }
    
    // 8XY6 - Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.
    static func SHFTR(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        
        cpu.pc += 2
    }
    
    // 8XY7 - Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
    static func DIFF(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.V[x] = cpu.V[y] &- cpu.V[x]
        cpu.pc += 2
    }
    
    // 8XYE - Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.
    static func SHFTL(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        
        cpu.pc += 2
    }
    
    // 9XY0 - Skips the next instruction if VX doesn't equal VY
    static func SKPNE(_ cpu: CPU, x: UInt8, y: UInt8)
    {
        cpu.pc += 2
        
        if (cpu.V[x] != cpu.V[y]) {
            cpu.pc += 2
        }
    }
    
    // ANNN - Sets I to the address NNN
    static func SETI(_ cpu: CPU, nnn: UInt16)
    {
        cpu.I = nnn
        cpu.pc += 2
    }
    
    // BNNN - Jumps to the address NNN plus V0
    static func JUMPA(_ cpu: CPU, nnn: UInt16)
    {
        cpu.pc = UInt16(cpu.V[0]) &+ nnn
    }
    
    // CXNN - Sets VX to the result of a bitwise and operation on a random number and NN
    static func RAND(_ cpu: CPU, x: UInt8, nn: UInt8)
    {
        cpu.V[x] = UInt8(arc4random_uniform(256)) & nn
        cpu.pc += 2
    }
    
    // DXYN - Draws a sprite at coordinate (VX, VY) that has a width of 8 pixels and a height of N pixels
    static func DRAW(_ cpu: CPU, x: UInt8, y: UInt8, n: UInt8)
    {
        // Set VF flag to 0
        cpu.V[15] = 0
        
        for scany in 0..<n {
            let pixels: UInt8 = cpu.memory[cpu.I + UInt16(scany)]
            
            for scanx: UInt8 in 0..<8 {
                let pixel: UInt8 = (pixels & (0b1 << (7 - scanx))) >> (7 - scanx)
                
                if (pixel != 0) {
                    let px = (scanx + cpu.V[x]) % 64
                    let py = (scany + cpu.V[y]) % 32
                    
                    if (cpu.display[py][px] == 1) {
                        cpu.V[15] = 1
                    }
                    
                    cpu.display[py][px] ^= 1
                }
            }
        }
        
        cpu.pc += 2
    }
    
    // EX9E - Skips the next instruction if the key stored in VX is pressed
    static func KDOWN(_ cpu: CPU, x: UInt8)
    {
        if (cpu.key[cpu.V[x]] != 0) {
            cpu.pc += 2
        }
        
        cpu.pc += 2
    }
    
    // EXA1 - Skips the next instruction if the key stored in VX isn't pressed
    static func KUP(_ cpu: CPU, x: UInt8)
    {
        if (cpu.key[cpu.V[x]] == 0) {
            cpu.pc += 2
        }
        
        cpu.pc += 2
    }
    
    // FX07 - Sets VX to the value of the delay timer
    static func LOADD(_ cpu: CPU, x: UInt8)
    {
        cpu.V[x] = cpu.delayTimer
        cpu.pc += 2
    }
    
    // FX0A - A key press is awaited, and then stored in VX
    static func KWAIT(_ cpu: CPU, x: UInt8)
    {
        for key in 0..<cpu.key.count {
            if (cpu.key[key] != 0) {
                cpu.V[x] = UInt8(key)
                cpu.pc += 2
                return
            }
        }
    }
    
    // FX15 - Sets the delay timer to VX
    static func DELAY(_ cpu: CPU, x: UInt8)
    {
        cpu.delayTimer = cpu.V[x]
        cpu.pc += 2
    }
    
    // FX18 - Sets the sound timer to VX
    static func SOUND(_ cpu: CPU, x: UInt8)
    {
        cpu.soundTimer = cpu.V[x]
        cpu.pc += 2
    }
    
    // FX1E - Adds VX to I
    static func ADDI(_ cpu: CPU, x: UInt8)
    {
        cpu.I = UInt16(cpu.V[x]) &+ cpu.I
        cpu.pc += 2
    }
    
    // FX29 - Sets I to the location of the sprite for the character in VX
    static func CHAR(_ cpu: CPU, x: UInt8)
    {
        cpu.I = UInt16(cpu.V[x]) * UInt16(CPU.FONT_SIZE)
        cpu.pc += 2
    }
    
    // FX33 - Stores the binary coded decimal representation of VX in I
    static func BCD(_ cpu: CPU, x: UInt8)
    {
        // Hundreds digit
        cpu.memory[cpu.I] = cpu.V[x] / 100
        
        // Tens digit
        cpu.memory[cpu.I + 1] = (cpu.V[x] % 100) / 10
        
        // Units digit
        cpu.memory[cpu.I + 2] = cpu.V[x] % 10
        
        cpu.pc += 2
    }
    
    // FX55 - Stores V0 to VX in memory starting at address I
    static func STORE(_ cpu: CPU, x: UInt8)
    {
        for i in 0...x {
            cpu.memory[cpu.I + UInt16(i)] = cpu.V[i]
        }
        
        cpu.pc += 2
    }
    
    // FX65 - Fills V0 to VX with values from memory starting at address I
    static func FILL(_ cpu: CPU, x: UInt8)
    {
        for i in 0...x {
            cpu.V[i] = cpu.memory[cpu.I + UInt16(i)]
        }
        
        cpu.pc += 2
    }
}
