.486
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comdlg32.inc
include \masm32\include\shell32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\shell32.lib


.const
IDI_PATCH equ 100
IDI_TARGETFILE equ 200
IDC_TARGETFILE equ 304
IDC_BROWSE equ 305
IDC_PATCH equ 307
IDC_EXIT equ 308
IDC_CLE  equ 301
IDC_ABOUT equ 303
IDC_REDUIRE equ 306
PATCH  equ 300
IDD_DLG1 equ 1000
COMPTEUR equ 309


.data

TargetFileName      db "nom du fichier à crypter",0
FilterString        db "Cible (*.*)",0,"*.*",0,0

DlgName         db      "PATCH",0
open            db      "open",0
ofn             OPENFILENAME <>
OfnTitle        db      "Selectionner le fichier à crypter",0
ErrorMsgTitle   db      "Erreur",0
OpenError       db      "BeaCryptor Pro ne parvient pas à ouvrir le fichier selectionné",0
ValidityError   db      "erreur !",0
SuccessMsgTitle db      "Information",0
Success         db      "Le fichier a été crypté avec succès !",0
Decrypt         db      "DeCrypt.exe",0
keyfailure      BYTE    "Vous avez oublié de saisir une clé de cryptage",0
working         BYTE    "Le cryptage est en cours, veuillez patienter !", 0
HALTE           BYTE    0

; *************************** Données pour le DES *******************************

S_BOX8  BYTE    13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7
        BYTE    1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2
        BYTE    7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8
        BYTE    2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11

S_BOX7  BYTE    4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1
        BYTE    13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6
        BYTE    1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2
        BYTE    6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12

S_BOX6  BYTE    12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11
        BYTE    10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8
        BYTE    9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6        
	  BYTE    4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13

S_BOX5  BYTE    2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9
        BYTE    14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6
        BYTE    4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14
        BYTE    11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3

S_BOX4  BYTE    7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15
        BYTE    13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9
        BYTE    10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4
        BYTE    3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14

S_BOX3  BYTE    10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8
        BYTE    13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1
        BYTE    13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7
        BYTE    1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12

S_BOX2  BYTE    15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10
        BYTE    3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5
        BYTE    0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15
        BYTE    13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9

S_BOX1  BYTE    14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7
        BYTE    0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8
        BYTE    4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0
        BYTE    15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13

E_TABLE BYTE    32,01,02,03,04,05
        BYTE    04,05,06,07,08,09
        BYTE    08,09,10,11,12,13
        BYTE    12,13,14,15,16,17
        BYTE    16,17,18,19,20,21
        BYTE    20,21,22,23,24,25
        BYTE    24,25,26,27,28,29
        BYTE    28,29,30,31,32,01

P       BYTE    16,07,20,21
        BYTE    29,12,28,17
        BYTE    01,15,23,26
        BYTE    05,18,31,10
        BYTE    02,08,24,14
        BYTE    32,27,03,09
        BYTE    19,13,30,06
        BYTE    22,11,04,25

IP      BYTE    58,50,42,34,26,18,10,2      ; bit de poids faible
        BYTE    60,52,44,36,28,20,12,4
        BYTE    62,54,46,38,30,22,14,6
        BYTE    64,56,48,40,32,24,16,8
        BYTE    57,49,41,33,25,17,9,1
        BYTE    59,51,43,35,27,19,11,3
        BYTE    61,53,45,37,29,21,13,5
        BYTE    63,55,47,39,31,23,15,7      ; bit de poids fort

IP_INV  BYTE    40,8,48,16,56,24,64,32
        BYTE    39,7,47,15,55,23,63,31
        BYTE    38,6,46,14,54,22,62,30
        BYTE    37,5,45,13,53,21,61,29
        BYTE    36,4,44,12,52,20,60,28
        BYTE    35,3,43,11,51,19,59,27
        BYTE    34,2,42,10,50,18,58,26
        BYTE    33,1,41,9,49,17,57,25

PC_1    BYTE    57,49,41,33,25,17,9
        BYTE    1,58,50,42,34,26,18
        BYTE    10,2,59,51,43,35,27
        BYTE    19,11,3,60,52,44,36

        BYTE    63,55,47,39,31,23,15
        BYTE    7,62,54,46,38,30,22
        BYTE    14,6,61,53,45,37,29
        BYTE    21,13,5,28,20,12,4

PC_2    BYTE    14,17,11,24,1,5
        BYTE    3,28,15,6,21,10
        BYTE    23,19,12,4,26,8
        BYTE    16,7,27,20,13,2

        BYTE    41,52,31,37,47,55
        BYTE    30,40,51,45,33,48
        BYTE    44,49,39,56,34,53
        BYTE    46,42,50,36,29,32

C_TABLE BYTE    1,2,3,4,5,6,7,0
        BYTE    8,9,10,11,12,13,14,0 
        BYTE    15,16,17,18,19,20,21,0
        BYTE    22,23,24,25,26,27,28,0



