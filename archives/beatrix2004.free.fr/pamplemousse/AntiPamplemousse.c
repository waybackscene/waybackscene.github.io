/*
AntiPamplemousse - keygen de pamplemousse (Bigbang)
Keygen de BeatriX
21 septembre 2005
Merci à jB pour ses sources de keygens :)
*/

#define WIN32_LEAN_AND_MEAN

#include <stdio.h>
#include <stdlib.h>
#include <windows.h> 	
#include <windowsx.h>
#include "resource.h"
#include "miracl.h"
extern void SHA_1 (char *valeur_init,char *nom,char *hash); 

char		*dlgname = "KEYGEN";
big p,order,lim1,lim2,p1;

void GenererSerial(HWND hwnd);
HINSTANCE hInst;

BOOL CALLBACK DlgProc( HWND hwnd, UINT uMsg, WPARAM wParam,LPARAM lParam)
{ 
	PLOGFONT lplf;
   switch (uMsg)
   {
   		case WM_CLOSE:
   			EndDialog(hwnd,0); 
   			break;

		case WM_INITDIALOG:
			lplf=malloc(sizeof(LOGFONT));
			memset(lplf,0,sizeof(LOGFONT));
			lplf->lfHeight=15;
			lplf->lfWidth=6;
			lplf->lfWeight=FW_BOLD;
			SendDlgItemMessage(hwnd,IDC_SERIAL,WM_SETFONT,(unsigned int)CreateFontIndirect(lplf),1);
			free(lplf);

			SetWindowText(hwnd,"BigContest #11 - Keygen par BeatriX");
			SetDlgItemText(hwnd,IDC_NAME,"beatrix");
			SetFocus(GetDlgItem(hwnd,IDC_NAME));
			return FALSE;
			
 		case WM_COMMAND:
   			switch(LOWORD(wParam))
   			{
   			/*case IDC_NAME:
   				if(HIWORD(wParam)==EN_CHANGE)
					GenererSerial(hwnd);
				break; */
			case IDC_GENERATE:
				GenererSerial(hwnd);
				break;
			case IDC_QUIT:
				EndDialog(hwnd,0); 
				break;

   			}
 		default:
   			return FALSE;
   }
   
   return TRUE;
}


int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{ 
	hInstance = GetModuleHandle(NULL);
	hInst = hInstance;  
	DialogBoxParam(hInstance,dlgname,NULL,DlgProc,(LPARAM)NULL);
 	return 0;
}




void iterate(big x,big q,big r,big a,big b)
{ /* apply Pollards random mapping */
    if (compare(x,lim1)<0)
    {
        mad(x,q,q,p,p,x);
        incr(a,1,a);
        if (compare(a,order)==0) zero(a);
        return;
    }
    if (compare(x,lim2)<0)
    {
        mad(x,x,x,p,p,x);
        premult(a,2,a);
        if (compare(a,order)>=0) subtract(a,order,a);
        premult(b,2,b);
        if (compare(b,order)>=0) subtract(b,order,b);
        return;
    }
    mad(x,r,r,p,p,x);
    incr(b,1,b);
    if (compare(b,order)==0) zero(b);
}

long rho(big q,big r,big m,big n)
{ /* find q^m = r^n */
    long iter,rr,i;
    big ax,bx,ay,by,x,y;
    ax=mirvar(0);
    bx=mirvar(0);
    ay=mirvar(0);
    by=mirvar(0);
    x=mirvar(1);
    y=mirvar(1);
    iter=0L;
    rr=1L;
    do
    { /* Brent's Cycle finder */
        copy(y,x);
        copy(ay,ax);
        copy(by,bx);
        rr*=2;
        for (i=1;i<=rr;i++)
        {
            iter++;
            iterate(y,q,r,ay,by);
            if (compare(x,y)==0) break;
        }
    } while (compare(x,y)!=0);

    subtract(ax,ay,m);
    if (size(m)<0) add(m,order,m);
    subtract(by,bx,n);
    if (size(n)<0) add(n,order,n);
    mirkill(y);
    mirkill(x);
    mirkill(by);
    mirkill(ay);
    mirkill(bx);
    mirkill(ax);
    return iter;
}




#define MIN_NAME 1
#define MAX_NAME 100
#define NPRIMES 10

