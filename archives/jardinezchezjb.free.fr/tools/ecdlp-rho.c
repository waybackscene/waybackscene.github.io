/****************************************************************
  jB's ECDLP Solver v0.02

  ECDLP solver over F(p) using Pollard's Rho algorithm,
  as described in Guide to Elliptic Curve Cryptography,
  by Darrel Hankerson, Alfred Menezes and Scott Vanstone.

  You will need MIRACL to compile it.

  If you find bugs, have ideas to improve it, or simply want
  to tell me that you use it, you can write me at this
  address: resrever@gmail.com

  jB - Apr. 2nd, 2006
  http://jardinezchezjb.free.fr

  v0.02  - Apr. 4, 2006
  - Added save and resume. The computation state is stored in
    rho.sav. You can close and restart the solver when you want.
****************************************************************/

#include <Windows.h>
#include "miracl.h"

#define NB_BRANCHES 16
#define SAVEFILENAME "rho.sav"
#define BUFFER_SIZE 1024
#define SAVE_STEP 0x80000

miracl *mip;
big np;
int nb_iter=0, nb_rounds=0;
int seed;

int save_params(epoint *X, epoint *Y, big *a, big *b, epoint **R, big c1, big c2, big d1, big d2)
{
	char buffer[130];
	FILE *f=fopen(SAVEFILENAME, "w");
	if(f == NULL)
		return -1;
	else
	{
		int i;
		big x = mirvar(0);
		big y = mirvar(0);
		cotstr(c1, buffer);			/* Save c1 */
		fprintf(f, "%s\n", buffer);
		cotstr(c2, buffer);			/* Save c2 */
		fprintf(f, "%s\n", buffer);
		cotstr(d1, buffer);			/* Save d1 */
		fprintf(f, "%s\n", buffer);
		cotstr(d2, buffer);			/* Save d2 */
		fprintf(f, "%s\n", buffer);
		epoint_get(X, x, y);		/* Save X */
		cotstr(x, buffer);
		fprintf(f, "%s\n", buffer);
		cotstr(y, buffer);
		fprintf(f, "%s\n", buffer);
		epoint_get(Y, x, y);		/* Save Y */
		cotstr(x, buffer);
		fprintf(f, "%s\n", buffer);
		cotstr(y, buffer);
		fprintf(f, "%s\n", buffer);
		for(i = 0; i < NB_BRANCHES; i++)
		{
			cotstr(a[i], buffer);	/* Save a, b and R arrays */
			fprintf(f, "%s\n", buffer);
			cotstr(b[i], buffer);
			fprintf(f, "%s\n", buffer);
			epoint_get(R[i], x, y);
			cotstr(x, buffer);
			fprintf(f, "%s\n", buffer);
			cotstr(y, buffer);
			fprintf(f, "%s\n", buffer);
		}
		mirkill(x);
		mirkill(y);
		fclose(f);
		return 0;
	}
}

int read_params(epoint *P, epoint *Q, epoint *X, epoint *Y, big *a, big *b, epoint **R, big c1, big c2, big d1, big d2)
{
	int j;
	FILE *f = fopen(SAVEFILENAME, "r");

	if(f != NULL)
	{
		big x = mirvar(0);
		big y = mirvar(0);
		char buffer[BUFFER_SIZE];

		fscanf(f, "%s\n", buffer);
		cinstr(c1, buffer);				/* Read c1 */
		fscanf(f, "%s\n", buffer);
		cinstr(c2, buffer);				/* Read c2 */
		fscanf(f, "%s\n", buffer);
		cinstr(d1, buffer);				/* Read d1 */
		fscanf(f, "%s\n", buffer);
		cinstr(d2, buffer);				/* Read d2 */
		fscanf(f, "%s\n", buffer);
		cinstr(x, buffer);				/* Read X */
		fscanf(f, "%s\n", buffer);
		cinstr(y, buffer);
		epoint_set(x, y, 0, X);
		fscanf(f, "%s\n", buffer);
		cinstr(x, buffer);				/* Read Y */
		fscanf(f, "%s\n", buffer);
		cinstr(y, buffer);
		epoint_set(x, y, 0, Y);
		for(j = 0; j < NB_BRANCHES; j++)
		{
			fscanf(f, "%s\n", buffer);	/* Read a, b and R arrays */
			cinstr(a[j], buffer);
			fscanf(f, "%s\n", buffer);
			cinstr(b[j], buffer);
			fscanf(f, "%s\n", buffer);
			cinstr(x, buffer);
			fscanf(f, "%s\n", buffer);
			cinstr(y, buffer);
			epoint_set(x, y, 0, R[j]);
		}
		mirkill(x);
		mirkill(y);
		fclose(f);
		printf("File "SAVEFILENAME" loaded\n");
	}
	else
	{
		irand(GetTickCount());
		bigrand(np, c1);
		bigrand(np, d1);
		ecurve_mult2(c1, P, d1, Q, X);
		epoint_copy(X, Y);
		copy(c1, c2);
		copy(d1, d2);
		
		for(j = 0; j < NB_BRANCHES; j++)
		{
			bigrand(np, a[j]);
			bigrand(np, b[j]);
			ecurve_mult2(a[j], P, b[j], Q, R[j]);
		}
	}
	return 0;
}