; ********************************** Variables pour le DES *******************************

E               DWORD   0,0                         	; 48 bits
S               DWORD   0
M               QWORD   0          		       	; Message de départ de 64 bits
M1              QWORD   0h
M1_R            DWORD   0
M1_L            DWORD   0
F_M1_R          DWORD   0
K               DWORD   0,0                         	; clé de chiffrement de 48 bits
KEY             QWORD   0                             ; clé de chiffrement de 64 bits
KEY1            QWORD   0
CLES            QWORD   16 DUP(0)
C0              DWORD   0
D0              DWORD   0
C1              DWORD   0 
D1              DWORD   0
CHAINE_CRYPTEE  QWORD   0                   	       ; Message final crypté de 64 bits

; *************************** Variables pour la routine PERMUTATION ***************************
R               DWORD   0
L               DWORD   0
R1              DWORD   0
L1              DWORD   0


; *************************** Fin des données pour le DES ***********************
.data?

hInstance           HINSTANCE   ?
hIcon               HICON       ?
TargetFile          db          MAX_PATH dup(?)
BackupFile          db          MAX_PATH dup(?)
hFile               HANDLE      ?
nBytesWritten       dd          ?



TAILLE_FICHIER      dd          ?
TAILLE_FICHIER_3    dd          ?
TAILLE_FICHIER_CRYPT dd         ?
NOM_FICHIER         db          100h dup(?)
MEMPTR              dd          ?
MEMPTR_2            dd          ?
MEMPTR_3            dd          ?
hFile_3             HANDLE      ?
TAILLE_ZONE         dd          ?
MEMPTR_Bea          dd          ?
SECTIONS            dd          ?
CLE                 db          100h dup (?)
TAILLE_CLE          dd          ?
FIN_CHAINE          dd          ?
PE_HEADER           dd          ?
ThreadID            DWORD       ?
hWnd1               dword       ?

.code
start:

push NULL
call GetModuleHandle		; Récupère le Handle du prog
mov hInstance, eax
MOV MEMPTR_Bea, EAX

push IDI_PATCH
push eax
call LoadIcon			; Récupère le handle de l'icone
mov hIcon, eax

push NULL
push OFFSET DlgProc
push NULL
push OFFSET PATCH
push hInstance
call DialogBoxParamA		; Crée la DialogBox

push eax
call ExitProcess



DlgProc proc hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD


;******************************* Déplacement de la fenêtre ************************
  .IF uMsg == WM_LBUTTONDOWN																	; Pour déplacer la fenêtre
  	INVOKE SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0


;******************************* Initialise la fenêtre ****************************  	 	
  .ELSEIF uMsg == WM_INITDIALOG
    MOV EAX, hWnd
    MOV hWnd1, EAX
    invoke SetDlgItemText,hWnd,IDC_TARGETFILE,ADDR TargetFileName
    invoke GetDlgItem,hWnd,IDC_PATCH
    invoke SetFocus,eax
  .elseif uMsg==WM_COMMAND
    mov eax,wParam
    mov edx,wParam
    shr edx,16
    .if dx==BN_CLICKED

;******************************* BROWSER ******************************************
      .if ax==IDC_BROWSE
      
        mov ofn.lStructSize,SIZEOF ofn
        push hWnd
        pop ofn.hwndOwner
        mov ofn.lpstrFilter,OFFSET FilterString
        invoke lstrcpy,ADDR TargetFile,ADDR TargetFileName
        mov ofn.lpstrFile,OFFSET TargetFile
        mov ofn.nMaxFile,SIZEOF TargetFile
        mov ofn.lpstrTitle,OFFSET OfnTitle
        mov ofn.Flags,OFN_FILEMUSTEXIST or OFN_HIDEREADONLY
        invoke GetOpenFileName,ADDR ofn
        .if eax==TRUE
          invoke SetDlgItemText,hWnd,IDC_TARGETFILE,ADDR TargetFile
        .endif

; *************************** ABOUT ************************************************

      .elseif ax==IDC_ABOUT
	
	push NULL
	push OFFSET DlgProc
	push NULL
	push OFFSET IDD_DLG1
	push hInstance
	call DialogBoxParamA		; Crée la DialogBox	

; ************************** REDUIRE ***********************************************
	.elseif ax==IDC_REDUIRE
	PUSH 6
	PUSH hWnd
	CALL ShowWindow	

	
; =================================================================================
;                                      CRYPTAGE 
; =================================================================================

      .elseif ax==IDC_PATCH

        CMP HALTE, 1
        JNE EXECUTE_THREAD
        invoke MessageBox,0,ADDR working,ADDR ErrorMsgTitle,MB_ICONERROR or MB_OK
        JMP FIN_THREAD        
EXECUTE_THREAD:
        mov  eax,OFFSET ThreadProc
        invoke CreateThread,NULL,NULL,eax,NULL,0,ADDR ThreadID      ; Merci Iczelion ;)
        invoke CloseHandle,eax 
