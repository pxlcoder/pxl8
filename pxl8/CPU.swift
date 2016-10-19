//
//  CPU.swift
//  pxl8
//
//  Created by Aditya Keerthi on 2016-10-12.
//  Copyright © 2016 Aditya Keerthi. All rights reserved.
//

import Cocoa

class CPU
{
    static let MEM_SIZE = 4096
    static let PC_OFFSET = 512
    static let FONT_SIZE = 5
    
    // 4K system memory
    internal var memory = [UInt8](repeating: 0, count: CPU.MEM_SIZE)
    
    // 16 8-bit registers, V0 - VF
    // VF is reserved for the carry flag
    internal var V = [UInt8](repeating: 0, count: 16)
    
    // The address register, used with several opcodes that involve memory operations
    internal var I: UInt16 = 0
    
    // Program counter, stores the address of the next instruction to execute
    // Begins at 0x200 as the original CHIP-8 interpreter occupied the first 512 bytes of memory
    internal var pc: UInt16 = UInt16(CPU.PC_OFFSET)
    
    // 64x32 display - 1 represents on, 0 represents off
    public var display = Array(repeating: [Int](repeating: 0, count: 64), count: 32)
    public var updateDisplay = false
    public weak var screen: Display?
    
    // Two timer registers that count at 60 Hz
    internal var delayTimer: UInt8 = 0
    internal var soundTimer: UInt8 = 0
    
    // The stack, used to store return addresses when subroutines are called
    internal var stack = [UInt16](repeating:0, count: 16)
    internal var sp: Int = 0
    
    // Stores the current state of the keys, 16 in total
    internal var key = [UInt8](repeating:0, count:16)
    
    // Current opcode
    private var opcode: UInt16
    {
        return (UInt16(memory[pc]) << 8) | UInt16(memory[pc+1])
    }
    
    init()
    {
        self.loadFontset()
    }
    
    private func loadFontset()
    {
        let fontset: [UInt8] = [0xF0, 0x90, 0x90, 0x90, 0xF0,   // 0
                                0x20, 0x60, 0x20, 0x20, 0x70,   // 1
                                0xF0, 0x10, 0xF0, 0x80, 0xF0,   // 2
                                0xF0, 0x10, 0xF0, 0x10, 0xF0,   // 3
                                0x90, 0x90, 0xF0, 0x10, 0x10,   // 4
                                0xF0, 0x80, 0xF0, 0x10, 0xF0,   // 5
                                0xF0, 0x80, 0xF0, 0x90, 0xF0,   // 6
                                0xF0, 0x10, 0x20, 0x40, 0x40,   // 7
                                0xF0, 0x90, 0xF0, 0x90, 0xF0,   // 8
                                0xF0, 0x90, 0xF0, 0x10, 0xF0,   // 9
                                0xF0, 0x90, 0xF0, 0x90, 0x90,   // A
                                0xE0, 0x90, 0xE0, 0x90, 0xE0,   // B
                                0xF0, 0x80, 0x80, 0x80, 0xF0,   // C
                                0xE0, 0x90, 0x90, 0x90, 0xE0,   // D
                                0xF0, 0x80, 0xF0, 0x80, 0xF0,   // E
                                0xF0, 0x80, 0xF0, 0x80, 0x80]   // F
        
        // Fontset loaded into memory beginning at zero
        for i in 0..<(CPU.FONT_SIZE*16) {
            memory[i] = fontset[i]
        }
    }
    
    // Run loop
    
    func run()
    {
        Timer.scheduledTimer(withTimeInterval: 1.0/300.0, repeats: true) { Timer in
            self.updateClock()
            self.step()
            
            if (self.updateDisplay) {
                self.updateDisplay = false
                self.screen?.needsDisplay = true
            }
        }
    }
    
    // Load from file
    
    func load(ROM: String)
    {
        let rom = fopen(ROM, "r")
        fread(&memory + CPU.PC_OFFSET, MemoryLayout<UInt8>.size, CPU.MEM_SIZE - CPU.PC_OFFSET, rom)
        fclose(rom)
    }
    
    // Load from array
    
