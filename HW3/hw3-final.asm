
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


; Student name: Ameen Haj-Yasin
; Student Number: 1162618

org 100h
.model small 
.stack
 
.DATA 
  message db "Enter the first number : $",13,10
  message1 db "Enter the second number : $",13,10
  message2 db "Enter the third number : $",13,10
  message3 db "Enter the forth number : $",13,10
  message4 db "Enter the fifth number : $",13,10
  

    dataArray DB 0, 0, 0, 0, 0
    sum dw ?
    average DB ?
    max Db ?
    min DB ? 

    summsg EQU 0DH,0AH,"The Sum of the Values is $"
	finalsummsg DB summsg
	
    avgmsg EQU 0DH,0AH,"The Average of the Values is $"
	finalavgmsg DB avgmsg
	
	maxmsg EQU 0DH,0AH,"The Max of the Values is $"
	finalmaxmsg DB maxmsg   
	
	minmsg EQU 0DH,0AH,"The Min of the Values is $"
	finalminmsg DB minmsg	
	
.code 
begin:
    
    ; This macro will display the desired message after that we call <HEX_TO_DECIMAL) Procedure to display the given value  	    
    ; varible :
    ;           msg : the message that we want to display on the screen to the user
    ;           var : is the numeric variable that we want to display
    ; return nth
    
    display MACRO msg,var  
	    LEA DX, msg ; load and display msg
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        
        
        MOV dx, 0
        MOV bx, 0
        MOV bl,var
        MOV dl,var
        
        call HEX_TO_DECIMAL
        
    ENDM
    
    
    mov ax,@data ; initialize DS
    mov ds,ax
    
    xor ax,ax
    xor dx,dx 
    mov si,0 


    
    
    ; display msg one
    lea dx,message ; load address of the massage
    mov ah,9 ;loaded in dx
    int 21h
     
    
    call INPUT


    mov ah,2
    mov dl,0DH
    int 21h

    mov dl, 0ah
    int 21h
    
    ;msg two
    mov ah,9 
    lea dx,message1 
    int 21h 
    
    call INPUT

    mov ah,2
    mov dl,0dh
    int 21h

    mov dl, 0ah
    int 21h
    
    
    
    ;msg three
    mov ah,9 
    lea dx,message2 
    int 21h 
    
    call INPUT

    mov ah,2
    mov dl,0dh
    int 21h

    mov dl, 0ah
    int 21h
    
    ;msg four
    mov ah,9 
    lea dx,message3 
    int 21h
    
    call INPUT
    

    mov ah,2
    mov dl,0dh
    int 21h

    mov dl, 0ah
    int 21h
    
    ;msg five
    mov ah,9 
    lea dx,message4 
    int 21h 
    
    call INPUT
    
   

    mov ah,2
    mov dl,0dh
    int 21h

    mov dl,0ah 
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
	    mov average,AL
	
        
        LEA DX, finalsummsg ; load and display sum msg
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        
        
        MOV dx, 0
        MOV bx, 0
        MOV bx,sum
        MOV dx,sum
        
        call HEX_TO_DECIMAL
  
        display finalavgmsg,average ; to display the average value
    
	    
	; in this section we find the minimum            
	mov SI, 0
	mov BL, dataArray[SI]
	add SI, 1  
	calculateMin:
	    mov AL, dataArray[SI]
	    add SI, 1
	    cmp BL, AL
	    ja swapMin ;jump above
	    returnMin:
	    cmp SI, 5
	    jnz calculateMin
	    jz saveMin
	    
    swapMin:
        mov BL, AL
        jmp returnMin
    saveMin:
        mov min, BL
        
        display finalminmsg,min ; to display the minimum value
        
    
    ; in this section we find the maxmum
    mov SI, 0
	mov BL, dataArray[SI]
	add SI, 1  
	calculateMax:
	    mov AL, dataArray[SI]
	    add SI, 1
	    cmp BL, AL
	    jb swapMax ;jump below
	    returnMax:
	    cmp SI, 5
	    jnz calculateMax
	    jz saveMax
	    
    swapMax:
        mov BL, AL
        jmp returnMax
    saveMax:
        mov max, BL
       
        display finalmaxmsg,max ; to display the maximum value  
       
        
    ; intrpt to exit        
    mov ax,4c00h 
    int 21h 


; This procedure will convert the hexadecimal value to ASCII
HEX_TO_DECIMAL PROC
    
    CMP BX, 0                      ; compare BX with 0
    JGE @START                     ; jump to label @START if BX>=0
    MOV AH, 2                      ; set output function
    MOV DL, "-"                    ; set DL='-'
    INT 21H                        ; print the character
    
    NEG BX                         ; take 2's complement of BX
    
    @START:                        ; jump label
        MOV AX, BX                 ; set AX=BX
        XOR CX, CX                 ; clear CX
        MOV BX, 10                 ; set BX=10
        
    @REPEAT:                       ; LOOP label
        XOR DX, DX                 ; clear DX
        DIV BX                     ; divide AX by BX
        PUSH DX                    ; PUSH DX onto the STACK
        INC CX                     ; increment CX
        OR AX, AX                  ; take OR of AX with AX
        JNE @REPEAT                ; jump to label @REPEAT if ZF=0
        MOV AH, 2                  ; set output function
    
    @DISPLAY:                      ; LOOP label
        POP DX                     ; POP a value from STACK to DX
        OR DL, 30H                 ; convert decimal to ascii code
        INT 21H                    ; print a character
        LOOP @DISPLAY              ; jump to label @DISPLAY if CX!=0
    
        RET                        ; return control to the calling procedure

HEX_TO_DECIMAL ENDP 

;This procedure will let the user enter the values every value consist of two-digit and save it to an array
INPUT PROC
        mov dl,10
        mov bl,0
        mov ah,01 
        ;lea dx,message 
        ;mov dx, offset message2
        int 21h
         
        mov ah, 0  
        sub al, 48   ; ASCII to DECIMAL
    
    
        mov cl, al
        mov al, bl   ; Store the previous value in AL

       
        mul dl       ; multiply the previous value with 10
        add al, cl   ; previous value + new value ( after previous value is multiplyed with 10 )
        mov bl, al 
    
    
        mov ah, 1
        int 21h

        mov ah, 0  
        ;sub al, 48   ; ASCII to DECIMAL
      
        mov cl, al
        mov al, bl   ; Store the previous value in AL
      
        mul dl       ; multiply the previous value with 10

        add al, cl   ; previous value + new value ( after previous value is multiplyed with 10 )
        mov bl, al   ; Largest number is 99 so it fits in BL  
      
          
        sub al,30h
        mov dataArray[si],al  ; set value to dataArray
        inc si
      RET
INPUT ENDP
     
end begin