void GenererSerial(HWND hwnd){

   miracl *mip;
   mip=mirsys(100,0);
   char serial_prefixe[200];
   char serial_generated[40];
   char serial_final[200];
   char *p_NOM;
   char *p_valeurs_init;
   char *processing = "Processing...";
   char *pollard = "Solving discret logarithm problem with Pollard Rho method...please, wait just a minut !";
   int  len,i, lettre;
   char *p_HASH;
   big N0,N2,N3,N4,N6,N8,inverse_N5,N14;
   big a,b,b1,b2,b3,b4;
   int np;
   long iter;
   big pp[NPRIMES],rem[NPRIMES], PROOTS;
   big m,n,Q,R,q,w,x;
   big_chinese bc;

	p_NOM = malloc(100);
	p_valeurs_init = malloc(100);
	p_HASH = malloc (40);
	memset(p_valeurs_init,0,100);
	memset(p_HASH,0,40);
	GetDlgItemText(hwnd,IDC_NAME, p_NOM, 60);

/* ========================================================= Trouver SERIAL1 */
	SetDlgItemText(hwnd,ETAT_AVANCEMENT, processing);
   
/* Initialise les variables */

	a=mirvar(0);
	b=mirvar(0);
	b1=mirvar(0);
	b2=mirvar(0);
	b3=mirvar(0);
	b4=mirvar(0);
	N0=mirvar(0);
	N2=mirvar(0);
	N3=mirvar(0);
	N4=mirvar(0);
	N6=mirvar(0);
	N8=mirvar(0);
	inverse_N5=mirvar(0);
	N14=mirvar(0);
	cinstr(a,"3000012301762800807161335896594829130123128277845811946826175383306");
	cinstr(b1,"107934260319485690713060975931053201049500286139199425849288934983536562755607610662295641078287074255916116739234490190367978714");
	cinstr(b4,"2577865265484846370773601313426443784103258023509115421165898570275904997645739799493774925041813783466075337343829729951941428057625105100134328259190683835690307460760001634083736165098430989875");
	cinstr(N6,"3208758980294089871636889325639601519765013105042818745876534106523");
	cinstr(inverse_N5,"1938701814751868903212309238562151988937449697899016678578381173907");
	cinstr(N3,"4109509431769244994089516623957980949881759417131294476885470163057");
	cinstr(N14,"126374750002268624037501633220404518782674114480658933505173173047");

/* Calculer N2 - SHA-1 - Récupérer les constantes du hash après calcul */

	SHA_1(p_valeurs_init,p_NOM,p_HASH);
	bytes_to_big(0x14,p_HASH,N2);
   

/* Calculer N8 */
	multiply(N14,N2,N14);
	premult(N14,42,b2);
	multiply(b1,b2,b1);
	power(N2,2,b3,b3);
	add(b1,b3,b);
	subtract(b,b4,b);
	multiply(b,a,N8);
	power(N8,1,N6,N8); 
   
/* Calculer le logarithme discret par la méthode Rho de Pollard (type Diffie Helmann) */


/* N8 = PROOTS^x mod N6 */

	SetDlgItemTextA(hwnd,ETAT_AVANCEMENT, pollard );

	for (i=0;i<NPRIMES;i++) 
	{
		pp[i]=mirvar(0);
		rem[i]=mirvar(0);
	}
	q=mirvar(0);
	Q=mirvar(0);
	R=mirvar(0);
	w=mirvar(0);
	m=mirvar(0);
	n=mirvar(0);
	x=mirvar(0);
	p=mirvar(0);
	p1=mirvar(1);
	order=mirvar(0);
	lim1=mirvar(0);
	lim2=mirvar(0);
	PROOTS=mirvar(0);
	cinstr(PROOTS, "1248310966923498661164204883260437277137373139593887776277032788073");
/* décomposition de N6 en 8 facteurs premiers (np) */
	np=8;
	cinstr(pp[0],"2");
	cinstr(pp[1],"5751247");
	cinstr(pp[2],"81514567");
	cinstr(pp[3],"273749507");
	cinstr(pp[4],"2255442769");
	cinstr(pp[5],"85717369999");
	cinstr(pp[6],"254289208463");
	cinstr(pp[7],"254289209159");

	for (i=0;i<np;i++) multiply(p1,pp[i],p1);
	incr(p1,1,p);
	subdiv(p,3,lim1);					/* lim1 <- p/3 */
	premult(lim1,2,lim2);				/* lim2 <- lim1 * 2 */
	for (i=1;i<np;i++) 
	{
		cotstr(pp[i],mip->IOBUFF);
	}
	crt_init(&bc,np,pp);
	for (i=0;i<np;i++)
	{                          /* accumulate solutions for each pp */
		copy(p1,w);					/* w <- p1 */
		divide(w,pp[i],w);			/* w <- w / pp[i] */
		powmod(N8,w,p,Q);				/* Q <- N8^w mod p */
		powmod(PROOTS,w,p,R);			/* R <- PROOTS^w mod p */
		copy(pp[i],order);			/* order <- pp[i] */
		iter=rho(Q,R,m,n);			/* find Q^m = R^n */
		xgcd(m,order,w,w,w);			/* w <- 1/m mod order */
		mad(w,n,n,order,order,rem[i]);	/* rem[i] <- n*w mod order */
	}

	crt(&bc,rem,x);   /* apply Chinese remainder thereom */

	crt_end(&bc);  
 
	SetDlgItemText(hwnd,ETAT_AVANCEMENT, processing);

/* Résolution d'une équation de type RSA */

	powmod(x,inverse_N5,N3,x);
	cotstr(x,serial_prefixe);
	strcat(serial_prefixe,"-");
   
/* **********************************Trouver SERIAL2 */
	GetDlgItemText(hwnd,IDC_NAME,p_NOM , 60);
  len=strlen (p_NOM);

	mip->IOBASE=9;
	N0=mirvar(1);
	memset(&lettre,0,4);
	for (i=0; i<len; i++)
	{
		memcpy(&lettre,p_NOM+i,1);
		premult(N0,lettre, N0);
	}

/* Concaténer SERIAL1 et SERIAL2 */
	cotstr(N0,serial_generated);
	strcpy (serial_final,serial_prefixe);
	strcat (serial_final,serial_generated);

/* Afficher SERIAL */
	SetDlgItemText(hwnd,IDC_SERIAL, serial_final);	
	SetDlgItemText(hwnd,ETAT_AVANCEMENT, processing);

}