FIN_THREAD:

; ******************************* SORTIE **********************************
      .elseif ax==IDC_EXIT
        invoke SendMessage,hWnd,WM_CLOSE,0,0
      .endif
    .endif
  .elseif uMsg==WM_CLOSE
    invoke EndDialog,hWnd,0
  .ELSE
    mov eax,FALSE
    ret
  .ENDIF
  
  mov eax,FALSE ;TRUE
  ret
DlgProc endp



; *************************** THREAD DE CRYPTAGE *********************************************
; ********************************************************************************************

ThreadProc PROC 
	PUSHAD

; ***************************** Récupère la clé de cryptage ***************************

        PUSH 100h
        PUSH OFFSET CLE
        PUSH IDC_CLE
        PUSH hWnd1
        CALL GetDlgItemTextA
        CMP EAX, 0
        JNE cle_valide
        invoke MessageBox,0,ADDR keyfailure,ADDR ErrorMsgTitle,MB_ICONERROR or MB_OK
        jmp Validity_error
cle_valide:
        MOV TAILLE_CLE, EAX


Cryptage:
; ***************************** Récupère le nom du fichier ****************************
        PUSH SIZEOF TargetFile
        PUSH OFFSET TargetFile
        PUSH IDC_TARGETFILE
        PUSH hWnd1
        CALL GetDlgItemTextA

; ***************************** Récupère l'offset du décrypteur - MEMPTR_3 ****************************
        MOV EAX, MEMPTR_Bea
        MOV EAX, [EAX + 3Ch]
        ADD EAX, MEMPTR_Bea
        ADD EAX, 0F8h
Get_Last_Section:
        CMP DWORD PTR [EAX], 061746144h
        JE Continue
        ADD EAX, 28h
        JMP Get_Last_Section
Continue:
        MOV EDX, [EAX + 0Ch]
        ADD EDX, MEMPTR_Bea
        MOV MEMPTR_3, EDX
        MOV EDX, [EAX + 10h]
        MOV TAILLE_FICHIER_3, EDX

; ******************************* Récupère le contenu du fichier à crypter - MEMPTR ****************        
        push 0                      
        push FILE_ATTRIBUTE_NORMAL  
        push OPEN_EXISTING          
        push 0                      
        push FILE_SHARE_READ                      
        push GENERIC_READ + GENERIC_WRITE   
        push offset TargetFile            
        Call CreateFileA                        ; Ouvrir le fichier 

        .if eax!=INVALID_HANDLE_VALUE
        MOV HALTE, 1
        MOV hFile,eax
        PUSH 0
        PUSH hFile                            
        CALL GetFileSize                        ; récupère la filesize
        MOV TAILLE_FICHIER, EAX
        
        PUSH 4h                 ; type of access protection
        PUSH 3000h              ; type of allocation
        PUSH TAILLE_FICHIER     ; size of region 
        PUSH 0                  ; address of region to reserve or commit
        CALL VirtualAlloc
        mov  MEMPTR,eax                         
        cmp  eax,0                              
        jnz  mem_ok

        push MB_ICONERROR or MB_OK
        push offset ErrorMsgTitle
        push offset ValidityError
        push 0
        call MessageBoxA
        jmp  Validity_error                    

mem_ok:                                         

        push 0                                  
        push offset nBytesWritten               
        push TAILLE_FICHIER                     
        push MEMPTR                             
        push hFile                              
        Call ReadFile                           ; lire le fichier

; *************************** Alloue une VirtualAlloc - MEMPTR_2 *****************

        MOV EAX, TAILLE_FICHIER_3
        ADD EAX, TAILLE_FICHIER
        MOV TAILLE_ZONE, EAX
        PUSH 4h                 ; type of access protection
        PUSH 3000h              ; type of allocation
        PUSH TAILLE_ZONE        ; size of region 
        PUSH 0                  ; address of region to reserve or commit
        CALL VirtualAlloc
        MOV MEMPTR_2,EAX        ; Récupère l'offset de cette nouvelle zone mémoire 

; *************************** Copie le décrypteur dans la VirtualAlloc *****************

        MOV ECX, TAILLE_FICHIER_3
        MOV ESI, MEMPTR_3
        MOV EDI, MEMPTR_2
        REP MOVSB

; **************************  Calcul un premier CRC32 sur la clé **************************************


Init_CRC32:
        MOV ESI, OFFSET CLE
        MOV EBX, TAILLE_CLE         ; Longueur de la clé
        XOR ECX, ECX                ; Compteur de boucle
        LEA EDX, [ECX - 1h]         ; EDX = FFFFFFFFh et contiendra la clé
        XOR EAX, EAX         
Calcul_CRC32:
        LODSB                       ; récupère le contenu situé en ESI
        XOR AL, DL
Boucle:
        SHR EAX,01h
        JNB Fin_Boucle              ; Saut si carry flag = 0
        XOR EAX, 0ADB792E1h         ; Polynôme générateur
        INC ECX
        AND CL, 07h                 
        JNZ Boucle
