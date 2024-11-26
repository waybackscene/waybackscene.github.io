; Décrypteur pour PeSpin 0.3 par BeatriX
; unPESpin 0.3 Release 1
; lundi 15 novembre 2004 - 11 h 32
; 
; Merci à Cyberbob pour avoir codé PESpin 0.3 - je me suis vraiment beaucoup amusé dessus :)
; Merci à : Kaine - Cyber DAEMON - R!sc - Gbillou - Thierry The One
; pour leur soutien, leurs conseils, leur intérêt porté sur ce projet et leurs aides techniques .
; 
; Cette version ne prend pas en compte l'option " protection par mot de passe " 
; 
; 

.386P
.Model Flat ,StdCall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
include \masm32\include\comdlg32.inc
includelib \masm32\lib\comdlg32.lib

mb_ok                   equ 0
hWnd                    equ 0
FILE_ATTRIBUTE_NORMAL   equ 080h
OPEN_EXISTING           equ 3
GENERIC_READ            equ 80000000h
GENERIC_WRITE           equ 40000000h


.Data
ofn_struct              dd  04ch,0,0,ofn_filter,0,0,0           ; Structure pour ouverture de fichier
                        dd  file
                        dw  0200h,0
                        dd  0,0,0,caption,01000h,0,0,0,0,0

ofn_filter              db  'PeSpiné exe, dll or ocx',0,'*.exe;*.dll;*.ocx',0,0

caption                 db "UnPeSpin 0.3 par BeatriX",0
err_cap                 db "Flûte, zut, crotte !",0                                  ; Titre pour Message d'erreur
openerr                 db "Je n'arrive pas à ouvrir ce fichier :(",13,10,0          ; Texte pour erreur d'ouverture
memerr                  db "Je n'arrive pas à allouer de mémoire :(",0               ; Texte pour erreur d'allocation
wrong                   db 10,13,"Ce fichier n'est pas protégé par PeSpin 0.3 !",0

decrypte                db " Décryptage et décompression accomplis ",0
NOM_FICHIER             db "dump.exe",0

; ****************** paramètres du fichier ******************************

file                    db  200h dup (?)

fhandle                 dd  ?                ; variable pour le handle du fichier
fsize                   dd  ?                ; variable pour le filesize

bread                   dd  ?                ; nombre d'octets lus
sections                db  ?                ; nombre de sections dans le fichier


; ******************* paramètres de la première zone mémoire ******************************


memptr                  dd  ?                ; Offset de l'exe en mémoire 
PE_HEADER               dd  ?                ; Offset du PE header
ENTRY_POINT             dd  ?                ; Offset de l'Entry Point dans le loader
OFFSET_LOADER           dd ?                 ; Offset de la section contenant le loader
CRC32                   dd  ?                ; CRC32 qui sert au deuxième décryptage
RVA_RESSOURCES          dd ?                 ; RVA des ressources
TAILLE_LOADER           dd ?                 ; Taille du loader
TAILLE_RESSOURCES       dd ?                 ; Taille des ressources
TAILLE_SECTION          dd ?                 ; Paramètre pour la décompression
OFFSET_RESSOURCES       dd ?                 ; Offset de la section contenant les ressources
ENTETE_SECTION          dd ?                 ; Paramètre qui contient la position du nom de la section en cours


; ******************** paramètres de la seconde zone mémoire *******************************