    func load(_ instructions: [UInt8])
    {
        for i in 0..<instructions.count {
            memory[CPU.PC_OFFSET + i] = instructions[i]
        }
    }
    
    // Update delay timer and sound timer
    
    func updateClock()
    {
        if (delayTimer > 0) {
            delayTimer -= 1
        }
        
        if (soundTimer > 0) {
            soundTimer -= 1
        }
    }
    
    // Fetch and execute opcodes
    
    func step()
    {
        let x: UInt8 = UInt8((opcode & 0x0F00) >> 8)
        let y: UInt8 = UInt8((opcode & 0x00F0) >> 4)
        let n: UInt8 = UInt8(opcode & 0x000F)
        let nn: UInt8 = UInt8(opcode & 0xFF)
        let nnn: UInt16 = opcode & 0x0FFF
        
        switch opcode & 0xF000 {
        case 0x0000:
            switch opcode {
            case 0x00E0:
                InstructionSet.CLR(self)
            case 0x00EE:
                InstructionSet.RET(self)
            default:
                InstructionSet.RCA(nnn: nnn)
            }
        case 0x1000:
            InstructionSet.JUMP(self, nnn: nnn)
        case 0x2000:
            InstructionSet.CALL(self, nnn: nnn)
        case 0x3000:
            InstructionSet.SKPEQ(self, x: x, nn: nn)
        case 0x4000:
            InstructionSet.SKPNE(self, x: x, nn: nn)
        case 0x5000:
            InstructionSet.SKPEQ(self, x: x, y: y)
        case 0x6000:
            InstructionSet.CONST(self, x: x, nn: nn)
        case 0x7000:
            InstructionSet.ADD(self, x: x, nn: nn)
        case 0x8000:
            switch opcode & 0x000F {
            case 0x0000:
                InstructionSet.COPY(self, x: x, y: y)
            case 0x0001:
                InstructionSet.OR(self, x: x, y: y)
            case 0x0002:
                InstructionSet.AND(self, x: x, y: y)
            case 0x0003:
                InstructionSet.XOR(self, x: x, y: y)
            case 0x0004:
                InstructionSet.ADD(self, x: x, y: y)
            case 0x0005:
                InstructionSet.SUB(self, x: x, y: y)
            case 0x0006:
                InstructionSet.SHFTR(self, x: x, y: y)
            case 0x0007:
                InstructionSet.DIFF(self, x: x, y: y)
            case 0x000E:
                InstructionSet.SHFTL(self, x: x, y: y)
            default:
                print("Encountered unsupported opcode!")
            }
        case 0x9000:
            InstructionSet.SKPNE(self, x: x, y: y)
        case 0xA000:
            InstructionSet.SETI(self, nnn: nnn)
        case 0xB000:
            InstructionSet.JUMPA(self, nnn: nnn)
        case 0xC000:
            InstructionSet.RAND(self, x: x, nn: nn)
        case 0xD000:
            InstructionSet.DRAW(self, x: x, y: y, n: n)
        case 0xE000:
            switch opcode & 0x00FF {
            case 0x009E:
                InstructionSet.KDOWN(self, x: x)
            case 0x00A1:
                InstructionSet.KUP(self, x: x)
            default:
                print("Encountered unsupported opcode!")
            }
        case 0xF000:
            switch opcode & 0x00FF {
            case 0x0007:
                InstructionSet.LOADD(self, x: x)
            case 0x000A:
                InstructionSet.KWAIT(self, x: x)
            case 0x0015:
                InstructionSet.DELAY(self, x: x)
            case 0x0018:
                InstructionSet.SOUND(self, x: x)
            case 0x001E:
                InstructionSet.ADDI(self, x: x)
            case 0x0029:
                InstructionSet.CHAR(self, x: x)
            case 0x0033:
                InstructionSet.BCD(self, x: x)
            case 0x0055:
                InstructionSet.STORE(self, x: x)
            case 0x0065:
                InstructionSet.FILL(self, x: x)
            default:
                print("Encountered unsupported opcode!")
            }
        default:
            print("Encountered unsupported opcode!")
        }
    }
}