Fin_Boucle:
        SHR EDX, 08h
        XOR EDX, EAX
        DEC EBX
        JG Calcul_CRC32             ; Boucle tant que EBX > 0
Fin:
        MOV EAX, OFFSET KEY
        MOV DWORD PTR [EAX], EDX
; **************************  Calcul un second CRC32 sur la clé **************************************


Init_CRC32_2:
        MOV ESI, OFFSET CLE
        MOV EBX, TAILLE_CLE         ; Longueur de la clé
        XOR ECX, ECX                ; Compteur de boucle
        LEA EDX, [ECX - 1h]         ; EDX = FFFFFFFFh et contiendra la clé
        XOR EAX, EAX         
Calcul_CRC32_2:
        LODSB                       ; récupère le contenu situé en ESI
        XOR AL, DL
Boucle_2:
        SHR EAX,01h
        JNB Fin_Boucle_2              ; Saut si carry flag = 0
        XOR EAX, 045DF2A9Ch         ; Polynôme générateur
        INC ECX
        AND CL, 07h                 
        JNZ Boucle_2
Fin_Boucle_2:
        SHR EDX, 08h
        XOR EDX, EAX
        DEC EBX
        JG Calcul_CRC32_2             ; Boucle tant que EBX > 0
Fin_2:
        MOV EAX, OFFSET KEY
        MOV DWORD PTR [EAX + 4], EDX
; ************************** Calcul les 16 clés pour le cryptage **************************************

        CALL INIT_CLE                           ; Initialise les tours de clés
        MOV EAX, OFFSET CLES
        MOV EBX, OFFSET K
        MOV ECX, 16
tour_de_cles:
        PUSH ECX
        PUSH EAX
        PUSH EBX
        CALL CALCUL_CLE_Ki                      ; Calcul la clé Ki de 48 bits
        POP EBX
        POP EAX
        POP ECX
        MOV EDI, [EBX]                          ; Transfert la clé Ki dans le tableau CLES
        MOV [EAX], EDI
        MOV EDI, [EBX + 4]
        MOV [EAX + 4], EDI
        ADD EAX, 8
        DEC ECX
        JNE tour_de_cles

; **************************  Crypter le fichier - DES (mode CBC) ************************************************

        MOV EDI, MEMPTR             ; pointeur vers la section à crypter
        ADD EDI, TAILLE_FICHIER
        MOV FIN_CHAINE, EDI         ; pointeur fin de la section à crypter
        MOV EDI, MEMPTR
INIT_CRYPTAGE:
        MOV EAX, OFFSET M                       ; Affecte un QWORD à M
        MOV EBX, [EDI] 
        MOV [EAX], EBX
        MOV EBX, [EDI + 4]
        MOV [EAX + 4], EBX
        PUSH EDI
        CALL DES_ENCRYPTION                   ; Cryptage sur 64 bits (DES)
        POP EDI
        MOV EAX, OFFSET CHAINE_CRYPTEE          ; Récupère le message crypté
        MOV EBX, [EAX]
        MOV [EDI], EBX
        MOV EBX, [EAX + 4]
        MOV [EDI + 4], EBX
        ADD EDI, 8h                             ; décalage de 32 bits
        CMP EDI, FIN_CHAINE
        JNL FIN_CRYPTAGE
CRYPTAGE_DES:
        MOV EAX, OFFSET M                       ; Affecte un QWORD à M
        MOV EBX, [EDI] 
        XOR EBX, [EDI - 8]             
        MOV [EAX], EBX
        MOV EBX, [EDI + 4]
        XOR EBX, [EDI - 8]
        MOV [EAX + 4], EBX
        PUSH EDI
        CALL DES_ENCRYPTION                   ; Cryptage sur 64 bits (DES)
        POP EDI
        MOV EAX, OFFSET CHAINE_CRYPTEE          ; Récupère le message crypté
        MOV EBX, [EAX]
        MOV [EDI], EBX
        MOV EBX, [EAX + 4]
        MOV [EDI + 4], EBX
        ADD EDI, 8h                                     ; décalage de 32 bits
        CMP EDI, FIN_CHAINE
        JL CRYPTAGE_DES
        
FIN_CRYPTAGE:
        SUB EDI, MEMPTR
        MOV TAILLE_FICHIER_CRYPT, EDI

; **************************  Copie le fichier crypté dans la VirtualAlloc - MEMPTR_3 ***********
        MOV EAX, MEMPTR_2
        MOV EAX, [EAX + 3Ch]
        ADD EAX, MEMPTR_2
        MOV PE_HEADER, EAX
        MOV EDX, TAILLE_FICHIER
        MOV [EAX + 58h], EDX 
        ADD EAX, 0F8h
Get_Last_Section_:
        CMP DWORD PTR [EAX], 061746144h
        JE Continue_
        ADD EAX, 28h
        JMP Get_Last_Section_