memptr_2                dd  ?
PE_HEADER_2             dd  ?                ; Offset du PE header
SECTIONS_UNPACK         dd  ?                ; Raw Offset de la première section
TAILLE_memptr_2         dd ?                 ; Taille de la seconde zone mémoire (nouvelle taille de l'exe)
OFFSET_RESSOURCES_2     dd ?
OFFSET_LOADER_2         dd ?
POSITION                dd ?
OFFSET_TRAMPOLINE       dd ?
FILESIZE_2              dd ?

; ******************* paramètres de la troisième zone mémoire pour le CRC32 ************************

memptr_3                dd ?
CRC32_                  dd ?
OFFSET_CRC32            dd ?


; ******************* paramètres pour les DLLs ************************
 
PE_HEADER_DLL           dd ?
RVA_EXPORTS             dd ?
TABLE_RVAs              dd ?
IMAGE_BASE_DLL          dd ?
NBRE_APIS               dd ?
PADDING                 dd ?


.Code
Main:

        PUSHAD
        push offset ofn_struct
        call GetOpenFileNameA

        push 0                      
        push FILE_ATTRIBUTE_NORMAL  
        push OPEN_EXISTING          
        push 0                      
        push 0                      
        push GENERIC_READ + GENERIC_WRITE   
        push offset file            
        Call CreateFileA                    ; Ouvrir le fichier 
        mov  fhandle,eax            
        cmp  eax,0FFFFFFFFh                 ; Si eax=FFFFFFFF alors 
                                            ; erreur
        jnz  file_is_here

        push 0
        push offset openerr
        push offset err_cap
        push 0
        call MessageBoxA
        jmp  end_                   ; Sortie

file_is_here:                                   

        push 0
        push fhandle                            ; PUSH filehandle
        Call GetFileSize                        ; récupère la filesize
        mov  fsize,eax                          ; sauve la filesize

        push fsize                              ; PUSH filesize=size du buffer
        push 0                                  ; 0=GMEM_FIXED 
        Call GlobalAlloc                        ; alloue autant de mémoire que la taille du fichier 
        mov  memptr,eax                         ; sauve offset de la zone mémoire

        cmp  eax,0                              ; Si eax=0, alors erreur
        jnz  mem_ok

        push 0
        push offset memerr
        push offset err_cap
        push 0
        call MessageBoxA
        jmp  end_kill_handle                    

mem_ok:                                         

        push 0                                  
        push offset bread                       ; pointeur vers le nombre de bytes lus
        push fsize                              ; Lire combien d'octets ? 
        push memptr                             ; sauver où ? -> dans la zone allouée
        push fhandle                            ; filehandle
        Call ReadFile                           ; lire le fichier

        mov  edi,memptr                          
      
        mov  edx,edi
        mov  esi,[edi+03ch]                     ; Récupère l'offset du PE Header
        add  edx,esi                            ; edx contient l'adresse du début du PE
        push edx
        mov  PE_HEADER,edx
        mov  edx,[edx]
        cmp  edx,'EP'                           ; Test s'il s'agit d'un format PE
        jnz  end_kill_all                       ; Non?  alors on s'en va :)

;===================================================================
; Alloue une zone mémoire pour le CRC32 et copie l'exe
;===================================================================


        PUSH EDX
        PUSH ESI
        PUSH EDI
        PUSH ECX

        MOV EDX, PE_HEADER
        MOV EDX, [EDX + 50h]    ; SIZE_OF_IMAGE  
        PUSH 4h                 ; type of access protection
        PUSH 3000h              ; type of allocation
        PUSH EDX                ; size of region 
        PUSH 0                  ; address of region to reserve or commit
        CALL VirtualAlloc
        MOV memptr_3,EAX        ; Récupère l'offset de cette nouvelle zone mémoire 


        MOV ECX, fsize
        MOV ESI, memptr
        MOV EDI, memptr_3
        REP MOVSB

        POP ECX
        POP EDI
        POP ESI
        POP EDX

;===================================================================
; RECHERCHE DE L'ENTRY POINT EN SCANNANT LE SECTION HEADER
;===================================================================

        pop  edx
 
        mov  dl,byte ptr [edx+06h]              ; Récupère le nombre de Sections
        mov  byte ptr [sections],dl             
                                                
  
        xor  ecx,ecx                            ; ecx = 0
        mov  cl,byte ptr [sections]             ; Récupère le nombre de sections
        sub  cl,01                              ; Retranche 1  
        mov  edx,edi                            ; put target offset into edx
        add  edx,esi
        add  edx,0F8h


get_sections_name:                               
        add  edx,28h                             
        loop get_sections_name                  

        mov ebx, [edx+10h]
        mov TAILLE_LOADER, ebx
        mov ebx,[edx+14h]                     

        mov edi,memptr
        add edi,ebx
        mov OFFSET_LOADER, edi
        add edi, 87h                            ; EDI = Entry Point (Raw Offset)
        Mov ENTRY_POINT, edi


;===================================================================
;  1er layer de décryptage du loader 102023F --> 1020CB3
;===================================================================


        MOV EBX,ENTRY_POINT
        MOV EBX, [EBX + 90h] ; <--------- 5Fh
        MOV ECX,0A75h
        MOV EDI, ENTRY_POINT
        ADD EDI, 11B8h ; ......EDI = 102023F <----- EP + 11B8h
        DEC EDI
        
calc_san0101F127:
        XOR BYTE PTR DS:[ECX+EDI],BL
        DEC BL
        LOOPD SHORT calc_san0101F127
        
;===================================================================
;  2ème layer de décryptage du loader 1020B77 --> 1020CB3
;===================================================================


        PUSH 13Ch
        POP ECX
        MOV EDI, ENTRY_POINT
        ADD EDI, 1AF0h;............EDI = 1020B77
        
calc_san0101F13A:
        ROR BYTE PTR DS:[ECX+EDI],2
        LOOPD SHORT calc_san0101F13A

;===================================================================
;  3ème layer de décryptage du loader 101F24A --> 101F5CD
;===================================================================


        MOV EBX, ENTRY_POINT
        MOV EBX, [EBX + 16B8h] ;....3D7E2DD0
        PUSH 383h
        POP ECX
        MOV EDI, ENTRY_POINT
        ADD EDI, 2EDh ;........EDI = 101F374
        SUB EDI,12Ah

calc_san01020755:
        SHR EBX,1
        JNB SHORT calc_san0102075F
        XOR EBX,8C328834h
        
calc_san0102075F:
        XOR BYTE PTR DS:[EDI],BL
        INC EDI
        LOOPD SHORT calc_san01020755


;===================================================================
;  Calcul du CRC32 Checksum sur la memptr_3
;===================================================================


;il s'agit du CRC32 checksum sur presque tout l'exe
        MOV EAX, 1h
        MOV ECX, fsize
        MOV EBX, ENTRY_POINT
        MOV EBX, [EBX + 2FFh]
        SUB ECX, EBX
        MOV EBX, fsize
        MOV edi, memptr_3
        
        PUSH EDX
        PUSH EBX
        XOR EDX,EDX
        STC
        SBB EAX,EAX
        OR EBX,EAX
        DEC EDI

calc_san01020864:
        PUSH ECX
        OR DL,4h
        INC EDI
        XOR AH,BYTE PTR DS:[EDI]
        SHR EAX,3h
        
calc_san0102086E:

        XOR AL,BH
        ADD EAX,07801A018h
        XOR EAX,EBX
        MOV CL,BL
        ROR EAX,CL
        XCHG EAX,EBX
        DEC EDX
        JNZ SHORT calc_san0102086E
        POP ECX
        LOOPD SHORT calc_san01020864
        XCHG EAX,EBX
        POP EBX
        POP EDX



        MOV CRC32, EAX



; Libère la zone allouée pour le CRC32


        MOV ECX, PE_HEADER
        MOV ECX, [ECX + 50h]    ; SIZE_OF_IMAGE  
        MOV EAX, memptr_3
        PUSH 4000h
        PUSH ECX                            ; Taille de la zone allouée
        PUSH EAX                            ; Adresse da la zone allouée
        CALL VirtualFree

;===================================================================
;  Utilisation du CRC32
;===================================================================


        MOV EDX,ENTRY_POINT
        ADD EDX, 1C61h 
        MOV EAX, CRC32
        SUB DWORD PTR [EDX],EAX


;===================================================================
;  1er décryptage des sections (CRC32)
;===================================================================

; D'abord, on récupère quelques infos

        MOV EDX, ENTRY_POINT
        XOR ECX, ECX
        MOVZX ECX, WORD PTR [EDX + 1109h]
        MOV EBX, DWORD PTR [EDX + 1C51h]
        PUSH ECX
        PUSH EBX     


        xor eax, eax
        mov  edi,memptr                         ;set EDI to memory-area
        mov  esi,[edi+03ch]                     ;Locate our ! PEHEADER !

        mov  edx,edi                            ; put target offset into edx
        add  edx,esi
        add  edx,0F8h

        POP EBX
        POP ECX
        
calc_san0101F475:
        PUSH ECX
        BT EBX,EAX
        JNB SHORT calc_san0101F49F
        PUSH EDX
        MOV EDI,DWORD PTR DS:[EDX+14h] ; <-------------- Offset de la section
        ADD EDI,memptr                 ; <---------Ajoute l'IMAGE_BASE
        MOV ECX,DWORD PTR DS:[EDX+10h] ; <--------------Taille de la section
        MOV EDX,ENTRY_POINT
        MOV EDX, [EDX + 1C61h] ;<------------- EDX = EP + 1C61h (calculé à partir du CRC32)
        
calc_san0101F48E:
        SHR EDX,1
        JB SHORT calc_san0101F498
        XOR EDX,0ED43AF32h
        
calc_san0101F498:
        XOR BYTE PTR DS:[EDI],DL
        INC EDI
        DEC ECX
        LOOPD SHORT calc_san0101F48E
        POP EDX

calc_san0101F49F:
        INC EAX
        ADD EDX,28h
        POP ECX
        LOOPD SHORT calc_san0101F475


;===================================================================
;  4ème layer de décryptage du loader 1020887 --> 102098B
;===================================================================


        PUSH 104h
        POP ECX
        MOV EDI, ENTRY_POINT
        ADD EDI, 1800h ; <----------1020887
        MOV EDX, ENTRY_POINT
        MOV EDX, [EDX + 442h]  ; Poly : 1583709B <-------EP + 442h
        
calc_san0101F4CD:
        SHR EDX,1
        JNB SHORT calc_san0101F4D7
        XOR EDX,0ED43AF32h
        
calc_san0101F4D7:
        XOR BYTE PTR DS:[EDI],DL
        INC EDI
        LOOPD SHORT calc_san0101F4CD
        
;===================================================================
;  5ème layer de décryptage du loader 101f4ED --> 101F5CD
;===================================================================


        PUSH ECX
        PUSH EDI
        PUSH ESI
        PUSH EAX
        PUSH offset PORTION_VIDE_1
        POP EDI
        MOV ECX, 24h
        MOV ESI, ENTRY_POINT
        ADD ESI, 180Dh

REMPLIR_1:
        MOV AL, BYTE PTR DS:[ESI]
        INC ESI
        STOS BYTE PTR ES:[EDI]
        LOOPD SHORT REMPLIR_1
        POP EAX
        POP ESI
        POP EDI
        POP ECX



        MOV EDI, ENTRY_POINT
        ADD EDI, 466h
        MOV ECX, 0E0h
        
calc_san01020892:
        MOV AL,BYTE PTR DS:[EDI]

PORTION_VIDE_1:        
        BYTE 36 DUP (0)

        STOS BYTE PTR ES:[EDI]
        LOOPD SHORT calc_san01020892
        

;===================================================================
;  2ème décryptage des sections
;===================================================================

        MOV EDX, ENTRY_POINT
        XOR ECX, ECX
        MOVZX ECX, WORD PTR [EDX + 1109h]
        MOV EBX, DWORD PTR [EDX + 47Ah]
        PUSH ECX
        PUSH EBX     



        xor eax, eax
        mov  edi,memptr                         ;set EDI to memory-area
        mov  esi,[edi+03ch]                     ;Locate our ! PEHEADER !

        mov  edx,edi                            ; put target offset into edx
        add  edx,esi
        add  edx,0F8h



        PUSH ECX
        PUSH EDI
        PUSH ESI
        PUSH EAX
        MOV EDI, offset PORTION_VIDE

        ;PUSH offset PORTION_VIDE
        ;POP EDI
        MOV ECX, 24h
        MOV ESI, ENTRY_POINT
        ADD ESI, 4A4h

        REP MOVSB

        POP EAX
        POP ESI
        POP EDI
        POP ECX

        POP EBX
        POP ECX

calc_san0101F516:
        PUSH ECX
        BT EBX,EAX
        JNB SHORT calc_san0101F553
        MOV EDI,DWORD PTR DS:[EDX+14h] ; <-------------- Raw Offset de la section
        ADD EDI,memptr                 ; <---------Ajoute l'IMAGE_BASE
        MOV ECX,DWORD PTR DS:[EDX+10h] ; <--------------Taille de la section
        PUSH EAX



; Layer de décryptage

calc_san0101F529:
        MOV AL,BYTE PTR DS:[EDI]

PORTION_VIDE:        
        BYTE 36 DUP (0)
        
        STOS BYTE PTR ES:[EDI]
        LOOPD SHORT calc_san0101F529
        POP EAX

calc_san0101F553:
        INC EAX
        ADD EDX,28h
        POP ECX
        LOOPD SHORT calc_san0101F516

;===================================================================
;  6ème layer de décryptage du loader 101F5CD --> 101FC51
;===================================================================

; Récupération des octets du layer de décryptage
    MOV ECX, 24h
    MOV EDI, Offset PORTION_VIDE_3
    MOV ESI, ENTRY_POINT
    ADD ESI, 18D7h
    REP MOVSB

; Layer de décryptage
    MOV ECX, 684h
    MOV EDI, ENTRY_POINT
    ADD EDI, 546h

calc_tou0102095C:
    MOV AL,BYTE PTR DS:[EDI]
    
PORTION_VIDE_3:
    BYTE 36 DUP (0)
    
    STOS BYTE PTR ES:[EDI]
    LOOPD SHORT calc_tou0102095C



;===================================================================
;  7ème layer de décryptage du loader 101F5CD --> 101FC51 (mêmes adresses)
;===================================================================


    MOV EAX, ENTRY_POINT
    ADD EAX, 546h
    MOV ECX, ENTRY_POINT
    MOV ECX, DWORD PTR [ECX + 172Fh]
    MOV EDX, ENTRY_POINT
    MOV EDX, DWORD PTR [EDX + 1735h]
calc_san010207C1:
    SHR EDX,1
    JNB SHORT calc_san010207CB
    XOR EDX,0ED43AF32h
calc_san010207CB:
    XOR BYTE PTR DS:[EAX],DL
    INC EAX
    LOOPD SHORT calc_san010207C1

       
OUF_SECTIONS_DECRYPTEES:

;===================================================================
;  Alloue de la mémoire pour décompresser l'exe et reconstruire le PE header
;===================================================================

        MOV EDX, PE_HEADER
        MOV EDX, [EDX + 50h]     ; SIZE_OF_IMAGE 
        ADD EDX, EDX
        ADD EDX, EDX            ; EDX x 3 (estimation)
        PUSH 4h                 ; type of access protection
        PUSH 3000h              ; type of allocation
        PUSH EDX                ; size of region 
        PUSH 0                  ; address of region to reserve or commit
        CALL VirtualAlloc
        MOV memptr_2,EAX        ; Récupère l'offset de cette nouvelle zone mémoire 


;===================================================================
;  Copie le PE Header dedans
;===================================================================
   

        MOV ESI, PE_HEADER
        ADD ESI, 0F8h                ; Offset de la Section Header
        MOV ECX, [ESI + 14h]         ; Raw Offset de la Première section (compteur du rep)
        MOV SECTIONS_UNPACK, ECX     ; Stocke la raw offset de la zone de décompression    
        MOV EDI, memptr_2            ; destination
        MOV ESI, memptr              ; source
        REP MOVSB                    ; copie



 ; Stocke l'Offset du PE_HEADER_2

        MOV  edi,memptr_2                         
        MOV  edx,edi
        MOV  esi,[edi+03ch]                     ; Récupère l'offset du PE Header
        ADD  edx,esi                            ; edx contient l'adresse du début du PE
        MOV  PE_HEADER_2,edx


;===================================================================
;  On vérifie que les sections ont bien été compressées
;===================================================================

        MOV EDX, ENTRY_POINT
        MOV EBX, [EDX + 1A82h]
        CMP EBX, 0
        JE Copie_des_sections_manquantes
        XOR ECX, ECX
        MOV CL, BYTE PTR [EDX + 1109h]     ; nbre de sections à décompresser
        PUSH ECX
        PUSH EBX     
     
;===================================================================
;  D'abord, on récupère quelques infos
;===================================================================
   

        xor eax, eax
        mov  edi,memptr                         
        mov  esi,[edi+03ch]                     

        mov  edx,edi                            
        add  edx,esi
        add  edx,0F8h

        PUSH EDX
        
        MOV EDX, memptr_2
        MOV EDX, [EDX + 03Ch]
        ADD EDX, memptr_2
        ADD EDX, 0F8h
        MOV ENTETE_SECTION, EDX

        POP EDX
        POP EBX
        POP ECX
; *************************** Début de la décompression********************************

        MOV ESI, SECTIONS_UNPACK
        MOV EAX, ENTETE_SECTION
        MOV [EAX + 14h], ESI     ; Stocke la Raw Offset de la première section
        XOR EAX, EAX
        ADD ESI, memptr_2
        MOV POSITION, ESI
calc_san01020B0F:
        PUSH ECX                            ; Sauvegarde le nombre de sections à décompresser
        BT EBX,EAX
        JNB SHORT saut_de_la_section
        ;----------------Ici, la section va être décompressée----------------
        PUSH EAX
        PUSH EBX
        MOV EDI,DWORD PTR [EDX+14h]        ; Raw Offset de la section
        ADD EDI,memptr                      ; offset du début de la section
        MOV ESI, POSITION
        PUSH ESI                            ; Destination
        PUSH EDI                            ; Source
        CALL DECOMPRESSE_LA_SECTION
        XCHG EAX,ECX                        ; EAX = taille de la zone décompressée
        POP EDI
        POP ESI
        POP EBX
        POP EAX
        JMP calc_san01020B39
saut_de_la_section:
        CALL SAUTE_SECTION        
calc_san01020B39:
        ; ---------------Ici, on passe à la section suivante------------------
        INC EAX
        ADD EDX,28h
        POP ECX
        LOOPD SHORT calc_san01020B0F


        ; ----------------Ici, le travail est terminé ------------------------


;***************************************Fin de la décompression*************************
calc_san01020B60:
        LEA ESP,DWORD PTR SS:[ESP+4]
        JMP Copie_des_sections_manquantes

;===================================================================
;  Passe la main à la section suivante
;===================================================================

SAUTE_SECTION PROC

    PUSH ESI
    PUSH EDX
    MOV EDX, ENTETE_SECTION
    MOV ESI, POSITION
    SUB ESI, memptr_2
    ADD ESI, [EDX + 10h]
    SHR ESI, 8h
    TEST ESI, 1
    JNE CODE_IMPAIR
    INC ESI
CODE_IMPAIR:
    INC ESI
    SHL ESI, 8h
    MOV [EDX + 28h + 14h], ESI
    ADD ESI, memptr_2
    MOV POSITION, ESI
    ADD ENTETE_SECTION, 28h
    POP EDX
    POP ESI
    ret

SAUTE_SECTION ENDP


;===================================================================
;  Décompression à l'aide de l'ApLib 0.36
;===================================================================

DECOMPRESSE_LA_SECTION PROC
    pushad

    mov    esi, [esp + 24h]          ; Source
    mov    edi, [esp + 28h]          ; Destination

    cld
    mov    dl, 80h
    xor    ebx, ebx

literal:
    movsb
    mov    bl, 2
nexttag:
    call   getbit
    jnc    literal

    xor    ecx, ecx
    call   getbit
    jnc    codepair
    xor    eax, eax
    call   getbit
    jnc    shortmatch
    mov    bl, 2
    inc    ecx
    mov    al, 10h
getmorebits:
    call   getbit
    adc    al, al
    jnc    getmorebits
    jnz    domatch
    stosb
    jmp    short nexttag
codepair:
    call   getgamma_no_ecx
    sub    ecx, ebx
    jnz    normalcodepair
    call   getgamma
    jmp    short domatch_lastpos

shortmatch:
    lodsb
    shr    eax, 1
    jz     donedepacking
    adc    ecx, ecx
    jmp    short domatch_with_2inc

normalcodepair:
    xchg   eax, ecx
    dec    eax
    shl    eax, 8
    lodsb
    call   getgamma
    cmp    eax, 32000
    jae    domatch_with_2inc
    cmp    ah, 5
    jae    domatch_with_inc
    cmp    eax, 7fh
    ja     domatch_new_lastpos

domatch_with_2inc:
    inc    ecx

domatch_with_inc:
    inc    ecx

domatch_new_lastpos:
    xchg   eax, ebp
domatch_lastpos:
    mov    eax, ebp

    mov    bl, 1

domatch:
    push   esi
    mov    esi, edi
    sub    esi, eax
    rep    movsb
    pop    esi
    jmp    short nexttag

getbit:
    add     dl, dl
    jnz     stillbitsleft
    mov     dl, [esi]
    inc     esi
    adc     dl, dl
stillbitsleft:
    ret

getgamma:
    xor    ecx, ecx
getgamma_no_ecx:
    inc    ecx
getgammaloop:
    call   getbit
    adc    ecx, ecx
    call   getbit
    jc     getgammaloop
    ret

donedepacking:

    ; EDI = position dans la zone de décompression

     ; ************************* Calculer la RAW OFFSET de la prochaine section (multiple de 200h)
    PUSH EDI
    SUB EDI, memptr_2
    SHR EDI, 8h
    TEST EDI, 1
    JNE PAS_CODE_PAIR
    INC EDI
PAS_CODE_PAIR:
    INC EDI
    SHL EDI, 8h            ; EDI = Raw Offset de la prochaine section (aligné)

    ; ************************** Stocker la RAW OFFSET de la section suivante dans la Section Header

    MOV EAX, ENTETE_SECTION
    MOV [EAX + 28h + 14h], EDI


    ; ************************* Modifie le nom de la section pour indiquer qu'elle a été unpackée
    MOV DWORD PTR [EAX], 06165622Eh
    MOV DWORD PTR [EAX + 4], 078697274h

    ; *************************** Calcul de l'Offset de la prochaine section    

    ADD EDI, memptr_2
    MOV POSITION, EDI       ; POSITION = Offset de la section suivante
    
    ; *************************Stockage de la taille de la section en cours dans la Section Header

    POP EDI
    SUB    EDI, [esp + 40]    ; Récupère la taille de la section décompressée
    MOV    [esp + 28], EDI    ; retourne en EAX cette taille
    MOV [EAX + 10h], EDI
    

    ADD ENTETE_SECTION, 28h
    popad
    ret

DECOMPRESSE_LA_SECTION ENDP

;===================================================================
;   Scanne les sections et copie tel quel celles qui n'ont pas été unpackées
;   Fixer les Raw Offset et taille dans la section Header
;===================================================================
Copie_des_sections_manquantes:


    XOR ECX, ECX
    MOV CL, BYTE PTR [sections]
    MOV ESI, PE_HEADER
    MOV EDI, PE_HEADER_2
    ADD ESI, 0F8h                       ; Section Header
    ADD EDI, 0F8h
    MOV ENTETE_SECTION, EDI
Scanne_sections:
    MOV EDX, [EDI]
    CMP EDX, 'aeb.'
    JNE COPIER_SECTION
Section_suivante:
    ADD ENTETE_SECTION, 28h
    ADD ESI, 28h
    ADD EDI, 28h
    LOOPD Scanne_sections
    JMP Corrige_pe_header

COPIER_SECTION:
    PUSH EDX
    PUSH ECX
    PUSH ESI
    PUSH EDI
    MOV ECX, [ESI + 10h]                ; Récupérer la taille de la section source
    MOV [EDI + 10h], ECX                ; fixer la taille de la section cible

    MOV ESI, [ESI + 14h]                ; Récupérer l'OFFSET de la section source
    ADD ESI, memptr

    MOV EDI, [EDI + 14h]                ; Récupérer l'OFFSET de la section cible
    ADD EDI, memptr_2

    PUSH ECX
    PUSH EDI

    REP MOVSB                           ; Copier les bytes


; *************************** Calculer la RAW OFFSET de la prochaine section cible

    POP EDI             ; Offset de la section en cours
    SUB EDI, memptr_2   ; Raw Offset de la section en cours
    POP ECX
    ADD EDI, ECX        

    SHR EDI, 8h
    TEST EDI, 1
    JNE PAS_CODE_PAIR_1
    INC EDI
PAS_CODE_PAIR_1:
    INC EDI
    SHL EDI, 8h            ; EDI = Raw Offset de la prochaine section (alignée)
    
; ************************** Stocker la RAW OFFSET de la section suivante dans la Section Header

    MOV EAX, ENTETE_SECTION
    MOV [EAX + 28h + 14h], EDI
    

    POP EDI
    POP ESI
    POP ECX
    POP EDX
    JMP Section_suivante
       


;===================================================================
;  Corriger le PE Header
;===================================================================
Corrige_pe_header:


; ********************* Calculer SIZE_OF_IMAGE et FILSESIZE

    XOR ECX, ECX
    MOV CL, BYTE PTR [sections]
    DEC ECX
    MOV EDI, PE_HEADER_2
    ADD EDI, 0F8h
Scanne_sections_2:
    ADD EDI, 28h
    LOOPD Scanne_sections_2

    MOV ESI, [EDI + 14h]
    ADD ESI, [EDI + 10h]
    MOV FILESIZE_2, ESI
    
    MOV ESI, [EDI + 0Ch]
    ADD ESI, [EDI + 10h]
    MOV EDI, PE_HEADER_2
    MOV [EDI + 50h], ESI


; *********************** Calculer l'OEP et le fixer
    MOV EDI, PE_HEADER_2
    MOV ESI, DWORD PTR [EDI + 28h]
    ADD ESI, 0B86h
    MOV [EDI + 28h], ESI


;===================================================================
;  Reconstruire l'IMPORT TABLE 
;  On ne reconstruit pas l'OriginalFirstThunk. On n'utilise que les FirstThunks.
;===================================================================

;  ********************* Fixer la RVA de l'Image Import Descriptor
    MOV EDX, ENTRY_POINT
    MOV EAX, [EDX + 0B0Bh]
    MOV EDX, PE_HEADER_2
    MOV [EDX + 80h], EAX 

; ********************** Charge la DLL à scanner
    CALL RVA2OFFSET                  
    MOV ESI, EAX                    ; ESI = Offset de l'Image Import Descriptor

    MOV EAX, ENTRY_POINT
    MOV EAX, DWORD PTR [EAX + 993h]
    MOV PADDING, EAX
Charge_DLL:
    MOV EAX, PADDING
    CMP DWORD PTR [ESI + 10h], EAX
    JE RECONSTRUCTION_TERMINEE
    MOV EAX, [ESI + 0Ch]
    CALL RVA2OFFSET
    MOV EDI, EAX                    ; EDI = Offset du nom de la DLL à décrypter
    CALL DECRYPTE_NOM_DLL
    PUSH EDI
    CALL LoadLibraryA
    MOV IMAGE_BASE_DLL, EAX
    MOV EDX, EAX                    ; EDX = IMAGE_BASE de la DLL
    MOV EBX, EAX
    
; ******************** Récupère des infos sur la DLL à scanner



    ADD EDX,DWORD PTR DS:[EDX+3Ch]       
    MOV PE_HEADER_DLL, EDX               ; EDX = PE_Header de la DLL
; -----------------------------------------------------------------------------

    MOV EDX,DWORD PTR DS:[EDX+78h]       
    ADD EDX,EBX
    MOV RVA_EXPORTS, EDX                 ; RVA de l'Image Export Descriptor
; -----------------------------------------------------------------------------

    PUSH DWORD PTR DS:[EDX+18h]
    POP NBRE_APIS                        ; Nbre d'APIs dans la DLL
  
; -----------------------------------------------------------------------------
    PUSH DWORD PTR DS:[EDX+20h]          
    POP EDI
    ADD EDI,EBX
    PUSH EDI
    POP TABLE_RVAs                      ; Pointe vers une table de RVAs qui pointent vers les names des APIs


    MOV EBX, TABLE_RVAs                     

; ******************** Récupère le CRC32 grace à EDI (RVA du nom de la DLL - Import Table)

    MOV EDI, [ESI + 10h]                    ; EDI = RVA vers le CRC32 de l'API en cours
    MOV EAX, EDI
    CALL RVA2OFFSET
    MOV EDX, EAX                            ; EDX = Offset vers le CRC32


debut_du_scan:
    MOV EAX, [EDX]                          ; RVA du CRC32
    TEST EAX, 80000000h
    JNE Changer_DLL                         ; L'API est identifiée par son ordinal - il n'y a donc rien à faire :)
    CALL RVA2OFFSET
    INC EAX
    MOV OFFSET_CRC32, EAX                   ; Offset du crc32
    MOV  EAX, [EAX]                         ; CRC32
    MOV CRC32_, EAX
    XOR ECX, ECX

