.data
    UTF8Sequence: .word 0x9EAAE8 #Example 24-bit UTF-8 sequence

.text

    lw $a3 UTF8Sequence


# Carry out the decoding (UTF-8 to code point) as on line 3 of the table (3 byte UTF-8)
# For the translation you are given your input in register $a3, and return your result in register $a2.

# 3-byte UTF-8 sequence: 1110zzzz 10yyyyyy 10xxxxxx

# 1110zzzz 10yyyyyy 10xxxxxx
# FILL IN THE BITS

# 11101000  10101010    10011110
# E8        AA          9E  

#OUTPUT
# 8A9E = 1000101010011110 = 1000 101010 011110


    move $t0, $a3       # register to hold the z 
    move $t1, $a3       # register to hold the y
    move $t2, $a3       # register to hold the x


    sll $t0, $t0, 24    # Keeps the first 8 bits 
    srl $t0, $t0, 24    # register contains e8

    sll $t1, $t1, 16    # Keeps the 9th to 16th bits
    srl $t1, $t1, 24    # register contains aa

                        # Keeps the last 6 bits
                        # Immediately removes the extra encoding bits
    srl $t2, $t2, 16    # register contains 9e
    



    # Removing the encoding bits

    #$t0 11101000 - only want to capture the last four bits to 1000 to 8
    
    sll $t0, $t0, 28
    srl $t0, $t0, 28 # register contains 8


    # $t1 101010 - only want to capture the last 6 bits to 101010 = 2A

    sll $t1, $t1, 2
    srl $t1, $t1, 4


    # $t2 already has already cut off the extra encoding bits so no
    # need to remove them
    







    # Concetenating the full binary string

    sll $t0, $t0, 6     # First shift $t0 up by 6 bits to accomodate new bits
    or $t0, $t0, $t1    # Add the second byte
    sll $t0, $t0, 6     # Shift $t0 up by another 6 bits
    or $t0, $t0, $t2    # Add the third byte

    move $a2 $t0











    li $v0, 1            # System call code for print_int
    move $a0, $a2        # Move the value from $a2 to $a0
    syscall              # Make the system call to print_int

    # Exit the program
    li $v0, 10           # System call code for exit
    syscall              # Make the system call to exit