Continue_:
        MOV EDX, [EAX + 14h]
        ADD EDX, MEMPTR_2
        MOV MEMPTR_3, EDX
        MOV EDX, TAILLE_FICHIER_CRYPT
        MOV DWORD PTR [EAX + 10h], EDX

        MOV EAX, PE_HEADER
        MOV EBX, TAILLE_FICHIER_CRYPT
        ADD [EAX + 50h], EBX

        MOV ECX, TAILLE_FICHIER_CRYPT
        MOV ESI, MEMPTR
        MOV EDI, MEMPTR_3
        REP MOVSB

        MOV EAX, OFFSET TargetFile
Scanne:
        INC EAX
        MOV DL, BYTE PTR [EAX]
        CMP DL, 0
        JNE Scanne
Scanne_2:
        DEC EAX
        MOV DL, BYTE PTR [EAX]
        CMP DL, 5Ch
        JNE Scanne_2
        INC EAX
        MOV ESI, EAX
        MOV EDI, OFFSET NOM_FICHIER
        MOV ECX, 0
Copie_nom:
        INC ECX
        MOVSB
        CMP BYTE PTR [ESI], 0
        JNE Copie_nom
        MOV DWORD PTR [EDI], 06578652Eh
        MOV BYTE PTR [EDI + 4h],0


; ************************** Stocke le nom du fichier dans le décrypteur *************
        MOV EAX, PE_HEADER
        ADD EAX, 0F8h
Get_Last_Section__:
        CMP DWORD PTR [EAX], 7461642Eh
        JE Continue__
        ADD EAX, 28h
        JMP Get_Last_Section__
Continue__:
        MOV EDX, [EAX + 14h]
        ADD EDX, MEMPTR_2
        MOV ESI, OFFSET NOM_FICHIER
        MOV EDI, EDX
        REP MOVSB
                

; **************************  Sauvegarde le fichier crypté ***********



Sauvegarde_fichier_crypte:
    
        MOV EAX, TAILLE_ZONE
        SUB EAX, TAILLE_FICHIER
        ADD EAX, TAILLE_FICHIER_CRYPT
        MOV TAILLE_ZONE, EAX
        
        PUSH 0
        PUSH 80h
        PUSH 2
        PUSH 0
        PUSH 0
        PUSH 40000000h
        PUSH Offset NOM_FICHIER    ; "crypt.exe"
        CALL CreateFileA
        
        PUSH EAX
        PUSH 0
        PUSH Offset nBytesWritten
        PUSH TAILLE_ZONE       
        PUSH MEMPTR_2
        PUSH EAX
        Call WriteFile
        Call CloseHandle
        
        
        PUSH 4000h
        PUSH TAILLE_ZONE                         ; Taille de la zone allouée
        PUSH MEMPTR_2                            ; Adresse da la zone allouée
        CALL VirtualFree



end_kill_all:
        PUSH 4000h
        PUSH TAILLE_FICHIER                    ; Taille de la zone allouée
        PUSH MEMPTR                            ; Adresse da la zone allouée
        CALL VirtualFree
end_kill_handle:
        PUSH hFile                 ; PUSH filehandle
        CALL CloseHandle           ; CloseHandle


        invoke MessageBox,0,ADDR Success,ADDR SuccessMsgTitle,MB_ICONINFORMATION or MB_OK            

Validity_error:
        .else
          invoke MessageBox,0,ADDR OpenError,ADDR ErrorMsgTitle,MB_ICONERROR or MB_OK
        .endif
    MOV HALTE, 0
    POPAD

    RET
ThreadProc ENDP
; ***********************************************************************************************
; ***********************************************************************************************
;
;                                       PROCEDURES POUR LE DES
;
; ***********************************************************************************************
; ***********************************************************************************************

DES_ENCRYPTION PROC

; ********************************* Permute M grace à la table de permutation IP pour obtenir M1 **********

    PUSH SIZEOF M        ; nombre d'octets dans Message source
    PUSH OFFSET M        ; Message source (64 bits)
    PUSH OFFSET M1       ; Message permuté (64 bits)
    PUSH OFFSET IP       ; Table de permutation
    CALL PERMUTATION
; **************************** Scinde M1 en deux DWORD M1_R et M1_L ***************************************
    MOV EAX, OFFSET M1
    MOV EBX, DWORD PTR [EAX]
    MOV M1_R, EBX
    MOV EBX, DWORD PTR [EAX + 4]
    MOV M1_L, EBX

    MOV ECX, 16         ; 16 itérations
    MOV EBX, OFFSET CLES

;==========================================================================================================
;
;                                  BLOC DE CHIFFREMENT - 16 ITERATIONS
;
;==========================================================================================================
    
BLOCK_ENCRYPTION:
    PUSH ECX
    PUSH EBX
; *********************************** Ri-1 est étendu à 48 bits grace à la table de selection des bits **********
    CALL PASSAGE_A_48_bits