; ********************* Scanne la DLL à la recherche de la bonne API

Calcul_crc32:
    MOV EDI, [EBX]
    ADD EDI, IMAGE_BASE_DLL                     ; Adresse dans la DLL où se situe le nom de l'API
    CALL CALCUL_CRC32

    CMP EAX, CRC32_
    JNZ SHORT API_suivante
    
; ********************** Copie le nom de l'API dans l'Import Table
    PUSH ESI
    MOV ESI, [EBX]
    ADD ESI, IMAGE_BASE_DLL                     ; Adresse dans la DLL où se situe le nom de l'API
    MOV EDI, OFFSET_CRC32
    MOV BYTE PTR [EDI], 0
    INC EDI
Copier_nom_api:
    CMP BYTE PTR [ESI], 0
    JE Copie_terminee    
    MOVSB
    JMP Copier_nom_api
API_suivante:
    ADD EBX,4
    INC ECX
    CMP ECX, NBRE_APIS                                 ; Nombre total d'API "scannables"
    JNZ SHORT Calcul_crc32
Copie_terminee:
    MOV BYTE PTR [EDI], 0
    ADD EDX, 4
    POP ESI
    CMP DWORD PTR [EDX], 0
    JE Changer_DLL
    MOV EBX, TABLE_RVAs
   
    JMP debut_du_scan
    
    ; il faut passer à l'api suivante.
    
