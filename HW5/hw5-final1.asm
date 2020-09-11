; Student name: Ameen Haj-Yasin
; Student Number: 1162618

org 100h
.model small 
.stack 


.DATA 
    message db  0DH,"Enter Two digit decimal number (00-99) : $"
    ERR db  0DH,0AH,"USAGE: Wrong Value! $"
    address dw "$"
    input_value db 0
    number DB 0
    array DB dub(0)
    
    text db "The diviosr of the $"
    dumb db "$"
    ;pointer dw 0
    NUM DB 0
    count DB 0
    

    result DB "The diviosr of the $"

	continue DB " are  :  "
	dumb2 db "$"
	comma DB ", $"
	newLine DB 0DH,0AH,"$"
	
	FileName DB "divisor.txt",0
	Handle DW ? ; to store file handle	
	
.code 
begin:

DISPLAY MACRO MSG
    ;display the result
    lea dx,MSG ; load address of the massage
    mov ah,9 ;loaded in dx
    int 21h
ENDM

write_to_file MACRO msg , number
            mov dx,offset msg ; address of information to write 
            mov bx,Handle ; file handle for file 
            ;mov ch,0
            mov cx,number ; bytes to be written 
            mov ah,40h ; function 40h - write to file 
            int 21h ; call dos service 
ENDM

    mov ax,@data ; initialize DS
    mov ds,ax
    
;       mov pointer,19
    mov cl,19 ;length of string1 in cl
	mov si,offset text
    next:
        inc si
	    dec cl
	jnz next
	 	    
    
    ;create file
    mov dx,offset FileName ; put offset of filename in dx 
    xor cx,cx ; clear cx - make ordinary file 
    mov ah,3Ch ; function 3Ch - create a file 
    int 21h ; call DOS service 
    
    ;open file
    mov dx,offset FileName ; put offset of filename in dx 
    mov al,2 ; access mode -read and write 
    mov ah,3Dh ; function 3Dh - open the file 
    int 21h ; call dos service 
    mov Handle,ax ; save value of handle 
    
  
    xor ax,ax
    xor dx,dx
    xor cx,cx
    
    lea dx, message
    call INPUT

    mov ah,2
    mov dl,0DH
    int 21h

    mov dl, 0ah
    int 21h

    display result 
    mov dx,0
    
   
    mov bl,number
    call HEX_TO_DECIMAL1
    
;       add pointer,10
       mov di,offset continue
       mov cl,10
    move_next:  
	       mov al,[di]
	       mov [si],al
		   inc si
		   inc di
		   dec cl
    jnz move_next
		  
    
    write_to_file text , 28
    
    display continue

        
    mov ah,0
    mov al,number
   
        
    mov BP,si
    mov si,0
         
    mov bl,al
    
    for:
        mov ah,0
        mov al,number
        xor dx,dx
        aad
        div bx
    
        cmp dl , 00
        je save
        jmp @next
    
     save:
         mov array[si],bl
         inc si
    
     @next:
        dec bl
        jne for
    
     dec si
    
     @print:
         xor dx,dx   
         MOV AH, 2  ; set output function
         mov dl,array[si]
        ;ADD dl,30h
     
        CMP DL, 9
        JBE @NUMERIC_DIGIT ; jump to label @NUMERIC_DIGIT if DL<=9
 
 
        MOV BL,DL
        
        call HEX_TO_DECIMAL
        jmp @PRINTF
                  

      @NUMERIC_DIGIT:       
              OR DL, 30H ; convert decimal to ascii code                
              INT 21H ; print the character
              MOV NUM,DL
              write_to_file NUM , 1

      @PRINTF:
            ;display the result
            CMP SI,0000
            JZ @FINALE
            mov dx,0
            display comma
            write_to_file comma , 2
                   
       @FINALE:
       dec si
     jge @print
     
     ;close the file
     mov ah,3eh
     mov bx,handle
     int 21h
            
    ; intrpt to exit        
    mov ax,4c00h 
    int 21h 


;This procedure will let the user enter the values every value consist of two-digit in decimal form and save it to varible
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
        
        
        mov ah,2
        mov dl,0AH
        int 21h
        

    @read_input:
         
                
        mov dx,address ;loaded in dx
        MOV AH,09H 
        INT 21H
        
         
        mov dl,10
        mov bl,0
        
        
        MOV AH, 1 ; read a letter
        INT 21H
    
             

    @DECIMAL_1:               
         CMP AL, 30H 
         JL @Error ; jump to label @START_1 if AL<0

         CMP AL, 39H
         JG @Error ; jump to label Error if AL>9
             
   @SAVE:
        mov ah, 0  
        sub al, 48   ; ASCII to DECIMAL
    
    
        mov cl, al
        mov bl,cl
        mov al, bl   ; Store the previous value in AL
        mul dl
        mov bl, al 
    
        ;Second digit
        mov ah, 1
        int 21h
        
        
    @DECIMAL_2:               
         CMP AL, 30H
         JL @Error ; jump to label @START_1 if AL<0

         CMP AL, 39H 
         JG @Error ; jump to label Error if AL>9
       
     @SAVE2:
        mov ah, 0  
        sub al, 48   ; ASCII to DECIMAL
        
        mov cl, al
        mov al, cl   ; Store the previous value in AL
      
        add al, bl   ; previous value + new value ( after previous value is multiplyed with 10 )
        mov bl, al   ; Largest number is 99 so it fits in BL  
      
          
        ;sub al,30h
        mov number,al  ; set value to number

        ret
        
INPUT ENDP



; This procedure will convert the hexadecimal value to ASCII and write the value to the file 
HEX_TO_DECIMAL PROC
    CMP BX, 0  ; compare BX with 0
    JGE @START ; jump to label @START if BX>=0
    
    NEG BX ; take 2's complement of BX
    
    @START:      
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
        MOV NUM,DL
        mov count,cl         
        WRITE_TO_FILE NUM,1
        MOV AH,2
        mov cl,count
            
    LOOP @DISPLAY ; jump to label @DISPLAY if CX!=0
    
        RET ; return control to the calling procedure

HEX_TO_DECIMAL ENDP

; This procedure will convert the hexadecimal value to ASCII and append value to string
HEX_TO_DECIMAL1 PROC

    CMP BX, 0  ; compare BX with 0
    JGE @START1 ; jump to label @START if BX>=0   
    NEG BX ; take 2's complement of BX
    
    @START1:          ; jump label
        MOV AX, BX                
        XOR CX, CX                 
        MOV BX, 10                 
        
    @REPEAT1:                      
        XOR DX, DX              
        DIV BX ; divide AX by BX
        PUSH DX     
        INC CX                     
        OR AX, AX ; take OR of AX with AX
        JNE @REPEAT1 ; jump to label @REPEAT if ZF=0
        MOV AH, 2                
    
    @DISPLAY1:                    
        POP DX ; POP a value from STACK to DX      
        OR DL, 30H ; convert decimal to ascii code
        INT 21H              
        mov [SI],dl
        inc SI
;	    inc pointer 
        
    LOOP @DISPLAY1 ; jump to label @DISPLAY if CX!=0
    
        RET ; return control to the calling procedure

HEX_TO_DECIMAL1 ENDP

     
end begin