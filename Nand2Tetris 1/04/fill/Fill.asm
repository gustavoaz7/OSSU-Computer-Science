// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Screen is 32x256 = 8192 addresses

(INIT)
// Initialize index as the total number of addresses of screen
@8192
D=A
@index
M=D

(LOOP)
// Decrease index by 1 on each iteration
@index
M=M-1
D=M
@INIT
// Reset if index<0
D;JLT
@KBD
D=M
@WHITE
// Paints white if keyboard is not pressed (0)
D;JEQ
@BLACK
// Paints black otherwise (1)
0;JMP

(WHITE)
@SCREEN   // Loads screen's first address
D=A
@index
A=D+M     // Select address by adding screen's first address to current index
M=0       // Paints white
@LOOP
0;JMP

(BLACK)
@SCREEN   // Loads screen's first address
D=A
@index
A=D+M     // Select address by adding screen's first address to current index
M=-1      // Paints black
@LOOP
0;JMP
