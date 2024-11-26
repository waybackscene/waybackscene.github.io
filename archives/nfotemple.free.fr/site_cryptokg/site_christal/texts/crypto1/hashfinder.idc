//
//   _   _           _       _____ _           _           
//  | | | | __ _ ___| |__   |  ___(_)_ __   __| | ___ _ __ 
//  | |_| |/ _` / __| '_ \  | |_  | | '_ \ / _` |/ _ \ '__|
//  |  _  | (_| \__ \ | | | |  _| | | | | | (_| |  __/ |   
//  |_| |_|\__,_|___/_| |_| |_|   |_|_| |_|\__,_|\___|_|   
//                                                       
//  Description : Search for presence of SHA-1, MD5a, RIPE-MD inside files.
//
//  Code by Snacker & Defiler
//
// snacker@elitereversers.de
// defiler@elitereversers.de
//
// PRIVATE VERSION ONLY FOR FRIENDS


#include <idc.idc>

static main()
{
	auto ea,cont;
	ea = FirstSeg();
	cont = 1;
	while (cont==1) {
		
		ea = FindText(ea,SEARCH_DOWN, 0, 0, "67452301h");
		if( ea == -1) {							
		Message("Nothing was found");					
			break;							
		}
		MakeComm(ea,"Possible Hash found can be SHA-1 or MD5a or Ripe-MD !!!");	
		Jump(ea);
		ea=ea+3;
		cont = AskYN( 1, "Should I Continue Searching ?" );			

	}
	Message("\n" + "Search Complete\n");
}