.data
    UTF8Sequence: .word 0x8A9E # Example 24-bit UTF-8 sequence

.text

# Carry out the decoding (UTF-8 to code point) as on line 3 of the table (3 byte UTF-8)
# For the translation you are given your input in register $a3, and return your result in register $a2.

# 1
# Convert from hexadecimal to decimal
# 8A9E = 1000101010011110 = 1000 101010 011110

# 3-byte UTF-8 sequence: 1110zzzz 10yyyyyy 10xxxxxx
# 2
# 1110zzzz 10yyyyyy 10xxxxxx
# FILL IN THE BITS
# 11101000  10101010    10011110
# E8        AA          9E  


    lw $a3 UTF8Sequence



    move $t0, $a3       # register to hold the first four bits
    move $t1, $a3       # register to hold the next six bits
    move $t2, $a3       # register to hold the last six bits

    # Get first four bits = 8
    srl $t0, $t0, 12    # register now holds the first four bits

    # Get 5th to 10th bit = 2A
    sll $t1, $t1, 20    
    srl $t1, $t1, 26    # register now holds the 5th to 10th bits

    # Get the last 6 bits = 1E
    sll $t2, $t2, 26   # Shift left by 26 bits to clear bits 0-5
    srl $t2, $t2, 26 




    # apply 1110zzzz
    ori $t0, $t0, 0xE0   # Logical OR with 1110 in binary (0xE in hexadecimal)

    # apply 10yyyyyy
    ori $t1, $t1, 0x80 # OR with binary "10" to concatenate

    # apply 10xxxxxx
    ori $t2, $t2, 0x80 # OR with binary "10" to concatenate



    #concatenate the remaining 3 strings
    sll $t0, $t0, 8
    or $t0, $t0, $t1

    sll $t0, $t0, 8
    or $t0, $t0, $t2


    move $a2, $t0

    li $v0, 1            # System call code for print_int
    move $a0, $a2        # Move the value from $a2 to $a0
    syscall              # Make the system call to print_int

    # Print a newline for better formatting
    li $v0, 4            # System call code for print_str
    la $a0, newline      # Load the address of the newline string
    syscall              # Make the system call to print_str

    # Exit the program
    li $v0, 10           # System call code for exit
    syscall              # Make the system call to exit







