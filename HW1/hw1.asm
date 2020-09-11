
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data 
	dataArray DB 7, 3, 2, 8, 9
	sum dw ?
	average DB ?
	max Db ?
	min DB ?
	
	    
    avgmsg EQU 0DH,0AH,"The Average of the is $"
	finalavgmsg DB avgmsg
	
	maxmsg EQU 0DH,0AH,"The Max of the is $"
	finalmaxmsg DB maxmsg   
	
	minmsg EQU 0DH,0AH,"The Min of the is $"
	finalminmsg DB minmsg
	
.code 	
    mov AX, @data
	mov DS, AX            
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
	
	    
	    LEA DX, finalavgmsg             ; load and display avg
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        ; display the avg
        
        MOV dl, average
        ADD dl,30h
        INT 21H ;print avg       
         
        mov ah,2     
	    
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
        
        LEA DX, finalminmsg             ; load and display min
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        ; display the min
        
        MOV dl, min
        ADD dl,30h
        INT 21H ;print min       
         
        mov ah,2 
        
    
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
       
        LEA DX, finalmaxmsg             ; load and display PROMPT_2
        MOV AH, 9
        INT 21H       
        
        MOV AH, 2 ; set output function                
        ; display the max
        
        MOV dl, max
        ADD dl,30h
        INT 21H ;print max       
         
        mov ah,2 


MOV AH, 4CH                  ; return control to DOS
INT 21H

ret




