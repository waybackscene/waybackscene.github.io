.486
.Model Flat ,StdCall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
include \masm32\include\comdlg32.inc
includelib \masm32\lib\comdlg32.lib


.data
file            byte    "virus.exe", 0
DUMP            byte    "dump.exe", 0
fhandle         dword   ?                ; handle of file
fsize           dword   ?                ; filesize
memptr          dword   ?                ; Handle of file :) yes, twice !! it is just a mistake  
PE_HEADER       dword   ?                ; Offset of PE header
ENTRY_POINT     dword   ?                ; Offset of Entry Point in the loader
bread           dword   ?                ; number of read bytes

.code
Main:
; *************************************************************************Ouverture du fichier
        pushad
        push 0                      
        push FILE_ATTRIBUTE_NORMAL  
        push OPEN_EXISTING          
        push 0                      
        push 0                      
        push GENERIC_READ + GENERIC_WRITE   
        push offset file            
        Call CreateFileA                        ; Open File
        mov  fhandle,eax            
; ****************************************** Récupère le contenu du fichier dans une GlobalAlloc
        push 0
        push fhandle                            ; PUSH filehandle
        Call GetFileSize                        ; Get filesize
 
        mov  fsize,eax                          ; save filesize
        push fsize                              ; PUSH filesize=size of buffer
        push 0                                  ; 0=GMEM_FIXED 
        Call GlobalAlloc                        ; allocate memory          
        mov  memptr,eax                         ; save handle

        push 0                                  
        push offset bread                       
        push fsize                               
        push memptr                             
        push fhandle                            ; filehandle
        Call ReadFile                           ; Read file

; ****************************************************************** Récupère l'Entry-Point du loader
        mov  edi,memptr                          
        mov  edx,edi
        mov  esi,[edi+03ch]                     ; Récupère l'offset du PE Header
        add  edx,esi                            ; edx contient l'adresse du début du PE
        mov  PE_HEADER,edx

        mov eax, 3010h
        call RVA2OFFSET
        mov ENTRY_POINT, eax

; ****************************************************************** LAYERS DE DECRYPTAGE

        mov ebp, 2000h




; ======================================== LAYER 1 

           lea     edi, 1042h[ebp]
           mov eax, edi
           call RVA2OFFSET
           mov edi, eax
           lea     ecx, 1073h[ebp]               
           mov eax, ecx
           call RVA2OFFSET
           mov ecx, eax
           sub     ecx, edi
 

loc_40303A:                             ; CODE XREF: ZeGun0:00403040#j
                add     [edi], cl
                xor     byte ptr [edi], 0D2h
                inc     edi
                loop    loc_40303A


; ======================================= LAYER 2

                lea     ecx, 10B9h[ebp]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                lea     eax, 1089h[ebp]
                call RVA2OFFSET
                
                sub     ecx, eax

loc_403050:                             ; CODE XREF: start+58j
                neg     byte ptr [eax]
                push    eax
                add     byte ptr [eax], 33h
                sub     byte ptr [eax], 81h
                pop     eax
                sub     byte ptr [eax], 0C3h
                push    ecx
                neg     byte ptr [eax]
                ror     byte ptr [eax], 2
                xor     [eax], cl
                pop     ecx
                inc     eax
                dec     ecx
                jnz     short loc_403050

; ======================================= LAYER 3


                lea     ebx, 1073h[ebp]
                mov eax, ebx
                call RVA2OFFSET
                mov ebx, eax
                lea     ecx, 1089h[ebp]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                sub     ecx, ebx

loc_403097:                             ; CODE XREF: ZeGun0:004030B5j
                sub     byte ptr [ebx], 45h
                ror     byte ptr [ebx], 5
                xor     byte ptr [ebx], 56h
                sub     [ebx], cl
                add     byte ptr [ebx], 78h
                add     byte ptr [ebx], 0B2h
                add     byte ptr [ebx], 68h
                not     byte ptr [ebx]
                xor     [ebx], cl
                rol     byte ptr [ebx], 4
                sub     [ebx], cl
                inc     ebx
                loop    loc_403097

