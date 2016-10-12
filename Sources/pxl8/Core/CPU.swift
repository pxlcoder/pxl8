import Cocoa

class CPU
{
    static let MEM_SIZE = 4096
    static let PC_OFFSET = 512

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

    // TODO: Implement file open logic
    init()
    {
        self.load(ROM: "/Users/akeerthi/Developer/pxl8/Resources/pong.rom")
    }

    func load(ROM: String)
    {
        let rom = fopen(ROM, "r")
        fread(&memory + CPU.PC_OFFSET, MemoryLayout<UInt8>.size, CPU.MEM_SIZE - CPU.PC_OFFSET, rom)
        fclose(rom)
    }

    func step()
    {
        print(String(format:"%04X", opcode))
    }

    func incrementPC()
    {
        pc += 2
    }
}
