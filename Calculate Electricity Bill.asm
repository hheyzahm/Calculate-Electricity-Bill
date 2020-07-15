 .stack 100h
.data

m1 db "************************$"
m2 db "Calculate Electricity Bill$"
m3 db "************************$"
m4 db 13,10,"Press 1. To Calculate Electricity Bill$"
m5 db 13,10,"Press 2. To quit $" 
m6 db 13,10,"Enter your choice: $"
m7 db 13,10,"You have entered an Invalid choice...Please enter again $"
str db "=====================================$"
str1 db "    Calculating Electricity Bill $"
str2 db "====================================$" 
str3 db 13,10,"You have entered an invalid units press any key to calulate agian$"
str4 db 13,10,"Enter the Units To Calculate Electricity Bill : $"
str5 db 13,10,"Electricity Bill = $" 
units dw ?
bill dw ? 
calculated_bill  DB 10 DUP ('$')
DigitCount    db    ?
Result        db    ?
BadCharacter    db    "Invalid character$"
TooLarge    db    "Number too large$"
temp db 0
.code
main proc
mov ax,@data
mov ds,ax 

push ax              ;ax  12
push bx              ;bx  10
push cx              ;cx  8
push dx              ;dx  6
push si              ;si  4
push di              ;di  2
push bp              ;bp  0
mov bp,sp

call welcome_screen  ;calling welcome_screen procedure
call Calculate_Electricity_Bill       ;calling Calculate_Electricity_Bill procedure   
 call clear_screen
 call set_registers
 call welcome_screen   
 call Calculate_Electricity_Bill 
pop bp
pop di
pop si
pop dx
pop cx
pop bx
pop ax

call exit            ;calling exit procedure
endp
   
Calculate_Electricity_Bill proc
again1:
lea dx,m4  
mov ah,09h           
int 21h
lea dx,m5         ;Enter your choice:
int 21h              
lea dx,m6      
int 21h                           
mov ah,01h
int 21h
cmp al,31h           ;if al<1 && al>3 then goto label invalid
jnae invalid
cmp al,32h
jnbe invalid

 valid:
 cmp al,31h
 je calculate            ;if al==1 then goto calculate label
 cmp al,32h
 je quit             ;if al==2 then goto quit label
 
 calculate:
 call calculate_Bill    ;calling admin_login procedure
 jmp return1 
 


 quit:
 call exit           ;calling exit procedure
  
 invalid:  
 mov ah,09h
 lea dx,m7           ;You have entered an Invalid choice...Please enter again
 int 21h     
 mov ah,08h          ;character input without echo
 int 21h
 call clear_screen
 call set_registers
 call welcome_screen 
 jmp again1
 
return1:  
ret
endp                  ;ret admin_login  -4
                      ;ret main        -2
calculate_Bill proc 
 invalid_input_jump:
 call clear_screen
 call set_registers
 call calculate_bill_screen
 call set_registers
   ;jumping to next line 
    mov dl,0dh
    mov ah,02h
    int 21h
    
    mov dl,0ah
    mov ah,02h
    int 21h
                     
 lea dx,str4
 mov ah,09h 
 int 21h  
 
         xor    bx, bx            ;to hold interim result
    mov    cl, 10            ;we need to multiply interim result by 10
GetDigit:
    
    mov    ah, 1
    int    21h
    cmp    al, 13
    je    Done
    cmp    al, 30h
    jb    ShowDigitError
    cmp    al, 39h
    ja    ShowDigitError
    sub    al, 30h
    xor    ah, ah
    cmp    [DigitCount], 0
    jz    AddDigit
    push    ax
    mov    ax, bx
    mul    cl
    mov    bx, ax
    pop    ax
AddDigit:
    add    bx, ax
    inc    [DigitCount]
    jmp    GetDigit
ShowDigitError:
    lea    dx, BadCharacter
    mov    ah, 9
    int    21h
    ;xor    bx, bx            ;possibly reset interim number to start again
    jmp    short GetDigit
ShowTooLargeError:
    lea    dx, TooLarge
    mov    ah, 9
    int    21h
    ;xor    bx, bx            ;possibly reset interim number to start again
    jmp    short GetDigit
Done: 


cmp bx,0
je  DigitCount_error 
 