Changer_DLL:
    ADD ESI, 14h
    JMP Charge_DLL

RECONSTRUCTION_TERMINEE:
    MOV DWORD PTR [ESI + 10h], 0
    MOV DWORD PTR [ESI + 0Ch], 0
    JMP Rotation_trampoline
    
;===================================================================
;  Calcul d'un CRC32 sur le nom de l'API
;===================================================================


CALCUL_CRC32 PROC

    PUSH EDX
    OR EDX,0FFFFFFFFh

calc_pac0101A313:
    MOV AL,BYTE PTR DS:[EDI]
    OR AL,AL
    JE SHORT calc_pac0101A32E
    INC EDI
    XOR DL,AL
    MOV AL,8

calc_pac0101A31E:
    SHR EDX,1
    JNB SHORT calc_pac0101A328
    XOR EDX,0EDB88320h

calc_pac0101A328:
    DEC AL
    JNZ SHORT calc_pac0101A31E
    JMP SHORT calc_pac0101A313

calc_pac0101A32E:
    XOR EDI,EDI
    XCHG EAX,EDX
    POP EDX
    RETN

CALCUL_CRC32 ENDP


;===================================================================
;  Décryptage du nom de la DLL dans l'Import Table
;===================================================================

DECRYPTE_NOM_DLL PROC

    PUSH EDI