void rho(epoint* P, epoint* Q, big l)
{
	int j;

	big a[NB_BRANCHES];
	big b[NB_BRANCHES];
	epoint *R[NB_BRANCHES];

	big c1 = mirvar(0);
	big c2 = mirvar(0);
	big d1 = mirvar(0);
	big d2 = mirvar(0);
	big x = mirvar(0);

	epoint* X = epoint_init();
	epoint* Y = epoint_init();

	for(j = 0; j < NB_BRANCHES; j++)
	{
		a[j] = mirvar(0);
		b[j] = mirvar(0);
		R[j] = epoint_init();
	}

	read_params(P, Q, X, Y, a, b, R, c1, c2, d1, d2);

	/*
	Floyd's cycle-finding algorithm used to find (c1, c2) and (d1, d2) such as:
	c1 * P + d1 * Q = c2 * P + d2 * Q
	*/
	do 
	{
		int i;

		nb_iter++;
		if(nb_iter % SAVE_STEP == 0)
		{
			printf(".");
			if(save_params(X, Y, a, b, R, c1, c2, d1, d2) != 0)
				fprintf(stderr, "Couldn't save state!\n");
			nb_iter = 0;
			nb_rounds++;
		}

		/*
		Partition function :
		H(X) = x mod NB_BRANCHES, where x=abscissa(X)
		*/
		epoint_get(X, x, x);
		j = remain(x, NB_BRANCHES);
		ecurve_add(R[j], X);							/* X = X + R[j] */
		add(c1, a[j], c1);
		add(d1, b[j], d1);
		if(compare(c1, np) >= 0) subtract(c1, np, c1);	/* c1 = c1 + a[j] mod n */
		if(compare(d1, np) >= 0) subtract(d1, np, d1);	/* c1 = c1 + a[j] mod n */

		for(i=0; i<2; i++)
		{
			epoint_get(Y, x, x);
			j=remain(x, NB_BRANCHES);
			ecurve_add(R[j], Y);
			add(c2, a[j], c2);
			add(d2, b[j], d2);			
			if(compare(c2, np) >= 0) subtract(c2, np, c2);
			if(compare(d2, np) >= 0) subtract(d2, np, d2);
		}
	} while(!epoint_comp(Y, X));

	/* compute l = (c1 - c2) * (d2 - d1)^(-1) mod np */

	subtract(c1, c2, c1);
	if(exsign(c1) == -1) add(c1, np, c1);
	subtract(d2, d1, d1);
	if(exsign(d1) == -1) add(d1, np, d1);
	xgcd(d1, np, d1, d1, d1); 
	mad(c1, d1, d1, np, np, l);

	/* Should be ok, let's clean all =) */

	mirkill(c1);
	mirkill(c2);
	mirkill(d1);
	mirkill(d2);
	mirkill(x);
	for(j = 0; j < NB_BRANCHES; j++)
	{
		mirkill(a[j]);
		mirkill(b[j]);
		epoint_free(R[j]);
	}
	epoint_free(X);
	epoint_free(Y);
}

int main()
{
	big k, p, a, b, xA, yA, xB, yB;
	epoint *A, *B, *Q;
	DWORD t_min, t_sec;

	mip = mirsys(40,0);
	
	k = mirvar(0);
	p = mirvar(0);
	a = mirvar(0);
	b = mirvar(0);
	xA = mirvar(0);
	yA = mirvar(0);
	xB = mirvar(0);
	yB = mirvar(0);
	np = mirvar(0);

	A = epoint_init();
	B = epoint_init();
	Q = epoint_init();

	mip->IOBASE = 16;
	
	/*
	Parameters initialization. This is the part you have to modify.
	Curve equation : y^2=x^3+a*x+b mod p
	Search for k such as : B = k * A, with A(xA, yA) and B(xB, yB).
	np is the point order.

	Sample parameters, with a order of 50 bits.
	*/

	cinstr(a, "1");
	cinstr(b, "0");
	cinstr(p, "2BDC54601DF835");
	cinstr(np, "2316A9F116985");

	cinstr(xA, "1132DAC939866A");
	cinstr(yA, "0263F7CB9C12E5");
	cinstr(xB, "107EF7ED818C32");
	cinstr(yB, "0A62D38AF07129");

	/* End of parameters initialization */

	/* Check if A and B are on the curve */
	ecurve_init(a, b, p, MR_AFFINE);
	if(epoint_set(xA, yA, 0, A) == 0)
	{
		fprintf(stderr, "ERROR : A is not on curve!\n");
		return 1;
	}

	if(epoint_set(xB, yB, 0, B) == 0)
	{
		fprintf(stderr, "ERROR : B is not on curve!\n");
		return 1;
	}

	/* Check if A and B are of order np */
	ecurve_mult(np, A, Q);
	if(!point_at_infinity(Q))
	{
		fprintf(stderr, "A is not of the order specified!\n");
		return 1;
	}

	ecurve_mult(np, B, Q);
	if(!point_at_infinity(Q))
	{
		fprintf(stderr, "B is not of the order specified!\n");
		return 1;
	}

	/* Let's start! */
	printf("\nComputation started\n");
	t_min = GetTickCount();
	rho(A, B, k);
	t_sec = (GetTickCount() - t_min) / 1000;
	t_min = t_sec / 60;
	t_sec %= 60;

	printf("\nDiscrete logarithm found:\nx = ");
	cotnum(k, stdout);
	ecurve_mult(k, A, Q);
	if (!epoint_comp(Q, B))
		printf("\nERROR : Wrong solution?\n");

	printf("Time : %lumin %lus\n", t_min, t_sec);
	printf("Number of iterations: %lu\n", nb_rounds * SAVE_STEP + nb_iter);
	getchar();

	epoint_free(A);
	epoint_free(B); 
	epoint_free(Q);

	mirkill(k);
	mirkill(p);
	mirkill(a);
	mirkill(b);
	mirkill(xA);
	mirkill(xB);
	mirkill(yA);
	mirkill(yB);

	mirexit(); 
	return(0);
}
