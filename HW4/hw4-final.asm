
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


; Student name: Ameen Haj-Yasin
; Student Number: 1162618

org 100h
.model meduiam 
.stack
 
.DATA
  hello db "Computer Organization and Assembly Language $" 
  message db 0DH,0AH,"Enter the First number : $"
  message1 db 0DH,0AH,"Enter the Second number : $"
  message2 db 0DH,0AH,"Enter the Third number : $"
  message3 db 0DH,0AH,"Enter the Forth number : $"
  message4 db 0DH,0AH,"Enter the Fifth number  : $"
  address dw ?
  
  ;USAGE db 0DH,0AH, "USAGE :$"
  ERR db  0DH,0AH,"USAGE: Wrong Value! $"
  

    dataArray DW 0, 0, 0, 0, 0
    sum DW ?
    average DW ?
    max DW ?
    min DW ?
    counter DB ?
    
    COUNT DB ?
    N DB ? 

    summsghex EQU 0DH,0AH,"The Sum of the Values in hexadecimal $"
	finalsummsghex DB summsghex
	
	summsg EQU 0DH,0AH,"The Sum of the Values in Decimal $"
	finalsummsg DB summsg
	
	
	avgmsghex EQU 0DH,0AH,"The Average of the Values in hexadecimal $"
	finalavgmsghex DB avgmsghex
	
    avgmsg EQU 0DH,0AH,0AH,"The Average of the Values in Decimal $"
	finalavgmsg DB avgmsg
	
	
	maxmsghex EQU 0DH,0AH,"The Max of the Values in hexadecimal $"
	finalmaxmsghex DB maxmsghex
	
    maxmsg EQU 0DH,0AH,0AH,"The Max of the Values in Decimal $"
	finalmaxmsg DB maxmsg    
	
	
	
    minmsghex EQU 0DH,0AH,"The Min of the Values in hexadecimal $"
	finalminmsghex DB minmsghex
	
	minmsg EQU 0DH,0AH,0AH,"The Min of the Values in Decimal $"
	finalminmsg DB minmsg	
	
.code 
begin:    
    
    ; This macro will display two desired messages after that we call <HEX_TO_DECIMAL) Procedure to display the given value  	    
    ; varible :
    ;           msg : the message that we want to display on the screen to the user in decimal number
    ;           var : is the numeric variable that we want to display
    ;           msg_hex : the message that we want to display on the screen to the user in hex number 
    ; return nth
    
    display MACRO msg,var,msg_hex  
	    LEA DX, msg ; load and display msg
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        
        MOV bx,var
        MOV dx,var
        call HEX_TO_DECIMAL
        
        LEA DX, msg_hex ; load and display msg
        MOV AH, 9
        INT 21H
        
        ;MOV AH, 2 ; set output function                
        xor dx,dx
        MOV dx,var
        xor BX,BX
        MOV BX,var
        ;PUSH var
        CALL PRINT_HEX
        
        
    ENDM
    
    
    mov ax,@data ; initialize DS
    mov ds,ax
    
    ;call DECIMAL_OUTPUT
    
    int 10h
         
    mov AH,02h
    ;MOV BH,00  ;color bh : page 
    MOV BL,0Ah ; color bh : page , bl : color -> light red
    MOV DX,0010H
    INT 10H
        
    mov ah, 09h ;write char and attribute
    mov cx, 50 ;number of char
    int 10h
        
    MOV AH,09H
    LEA DX,hello
    INT 21H
        