calc_san010206B0:
    OR BYTE PTR DS:[EDI],0
    JE SHORT calc_san010206BA
    NOT BYTE PTR DS:[EDI]
    INC EDI
    JMP SHORT calc_san010206B0
calc_san010206BA:
    POP EDI
    RETN
    
DECRYPTE_NOM_DLL ENDP

;===================================================================
;  Conversion RVA-->OFFSET dans la memptr_2
;  Paramètre : EAX = RVA à convertir 
;===================================================================
RVA2OFFSET PROC
    PUSH EDX
    PUSH EDI
    PUSH EBX
    PUSH ESI
    MOV EDX, PE_HEADER_2
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
    JMP Cherche_rva_section
Calcul_offset:
    JNZ pas_zero
    SUB EAX, EAX
    ADD EAX, [EDX + 14h]
    JMP suite
pas_zero:
    SUB EAX, EDI
    ADD EAX, [ESI + 14h]
suite: 
    ADD EAX, memptr_2
    POP ESI
    POP EBX
    POP EDI
    POP EDX
    RET        

RVA2OFFSET ENDP

;===================================================================
;  Rotation de la table des JMP (alias le trampoline) d'un octet 
;===================================================================
Rotation_trampoline:

; ********************************* Test de l'existence du trampoline
    MOV EAX, ENTRY_POINT
    CMP BYTE PTR [EAX + 0AECh], 0E8h
    JNE Sauvegarde_exe_decrypte_unpacke