; ======================================= LAYER 4

                lea     edi, [ebp+1104h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                lea     ecx, [ebp+1196h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                sub     ecx, edi

loc_403082:                             ; CODE XREF: ZeGun0:00403086j
                add     [edi], cl
                inc     edi
                dec     ecx
                jnz     short loc_403082

; ======================================= LAYER 5


                mov     edi, ebp
                add     edi, 10B9h
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                lea     esi, [ebp+10E8h]
                mov eax, esi
                call RVA2OFFSET
                mov esi, eax
                
                sub     esi, edi
                mov     ecx, esi

loc_403117:                             ; CODE XREF: ZeGun0:0040312Cj
                mov     bl, [edi]
                xor     bl, 45h
                mov     al, bl
                mov     [edi], al
                lea     edi, [edi+1]
                lea     ecx, [ecx-1]
                xor     ebx, ebx
                mov     edx, ecx
                sub     edx, ebx
                jnz     short loc_403117

; ======================================= LAYER 6


                lea     ebx, [ebp+1393h]
                mov eax, ebx
                call RVA2OFFSET
                mov ebx, eax
                
                lea     ecx, [ebp+16F4h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                
                sub     ecx, ebx

loc_40313C:                             ; CODE XREF: ZeGun0:00403141j
                xor     [ebx], cl
                not     byte ptr [ebx]
                inc     ebx
                loop    loc_40313C


; ======================================= LAYER 7


                lea     edi, [ebp+10E8h]

                mov eax, edi
                call RVA2OFFSET
                mov edi, eax

                lea     ecx, [ebp+1104h]

                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax

                sub     ecx, edi

loc_4030C7:                             ; CODE XREF: ZeGun0:004030E4j
                mov     dl, [edi]
                mov     al, 77h
                dec     al
                dec     al
                sub     dl, al
                mov     al, dl
                mov     [edi], al
                lea     edi, [edi+1]
                lea     ecx, [ecx-2]
                inc     ecx
                mov     edx, ecx
                xor     eax, eax
                xor     ebx, ebx
                sub     edx, eax
                jnz     short loc_4030C7

; ======================================= LAYER 8

                lea     edi, [ebp+1196h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+1212h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                
                sub     ecx, edi

loc_4030F6:                             ; CODE XREF: ZeGun0:004030FAj
                add     byte ptr [edi], 33h
                inc     edi
                loop    loc_4030F6

; ======================================= LAYER 9


                lea     edi, [ebp+1212h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+122Ah]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax

                sub     ecx, edi

loc_4031A4:                             ; CODE XREF: ZeGun0:004031A8j
                xor     byte ptr [edi], 79h
                inc     edi
                loop    loc_4031A4


; ======================================= LAYER 10


                lea     edi, [ebp+122Ah]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
               
                
                lea     ecx, [ebp+1240h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
               
                sub     ecx, edi        ; CODE XREF: ZeGun0:004031C9j

loc_403220:                             ; CODE XREF: ZeGun0:00403226j
                xor     byte ptr [edi], 0C6h
                add     [edi], cl
                inc     edi
                loop    loc_403220

; ======================================= LAYER 11

                lea     edi, [ebp+1240h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+125Bh] ; CODE XREF: ZeGun0:004031CEj
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
               
                sub     ecx, edi

loc_403238:                             ; CODE XREF: ZeGun0:0040323Cj
                xor     byte ptr [edi], 2Bh
                inc     edi
                loop    loc_403238

; ======================================= LAYER 12


                lea     edi, [ebp+125Bh] ; CODE XREF: ZeGun0:004031CCj
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+1271h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
                
                sub     ecx, edi

loc_40324E:                             ; CODE XREF: ZeGun0:00403251j
                xor     [edi], cl
                inc     edi
                loop    loc_40324E


; ======================================= LAYER 13


                lea     edi, [ebp+1271h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+128Dh]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
               
                sub     ecx, edi

loc_403269:                             ; CODE XREF: ZeGun0:0040326Dj
                xor     byte ptr [edi], 0A2h
                inc     edi
                loop    loc_403269


; ======================================= LAYER 14


                lea     edi, [ebp+128Dh]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax


                lea     ecx, [ebp+12A3h]

                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax

                sub     ecx, edi

loc_40327F:                             ; CODE XREF: ZeGun0:00403283j
                sub     byte ptr [edi], 45h
                inc     edi
                loop    loc_40327F

; ======================================= LAYER 15


                lea     edi, [ebp+12A3h]
                mov eax, edi
                call RVA2OFFSET
                mov edi, eax
                
                lea     ecx, [ebp+1393h]
                mov eax, ecx
                call RVA2OFFSET
                mov ecx, eax
               
                sub     ecx, edi

loc_40329B:                             ; CODE XREF: ZeGun0:0040329Fj
                add     byte ptr [edi], 0D6h
                inc     edi
                loop    loc_40329B




;*********************************************************************  Save exe decrypted and unpacked

Sauvegarde_exe_decrypte_unpacke:

    PUSH 0
    PUSH 80h
    PUSH 2
    PUSH 0
    PUSH 0
    PUSH 40000000h
    PUSH Offset DUMP                            ; "dump.exe"
    CALL CreateFileA


    push eax
    push 0
    push Offset bread
    push fsize       
    push memptr
    push eax
    Call WriteFile
    Call CloseHandle


    PUSH memptr                ; pointeur vers la zone mémoire
    CALL GlobalFree            ; Libère la mémoire


    popad
    CALL    ExitProcess        ;Quitter le programme


    
;===================================================================
;  Conversion RVA-->OFFSET in memptr
;  Parameter : EAX = RVA to convert 
;===================================================================
RVA2OFFSET PROC
    PUSH EDX
    PUSH EDI
    PUSH EBX
    PUSH ESI
    PUSH ECX
    XOR ECX, ECX
    MOV CL, 6			; number of sections in the file.
    MOV EDX, PE_HEADER
    ADD EDX, 0F8h
    MOV EDI, [EDX + 0Ch]
    MOV ESI, EDX
Cherche_rva_section:
    MOV EBX, [EDX + 0Ch]
    CMP EBX, EAX
    JNC Calcul_offset
    MOV EDI, EBX
    MOV ESI, EDX
    ADD EDX, 28h
    LOOPD Cherche_rva_section
Calcul_offset:
    JNZ pas_zero
    SUB EAX, EAX
    ADD EAX, [EDX + 14h]
    JMP suite
pas_zero:
    SUB EAX, EDI
    ADD EAX, [ESI + 14h]
suite: 
    ADD EAX, memptr
    POP ECX
    POP ESI
    POP EBX
    POP EDI
    POP EDX
    RET        

RVA2OFFSET ENDP

End Main