; *********************************** Récupère la clé Ki ******************************************************

    ;CALL CALCUL_CLE_Ki
    POP EBX
    MOV EAX, OFFSET K
    MOV EDI, [EBX]                          
    MOV [EAX], EDI
    MOV EDI, [EBX + 4]
    MOV [EAX + 4], EDI
    PUSH EBX
; *********************************** E est Xoré avec la clé de cryptage ****************************************
    MOV EAX, OFFSET E
    
    MOV EBX, OFFSET K
    MOV ESI, DWORD PTR [EBX]
    MOV EDI, DWORD PTR [EAX]
    XOR EDI, ESI
    MOV DWORD PTR [EAX], EDI
    MOV ESI, DWORD PTR [EBX + 4]
    MOV EDI, DWORD PTR [EAX + 4]
    XOR EDI, ESI
    MOV DWORD PTR [EAX + 4], EDI

; ********************************** Transforme E en S en utilisant les 8 S_BOXES *******************************    
    
    MOV EAX, OFFSET E       ; Message de départ (48 bits)
    MOV ESI, OFFSET S_BOX8
    MOV EDI, OFFSET S       ; Message S_BOXé (32 bits)
    MOV ECX, 2
    CALL S_BOX    
    MOV CX, WORD PTR [EAX + 4h]
    MOV WORD PTR [EAX + 1h], CX
    MOV ECX, 2
    CALL S_BOX

; ********************************* Permute S grace à la table de permutation P pour obtenir F(Ri-1,K) **********

    PUSH SIZEOF S        ; nombre d'octets dans Message source
    PUSH OFFSET S        ; Message source (32 bits)
    PUSH OFFSET F_M1_R   ; Message permuté (32 bits)
    PUSH OFFSET P        ; Table de permutation
    CALL PERMUTATION

    MOV EAX, M1_L
    MOV EBX, F_M1_R
    XOR EAX, EBX
    MOV EBX, M1_R
    MOV M1_L, EBX
    MOV M1_R, EAX
    POP EBX
    POP ECX
    ADD EBX, 8
    DEC ECX
    JNE BLOCK_ENCRYPTION

;==========================================================================================================
;
;                                          FIN DU BLOC DE CHIFFREMENT
;
;==========================================================================================================

; **************************** Reconstruit M1 à partir des deux DWORD M1_R et M1_L ***************************************

    MOV EAX, OFFSET M1
    MOV EBX, M1_R
    MOV [EAX], EBX
    MOV EBX, M1_L
    MOV [EAX + 4], EBX
    
; ********************************* Permute M1 grace à la table de permutation IP_INV pour obtenir CHAINE_CRYPTEE **********

    PUSH SIZEOF M1        ; nombre d'octets dans Message source
    PUSH OFFSET M1        ; Message source (64 bits)
    PUSH OFFSET CHAINE_CRYPTEE       ; Message permuté (64 bits)
    PUSH OFFSET IP_INV       ; Table de permutation
    CALL PERMUTATION
    RET
DES_ENCRYPTION ENDP    

;                        |============================================|
;                        |                                            |
;                        |          CALCULE LES TOURS DE CLES         |
;                        |                                            |
;                        |============================================|

CALCUL_CLE_Ki PROC
    MOV K, 0
    SHR C1,1
    JNC SUITE_CLE
    XOR C1, 8000000h
SUITE_CLE:
    SHR D1,1
    JNC SUITE_CLE2
    XOR D1, 8000000h
SUITE_CLE2:
    MOV ESI, OFFSET PC_2
    MOV ECX, 1
    MOV EAX, C1
    MOV EDI, OFFSET K
    MOV DWORD PTR [EDI],0
    MOV DWORD PTR [EDI + 4], 0
    CALL CALCUL_K
    MOV ECX, 1
    MOV EAX, D1
    ADD EDI, 4
    CALL CALCUL_K2
    MOV AL, BYTE PTR [EDI]
    MOV BYTE PTR [EDI - 1], AL
    MOV AX, WORD PTR [EDI + 1]
    MOV WORD PTR [EDI], AX
    MOV BYTE PTR [EDI + 2], 0
    RET
CALCUL_CLE_Ki ENDP

CALCUL_K PROC
DEBUT_CLE:
    MOV DL, BYTE PTR [ESI]
    MOV EBX, 1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    TEST EAX, EBX
    JE BIT_SUIVANT
    XOR DWORD PTR [EDI], ECX
BIT_SUIVANT:
    INC ESI
    SHL ECX, 1
    CMP ECX, 800000h
    JNE DEBUT_CLE
    RET
CALCUL_K ENDP

CALCUL_K2 PROC
DEBUT_CLE2:
    MOV DL, BYTE PTR [ESI]
    SUB DL, 32
    MOV EBX, 1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    TEST EAX, EBX
    JE BIT_SUIVANT2
    XOR DWORD PTR [EDI], ECX
BIT_SUIVANT2:
    INC ESI
    SHL ECX, 1
    CMP ECX, 800000h
    JNE DEBUT_CLE2
    RET