; ********************************** Récupère adresse du trampoline

    MOV EAX, DWORD PTR [EAX + 7F7h]
    MOV EBX, PE_HEADER_2
    MOV EBX, [EBX + 34h]
    SUB EAX, EBX            ; RVA du trampoline
    CALL RVA2OFFSET
    MOV OFFSET_TRAMPOLINE, EAX

Cherche_fin_trampoline:
    CMP BYTE PTR [EAX], 0E9h
    JNE Rotation
    ADD EAX, 6h
    JMP Cherche_fin_trampoline
Rotation:
    STD
    DEC EAX
    MOV EDI, EAX
    DEC EAX
    MOV ESI, EAX
Copie_char:
    MOVSB
    CMP ESI, OFFSET_TRAMPOLINE
    JC Modifie_table
    JMP Copie_char
    

;===================================================================
;  Modification de la table des Jumps ( remplace E9h par 25h )
;===================================================================
Modifie_table:
    CLD
    MOV EAX, OFFSET_TRAMPOLINE
    MOV BYTE PTR [EAX], 0FFh
    INC EAX
scanne_trampoline:
    CMP BYTE PTR [EAX], 0E9h
    JNE fin_du_scan
    MOV BYTE PTR [EAX], 25h
    ADD EAX, 6h
    JMP scanne_trampoline