;        
;        mov al, "h"
;        mov bl, 0ah  
;        
;        mov bh,0
;        mov ah,2
;        mov dl , 20 ;column
;
;        ;mov dh , 5 ;row
;        ;mov dx,offset hello
;        ;mov ax ,0920h
;        ;mov cx,20
;        int 10h
;        
        
        

        
        ;mov ah ,02h
        
        ;mov cx,1
        
        ;int 21H
    
    
    xor ax,ax
    xor dx,dx 
    mov si,0    

    
    ;first input
    lea dx, message
    call INPUT 
    
    mov ah,2
    mov dl,0DH
    int 21h

    ;mov dl, 0ah
    ;int 21h
    
    ;second input
    lea dx, message1
    call INPUT
    
    mov ah,2
    mov dl,0DH
    int 21h

    ;mov dl, 0ah
    ;int 21h
       
    ;third input
    lea dx, message2
    call INPUT       
    
    mov ah,2
    mov dl,0DH
    int 21h

    ;mov dl, 0ah
    ;int 21h
          
    ;forth input
    lea dx, message3  
    call INPUT 
    
    mov ah,2
    mov dl,0DH
    int 21h

    ;mov dl, 0ah
    ;int 21h
    
    ;fifth input
    lea dx, message4
    call INPUT 
    
    mov ah,2
    mov dl,0DH
    int 21h

    mov dl, 0ah
    int 21h
    
                  
	xor CX, CX 
	mov AX, 0        
	mov BL, 5
	lea SI, dataArray

	; in this section we find the sumation
	calculateSum:
	    cmp Cx, 5
	    jge calculateAvg
	    mov AL, [SI] 
	    add [Sum], AX
	    inc CX
	    inc SI
	    jmp calculateSum   
	
	; in this section we find the avgerage    
	calculateAvg:  
	    mov AX, [sum]                           
        div BL
	    MOV AH,0
	    ;mov average,AL
	    mov average,AX
        
        display finalsummsg,sum,finalsummsghex ; to display the summation value
  
        display finalavgmsg,average,finalavgmsghex ; to display the average value
    
	    
	; in this section we find the minimum            
	mov SI, 0
	mov BX, dataArray[SI]
	mov bh,0
	add SI, 1  
	calculateMin:
	    mov AX, dataArray[SI]
	    mov ah,0
	    add SI, 1
	    cmp BX, AX
	    ja swapMin ;jump above
	    returnMin:
	    cmp SI, 5
	    jnz calculateMin
	    jz saveMin
	    
    swapMin:
        mov BX, AX
        jmp returnMin
    saveMin:
        mov min, BX
        
        display finalminmsg,min,finalminmsghex ; to display the minimum value
        
    
    ; in this section we find the maxmum
    mov SI, 0
	mov BX, dataArray[SI]
	mov bh,0
	add SI, 1  
	calculateMax:
	    mov AX, dataArray[SI]
	    mov ah,0
	    add SI, 1
	    cmp BX, AX
	    jb swapMax ;jump below
	    returnMax:
	    cmp SI, 5
	    jnz calculateMax
	    jz saveMax
	    
    swapMax:
        mov BX, AX
        jmp returnMax
    saveMax:
        mov max, BX
       
        display finalmaxmsg,max,finalmaxmsghex ; to display the maximum value  
       
        
    ; intrpt to exit        
    mov ax,4c00h 
    int 21h 


; This procedure will convert the hexadecimal value to ASCII
HEX_TO_DECIMAL PROC
    
    ;mov dl, 0ah
    ;int 21h
    
    CMP BX, 0  ; compare BX with 0
    JGE @START ; jump to label @START if BX>=0
    MOV AH, 2 ; set output function
    MOV DL, "-"  ; set DL='-'
    INT 21H      ; print the character
    
    NEG BX ; take 2's complement of BX
    
    @START:          ; jump label
        MOV AX, BX                
        XOR CX, CX                 
        MOV BX, 10                 
        
    @REPEAT:                      
        XOR DX, DX              
        DIV BX ; divide AX by BX
        PUSH DX     
        INC CX                     
        OR AX, AX ; take OR of AX with AX
        JNE @REPEAT ; jump to label @REPEAT if ZF=0
        MOV AH, 2                
    
    @DISPLAY:                    
        POP DX ; POP a value from STACK to DX
        OR DL, 30H ; convert decimal to ascii code
        INT 21H                    
        LOOP @DISPLAY ; jump to label @DISPLAY if CX!=0
    
        RET ; return control to the calling procedure

HEX_TO_DECIMAL ENDP 