CALCUL_K2 ENDP

;                        |============================================|
;                        |                                            |
;                        |          INITIALISE LA CLE                 |
;                        |                                            |
;                        |============================================|

INIT_CLE PROC
; ******************************** Transforme KEY pour générer les Ki *************************************
    PUSH SIZEOF KEY
    PUSH OFFSET KEY
    PUSH OFFSET KEY1
    PUSH OFFSET PC_1
    CALL PERMUTATION_KEY64
    MOV EAX, OFFSET KEY1
    MOV EBX, DWORD PTR [EAX]
    MOV C0, EBX
    MOV EBX, DWORD PTR [EAX + 4]
    MOV D0, EBX
    PUSH SIZEOF C0
    PUSH OFFSET C0
    PUSH OFFSET C1
    PUSH OFFSET C_TABLE
    CALL PERMUTATION_KEY32
    PUSH SIZEOF D0
    PUSH OFFSET D0
    PUSH OFFSET D1
    PUSH OFFSET C_TABLE
    CALL PERMUTATION_KEY32

    RET

INIT_CLE ENDP

;                        |============================================|
;                        |                                            |
;                        |     PASSAGE DE R(32 bits) --> E(48 bits)   |
;                        |                                            |
;                        |============================================|

PASSAGE_A_48_bits PROC
    MOV ESI, OFFSET E_TABLE
    MOV ECX, 80000000h
    MOV EAX, M1_R
    MOV EDI, OFFSET E
    ADD ESI, 16
    MOV DWORD PTR [EDI], 0
    MOV DWORD PTR [EDI + 4], 0
DEBUT:
    MOV DL, BYTE PTR [ESI]
    MOV EBX,1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    TEST EAX, EBX
    JE SUITE
    XOR DWORD PTR [EDI], ECX
SUITE:
    INC ESI
    SHR ECX, 1
    JNE DEBUT
    MOV ECX, 8000h
    ADD EDI, 4
    MOV ESI, OFFSET E_TABLE
DEBUT_:
    MOV DL, BYTE PTR [ESI]
    MOV EBX,1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    TEST EAX, EBX
    JE SUITE_
    XOR DWORD PTR [EDI], ECX
SUITE_:
    INC ESI
    SHR ECX, 1
    JNE DEBUT_
    RET
    
PASSAGE_A_48_bits ENDP

;                        |============================================|
;                        |                                            |
;                        |    PASSAGE DE E(48 bits) --> S (32 bits)   |
;                        |                                            |
;                        |============================================|

S_BOX PROC
S_BOX_:
    PUSH ECX
    XOR ECX, ECX
    CALL CALCUL_Ligne_Colonne
    PUSH ESI
    ADD ESI, EBX
    IMUL EDX, 15
    MOV CL, BYTE PTR [ESI + EDX]
    SHR E, 6
    POP ESI
    ADD ESI, 60
    CALL CALCUL_Ligne_Colonne
    PUSH ESI
    ADD ESI, EBX
    IMUL EDX, 15
    MOV DL, BYTE PTR [ESI + EDX]
    ADD DL, DL
    ADD DL, DL
    ADD DL, DL
    ADD DL, DL
    ADD DL, CL
    MOV BYTE PTR [EDI], DL
    POP ESI
    INC EDI
    ADD ESI, 60
    SHR E, 6
    POP ECX
    DEC ECX
    JNE S_BOX_
    RET
S_BOX ENDP

CALCUL_Ligne_Colonne PROC
    XOR EDX, EDX
    XOR EBX, EBX
    MOV BL, BYTE PTR [EAX]
    AND BL, 100001b
    ADD BL, BL
    ADC DL, DL
    ADD BL, BL
    ADD BL, BL
    ADD BL, BL
    ADD BL, BL
    ADD BL, BL
    ADC DL, DL
    MOV BL, BYTE PTR [EAX]
    AND BL, 011110b
    SHR EBX, 1
    RET
CALCUL_Ligne_Colonne ENDP


;                        |============================================|
;                        |                                            |
;                        |          PERMUTE UN QWORD OU UN DWORD      |
;                        |                                            |
;                        |============================================|

PERMUTATION PROC
    PUSH EBP
    MOV EBP, ESP
    MOV R1, 0    
    MOV L1, 0
    MOV R, 0
    MOV L, 0
    MOV ECX, [EBP + 14h]
    IMUL ECX, 8
    MOV EDX, [EBP + 10h]
    MOV EAX, [EDX]
    MOV R, EAX
    CMP ECX, 32
    JLE PAS_DE_L
    MOV EAX, [EDX + 4h]
    MOV L, EAX
PAS_DE_L:
    MOV EAX, [EBP + 8h]
TESTE:
    CMP ECX, 32
    JG @3
@0:
    SHL R,1
    JNC CONTINUE
    MOV DL,BYTE PTR [EAX]
    CMP DL,32
    JG @2
@1:
    CALL PERMUTE_R
    JMP CONTINUE