fin_du_scan:
    

;===================================================================
;  Sauvegarde l'exe décrypté et unpacké
;===================================================================
Sauvegarde_exe_decrypte_unpacke:

    PUSH 0
    PUSH 80h
    PUSH 2
    PUSH 0
    PUSH 0
    PUSH 40000000h
    PUSH Offset NOM_FICHIER    ; "dump.exe"
    CALL CreateFileA


   PUSH EAX
   PUSH 0
   PUSH Offset bread
   PUSH FILESIZE_2       
   PUSH memptr_2
   PUSH EAX
   Call WriteFile
   PUSH EAX
   Call CloseHandle


; ********************** Libère la zone allouée pour le unpacking

        MOV ECX, PE_HEADER_2
        MOV ECX, [ECX + 50h]    ; SIZE_OF_IMAGE  
        MOV EAX, memptr_2

        PUSH 4000h
        PUSH ECX                            ; Taille de la zone allouée
        PUSH EAX                            ; Adresse da la zone allouée
        CALL VirtualFree

        JMP Message

;===================================================================
;  Fin de l'unpacking :)
;===================================================================
     


Message:
        PUSH mb_ok
        PUSH offset caption
        PUSH offset decrypte
        PUSH 0
        CALL MessageBoxA
        JMP  end_kill_all

nope_we_dont:
        PUSH mb_ok
        PUSH offset caption
        PUSH offset wrong
        PUSH hWnd
        CALL MessageBoxA
end_kill_all:
        PUSH memptr                ; pointeur vers la zone mémoire
        CALL GlobalFree            ; Libère la mémoire
end_kill_handle:
        PUSH fhandle               ; PUSH filehandle
        CALL CloseHandle           ; CloseHandle
        POPAD

end_:
        CALL    ExitProcess        ;Quitter le programme

End Main                           