cmp [DigitCount],0
je DigitCount_error
    mov    [units], bx
  
    xor ax,ax
    
    mov ax,bx
    
    cmp [units],64h
    jbe hundred
    
    cmp [units],64h
    jg not_hundred
   
   hundred:
   mov bx,0
   mov bl,10
   
   mul bx
   
    mov [bill],ax
    xor cx,cx
    
   jmp display_bill 
   
   not_hundred:
   xor bx,bx
   cmp [units],0C8h
   jbe two
   cmp [units],12Ch
   jbe three
   cmp [units],12Ch
   jg four
   two:
   mov ax,[units]
   sub ax,64h
   mov [temp],al
   mov ax,64h
   xor cx,cx
   
   mov cx,bx
   
   mov bl,10
   mul bx
   
   mov [bill],ax
  
   xor ax,ax
   
   mov al,[temp]
   mov bl,15
   mul bx
   
   add [bill],ax
  jmp display_bill 
   three:
   mov ax,[units]
   sub ax,64h
   mov [temp],al
   mov ax,64h
   xor cx,cx
   
   mov cx,bx
   
   mov bl,10
   mul bx
   
   mov [bill],ax
  
   xor ax,ax
   
   mov al,[temp] 
   sub al,64h
   mov [temp],al
   mov al,64h
   mov bl,15
   mul bx
   
   add [bill],ax 
      xor ax,ax
   mov al,[temp] 
   
   mov bl,20
   mul bx
   
   add [bill],ax 
  jmp display_bill
   
   four: 
    mov ax,[units]
   sub ax,64h
   mov [temp],al
   mov ax,64h
   xor cx,cx
   
   mov cx,bx
   
   mov bl,10
   mul bx
   
   mov [bill],ax
  
   xor ax,ax
   
   mov al,[temp] 
   sub al,64h
   mov [temp],al
   mov al,64h
   mov bl,15
   mul bx
   
   add [bill],ax 
   xor ax,ax
   mov al,[temp] 
   sub al,64h
   mov [temp],al
   mov al,64h
   mov bl,20
   mul bx
   
   add [bill],ax
   
   xor ax,ax
   mov al,[temp] 
   
   mov bl,25
   mul bx
   
   add [bill],ax 
   
   
  display_bill: 
  
     ;jumping to next line 
    mov dl,0dh
    mov ah,02h
    int 21h
    
    mov dl,0ah
    mov ah,02h
    int 21h
    
  lea dx,str5
  mov ah,09h    
    int 21h 
   mov ax,[bill]    
   LEA SI,calculated_bill
   CALL HEX2DEC 

 LEA DX,calculated_bill
    MOV AH,9
    INT 21H 
    
   jmp here
 DigitCount_error:
   
     ;jumping to next line 
    mov dl,0dh
    mov ah,02h
    int 21h
    
    mov dl,0ah
    mov ah,02h
    int 21h
     
  lea dx,str3
  mov ah,09h    
    int 21h  
   
     ;jumping to next line 
    mov dl,0dh
    mov ah,02h
    int 21h
    
    mov dl,0ah
    mov ah,02h
    int 21h
    
    mov ah,01h 
    int 21h 
    jmp invalid_input_jump
  Here:   
     ;jumping to next line 
    mov dl,0dh
    mov ah,02h
    int 21h
    
    mov dl,0ah
    mov ah,02h
    int 21h
    
    mov ah,01h 
    int 21h   
ret 
endp 
HEX2DEC PROC 
    MOV CX,0
    MOV BX,10
  
LOOP1: MOV DX,0
       DIV BX
       ADD DL,30H
       PUSH DX
       INC CX
       CMP AX,9
       JG LOOP1
     
       ADD AL,30H
       MOV [SI],AL
     
LOOP2: POP AX
       INC SI
       MOV [SI],AL
       LOOP LOOP2  
       
       
       RET
HEX2DEC ENDP     

    
calculate_bill_screen proc
   mov dh,1      ;dh->row=1
mov dl,29     ;dl->col=29
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,str
mov ah,09h    ;========================
int 21h 

mov dh,2      
mov dl,29     
mov ah,2
int 10h

lea dx,str1
mov ah,09h 
int 21h  

mov dh,3
mov dl,29
mov ah,2
int 10h

lea dx,str2
mov ah,09h    ;=========================
int 21h  
ret 
endp
welcome_screen proc  
mov dh,1      ;dh->row=1
mov dl,29     ;dl->col=29
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,m1
mov ah,09h    ;========================
int 21h 

mov dh,2      
mov dl,29     
mov ah,2
int 10h

lea dx,m2
mov ah,09h 
int 21h  

mov dh,3
mov dl,29
mov ah,2
int 10h

lea dx,m3
mov ah,09h    ;=========================
int 21h 

ret    
welcome_screen endp
clear_screen proc
mov ax,0600h  ;ah=6 scroll up function, al=no of lines to scroll (0 = whole screen)
mov cx,0      ;ch=upper left corner row, cl=upper left corner column 
mov dx,8025   ;dh=lower right corner row, dl=lower right corner column
mov bh,7      ;normal video attribute
int 10h       ;BIOS interrupt
;it clear full screen but cause some problem
;mov ax,3
;mov cx,0
;mov dx,8025
;mov bh,7
;int 10h

ret
clear_screen endp     
set_registers proc
mov ax,[bp+12]        
mov bx,[bp+10]        
mov cx,[bp+8]
mov dx,[bp+6] 
mov si,[bp+4]
mov di,[bp+2] 
ret
set_registers endp 

exit proc
mov ah,4ch
int 21h        
ret
exit endp

end main