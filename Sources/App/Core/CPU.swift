class CPU
{
    // 4K system memory
    private var memory = [UInt8](repeating: 0, count: 4096)

    // 16 8-bit registers, V0 - VF
    // VF is reserved for the carry flag
    private var V = [UInt8](repeating: 0, count: 16)

    // The address register, used with several opcodes that involve memory operations
    private var I: UInt16 = 0

    // Program counter, stores the address of the next instruction to execute
    // Begins at 0x200 as the original CHIP-8 interpreter occupied the first 512 bytes of memory
    private var pc: UInt16 = 0x200

    // 64x32 display - 1 represents on, 0 represents off
    public var display = Array(repeating: [Int](repeating: 0, count: 64), count: 32)

    // Two timer registers that count at 60 Hz
    private var delayTimer: UInt8 = 0
    private var soundTimer: UInt8 = 0

    // The stack, used to store return addresses when subroutines are called
    private var stack = [UInt16](repeating:0, count: 16)
    private var sp: Int = 0

    // Stores the current state of the keys, 16 in total
    private var key = [UInt8](repeating:0, count:16)
}
