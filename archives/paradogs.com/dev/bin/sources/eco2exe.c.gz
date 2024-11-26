/* 
 * eco2exe.c v0.01 Andrew Kieschnick <andrewk@mail.utexas.edu>
 *
 * converts MIPSEL-LE ecoff to PS-X EXE
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#include <stdio.h>
#include <string.h>

unsigned int char2int(unsigned char *foo)
{
  return foo[3]*16777216 + foo[2]*65536 + foo[1]*256 + foo[0];
}

void int2char(unsigned int foo, unsigned char *bar)
{
  bar[3]=foo>>24;
  bar[2]=foo>>16;
  bar[1]=foo>>8;
  bar[0]=foo;
}

void usage(void)
{
  printf("Usage: eco2exe [-p] <filename>\n\n");
  printf("\t-p\t\tpatch to work on normal psx\n");
  printf("\t<filename>\ta MIPSEL-LE file to convert to PS-X EXE\n\n");
  exit(0);
}

void main(int argc, char *argv[])
{
  FILE *ecoff;
  FILE *exe;
  unsigned char data[4];
  char filename[256];
  int i,j,k=2;
  unsigned int header_data[14];
  unsigned int size;
  unsigned int address;
  unsigned int pc0;
  unsigned char patch=0; /* 0=don't, 1=do */

  printf("eco2exe v0.01 Andrew Kieschnick <andrewk@mail.utexas.edu>\n\n");

  if ((argc<2)||(argc>3))
    usage();

  for(i=1;i<argc;i++)
    {
      if(argv[i][0]=='-')
        switch(argv[i][1])
          {
          case 'P':
          case 'p':
	    patch=1;
	    break;
	  default:
	    usage();
	  }
      else
	strncpy(filename,argv[i],256);
    }
  
  ecoff=fopen(filename, "r");

  if (!ecoff)
    {
      printf("ERROR: Can't open %s\n",filename);
      exit(-1);
    }

  strcat(filename, ".exe"); /* output filename is same as input but with .exe appended */

  exe=fopen(filename, "w");

  if (!exe)
    {
      printf("ERROR: Can't open %s\n",filename);
      exit(-1);
    }

  for(i=0;i<2;i++)
    fscanf(ecoff, "%c", &data[i]);
  
  if ((data[0]!=0x62)||(data[1]!=0x01))
    {
      printf("ERROR: Not a MIPSEL-LE binary!\n");
      exit(-1);
    }
  
  fseek(ecoff, 0x24, SEEK_SET);

  for(i=0;i<4;i++)
    fscanf(ecoff, "%c", &data[i]);
  
  header_data[0]=char2int(data);

  fseek(ecoff, 0x48, SEEK_SET);

  for(i=0;i<4;i++)
    fscanf(ecoff, "%c", &data[i]);
  
  header_data[1]=char2int(data);

  for(i=0;i<4;i++)
    {
      fseek(ecoff, 0x54+i*0x28, SEEK_SET);
      for(j=0;j<4;j++)
	fscanf(ecoff, "%c", &data[j]);
      header_data[k]=char2int(data);
      k++;
      fseek(ecoff, 0x54+i*0x28+0x08, SEEK_SET);
      for(j=0;j<4;j++)
	fscanf(ecoff, "%c", &data[j]);
      header_data[k]=char2int(data);
      k++;
      for(j=0;j<4;j++)
	fscanf(ecoff, "%c", &data[j]);
      header_data[k]=char2int(data);
      k++;
    }
    
  size=(header_data[11]-header_data[2])+header_data[12];
  if (patch)
    {
      pc0=header_data[2]+size;
      size+=16;
    }
  else
    pc0=header_data[0];

  fprintf(exe, "PS-X EXE");
  int2char(0, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* text */
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* data */
  int2char(pc0, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* pc0 */
  int2char(0, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* gp0 */
  int2char(header_data[2], data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* t_addr */
  int2char(size, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* t_size */
  int2char(0, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* d_addr */
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* d_size */
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* b_addr */
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* b_size */
  int2char(0x801fff00, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* s_addr */
  int2char(0, data);
  fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]); /* s_size */

  for(i=0;i<1992;i++)
    fprintf(exe, "%c", 0);

  fseek(ecoff, header_data[4], SEEK_SET);
  address=header_data[2];
  for(i=0;i<header_data[3];i++)
    {
      fscanf(ecoff, "%c", &data[0]);
      fprintf(exe, "%c", data[0]);
      address++;
    }
  fseek(ecoff, header_data[7], SEEK_SET);
  if (address!=header_data[5]) /* wonder if this can happen */
    for(i=address;i<=header_data[5];i++)
      {
	fprintf(exe, "%c", 0);
	address++;
      }
  for(i=0;i<header_data[6];i++)
    {
      fscanf(ecoff, "%c", &data[0]);
      fprintf(exe, "%c", data[0]);
      address++;
    }
  fseek(ecoff, header_data[10], SEEK_SET);
  if (address!=header_data[8]) /* wonder if this can happen */
    for(i=address;i<=header_data[8];i++)
      {      
	fprintf(exe, "%c", 0);
	address++;
      }
  for(i=0;i<header_data[9];i++)
    {
      fscanf(ecoff, "%c", &data[0]);
      fprintf(exe, "%c", data[0]);
      address++;
    }

  fseek(ecoff, header_data[13], SEEK_SET);
  if (address!=header_data[11]) /* wonder if this can happen */
    for(i=address;i<=header_data[11];i++)
      {
	fprintf(exe, "%c", 0);
	address++;
      }
  for(i=0;i<header_data[12];i++)
    {
      fscanf(ecoff, "%c", &data[0]);
      fprintf(exe, "%c", data[0]);
      address++;
    }

  if(patch)
    {
      int2char(0x0c00400c, data); /* jal 0x80010030 */
      fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]);
      int2char(0, data); /* nop */
      fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]);
      int2char(0x08000000 + ((header_data[0]&0x03ffffff)>>2),data); /*j realpc0 */
      fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]);
      int2char(0, data); /* nop */
      fprintf(exe, "%c%c%c%c", data[0], data[1], data[2], data[3]);
    }

  fclose(exe);
  fclose(ecoff);

}


  
  

  