;This procedure will let the user enter the values every value consist of two-digit and save it to an array
INPUT PROC
    push dx
    pop address
    JMP @read_input

    @Error:
        mov dx, 0
        mov ah, 09h
       
        mov cx, 60h ;number of char
        mov al, 20h
        mov bl, 0ch  ; color bh : page , bl : color -> light red
    
        int 10h
        lea DX, ERR
        int 21H


    @read_input:
        
        ;lds dx,address   
        ;lea DX,address ; load address of the massage
        
        mov dx,address ;loaded in dx
        MOV AH,09H 
        INT 21H
   
        MOV AH, 1 ; read a letter
        INT 21H
   
        MOV BL, AL ; save the letter in BL  
   
   
        CMP BL, "A" ; compare BL with "A"
        JB @DECIMAL_1 ; jump to label @DECIMAL_1 if BL<A

        CMP BL, "F" ; compare BL with "F"
        JA @Error ; jump to label @Error if BL>F
        ADD BL, 09H     
        JMP @SAVE            

    @DECIMAL_1:               
         CMP BL, 30H ; compare BL with 0
         JB @Error ; jump to label @START_1 if BL<0

         CMP BL, 39H ; compare BL with 9
         JA @Error ; jump to label Error if BL>9
             
   @SAVE:
       AND BL, 0FH ; convert the ascii into binary code
       MOV CL, 4  
       SHL BL, CL ; shift AL towards left by 4 positions
       MOV CX, 4  
       
       mov dataArray[si],bx
       
       ;XOR BX,BX
       ;XOR CX,CX
     
       ;MOV BL, AL ; save the letter in BL
       
       
       ;Second digit 
       MOV AH, 1
       INT 21H
        
       MOV BL, AL ; save the letter in BL  
       ;mov ah, 0
        
       CMP BL, "A"  ; compare BL with "A"
       JB @DECIMAL_2 ; jump to label @DECIMAL_1 if BL<A

       CMP BL, "F" ; compare BL with "F"
       JA @Error ; jump to label @Error if BL>F
       ADD BL, 09H
       JMP @SAVE2            

       
    @DECIMAL_2:               
         CMP BL, 30H ; compare BL with 0
         JB @Error ; jump to label @START_1 if BL<0

         CMP BL, 39H ; compare BL with 9
         JA @Error ; jump to label Error if BL>9
       
       
     @SAVE2:
         
         AND BL, 0FH ; convert the ascii into binary code
         ;mov bx,ax

          ;mov AX,num1
          mov AX,dataArray[si]
          add AX,BX
      
          MOV BL, AL ; save the hex digit into BL

        
          MOV dataArray[si],BX   ; set value to dataArray  
          inc si 
        
        ret
        
INPUT ENDP

;This procedure will Print the values of the the values that we want to calculate in hexadeximal form
PRINT_HEX PROC
    
     JNC @SKIP  ; jump to label @SKIP if CF=1
     MOV AH, 2  ; set output function
     MOV DL, 31H                  ; set DL=1
     INT 21H                      ; print a character

     @SKIP:
     MOV counter, 30H ; set COUNTER to zero
     @LOOP_3:                     
       XOR DL, DL                
       MOV CX, 4         
       @LOOP_4:
         SHL BX, 1 ; shift BX towards left by 1
         RCL DL, 1 ; rotate DL towards left by 1 position through carry
       LOOP @LOOP_4 ; jump to label @LOOP_4 if CX!=0
       MOV AH, 2

       CMP DL, 9
       JBE @NUMERIC_DIGIT ; jump to label @NUMERIC_DIGIT if DL<=9
       SUB DL, 9 ; convert it to number
       OR DL, 40H ; convert number to letter
       JMP @DISPLAY_VALUE              

       @NUMERIC_DIGIT:       
         OR DL, 30H ; convert decimal to ascii code

       @DISPLAY_VALUE:                  
         INT 21H ; print the character

       INC counter                
       CMP counter, 34H ; compare COUNT with 4
       JNE @LOOP_3 ; jump to label @LOOP_3 if COUNT!=4
    
    RET
PRINT_HEX ENDP
     
end begin                   