@2:
    CALL PERMUTE_L
    JMP CONTINUE
@3:
    SHL L,1
    JNC CONTINUE
    MOV DL,BYTE PTR [EAX]
    CMP DL, 32
    JG @5
@4:
    JMP @1
@5:
    JMP @2
CONTINUE:
    INC EAX
    DEC ECX
    JNE TESTE
    MOV EAX, [EBP + 0Ch]
    MOV EBX, R1
    MOV [EAX], EBX
    MOV ECX, [EBP + 14h]
    CMP ECX, 4
    JLE PAS_DE_L_
    MOV EBX, L1
    MOV [EAX + 4h], EBX
PAS_DE_L_:
    POP EBP
    RET 10h


PERMUTATION ENDP

PERMUTE_R PROC
    MOV EBX,1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    XOR R1, EBX
    RET
PERMUTE_R ENDP

PERMUTE_L PROC
    SUB DL,32
    MOV EBX,1
    DEC DL
    PUSH ECX
    MOV CL, DL
    SHL EBX, CL
    POP ECX
    XOR L1, EBX
    RET
PERMUTE_L ENDP
;                        |============================================|
;                        |                                            |
;                        |          PERMUTE UNE CLE A 56 bits         |
;                        |                                            |
;                        |============================================|

PERMUTATION_KEY64 PROC
    PUSH EBP
    MOV EBP, ESP
    MOV R1, 0
    MOV L1, 0
    MOV R, 0
    MOV L, 0
    MOV ECX, 1
    MOV EDI, [EBP + 10h]
    MOV EAX, [EDI]
    MOV R, EAX
    MOV EAX, [EDI + 4h]
    MOV L, EAX
PAS_DE_L_KEY:
    MOV EAX, [EBP + 8h]
TESTE_KEY:
    CMP ECX, 32
    JG @3_KEY
@0_KEY:
    SHR R,1
    JNC CONTINUE_KEY
    CMP ECX, 8
    JE CONTINUE_KEY
    CMP ECX, 16
    JE CONTINUE_KEY
    CMP ECX, 24
    JE CONTINUE_KEY
    CMP ECX, 32
    JE CONTINUE_KEY
    MOV DL,BYTE PTR [EAX]
    CMP DL,32
    JG @2_KEY
@1_KEY:
    CALL PERMUTE_R
    JMP CONTINUE_KEY
@2_KEY:
    CALL PERMUTE_L
    JMP CONTINUE_KEY
@3_KEY:
    SHR L,1
    JNC CONTINUE_KEY
    CMP ECX, 40
    JE CONTINUE_KEY
    CMP ECX, 48
    JE CONTINUE_KEY
    CMP ECX, 56
    JE CONTINUE_KEY
    MOV DL,BYTE PTR [EAX]
    CMP DL, 32
    JG @2_KEY
    JMP @1_KEY
CONTINUE_KEY:
    INC EAX
    INC ECX
    CMP ECX, 64
    JNE TESTE_KEY
SUITE_KEY_:
    MOV EAX, [EBP + 0Ch]
    MOV EBX, R1
    MOV [EAX], EBX
    MOV ECX, [EBP + 14h]
    CMP ECX, 4
    JLE PAS_DE_L_KEY_
    MOV EBX, L1
    MOV [EAX + 4h], EBX
PAS_DE_L_KEY_:
    POP EBP
    RET 10h

PERMUTATION_KEY64 ENDP

;                        |============================================|
;                        |                                            |
;                        |          PERMUTE UNE CLE A 28 bits         |
;                        |                                            |
;                        |============================================|

PERMUTATION_KEY32 PROC
    PUSH EBP
    MOV EBP, ESP
    MOV R1, 0
    MOV L1, 0
    MOV R, 0
    MOV L, 0
    MOV ECX, 1
    MOV EDI, [EBP + 10h]
    MOV EAX, [EDI]
    MOV R, EAX
    MOV EAX, [EBP + 8h]
TESTE_KEY32:
    CMP ECX, 32
    JE SUITE_KEY32
@0_KEY32:
    SHR R,1
    JNC CONTINUE_KEY32
    CMP ECX, 8
    JE CONTINUE_KEY32
    CMP ECX, 16
    JE CONTINUE_KEY32
    CMP ECX, 24
    JE CONTINUE_KEY32
    CMP ECX, 32
    JE CONTINUE_KEY32
    MOV DL,BYTE PTR [EAX]
    CMP DL,32
    JG @2_KEY32
@1_KEY32:
    CALL PERMUTE_R
    JMP CONTINUE_KEY32
@2_KEY32:
    CALL PERMUTE_L
    JMP CONTINUE_KEY32
CONTINUE_KEY32:
    INC EAX
    INC ECX
    JMP TESTE_KEY32
SUITE_KEY32:
    MOV EAX, [EBP + 0Ch]
    MOV EBX, R1
    MOV [EAX], EBX
    POP EBP
    RET 10h

PERMUTATION_KEY32 ENDP


end start
