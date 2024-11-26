////////////////////////////////////////////////////////////
// RWG file decrypter for Reflexive games.
// http://www.reflexive.net
// Coded by jB
// 13 Jul. 2006
//
// http://jardinezchezjb.free.fr / resrever@gmail.com
////////////////////////////////////////////////////////////

#include <Windows.h>
#include <ImageHlp.h>

#pragma comment(lib, "ImageHlp.lib")

DWORD RandomBuffer[256];
DWORD Bytes[256];

/*
 * Auxiliar function used by the random generator initialization
 */
DWORD RNG_InitAux(int seed, LPDWORD RandomBuffer)
{
	DWORD tmp1, tmp2;

	RandomBuffer[1] = 0;
	RandomBuffer[4] = 0;

	RandomBuffer[2] = seed;
	RandomBuffer[3] = seed;
	RandomBuffer[5] = 0x67;

	__asm
	{
		mov ecx, RandomBuffer
		lea esi, [ecx+3FCh]
		mov edi, 0FAh
_rngaux_loop:
		mov eax, [ecx+0Ch]
		mov tmp2, eax
		; mov eax, tmp2
		mov edx, 41C64E6Dh
		mul edx
		shl edx, 10h
		add eax, 3039h
		adc edx, 0FFFFh
		mov tmp2, eax
		shr eax, 10h
		and edx, 0FFFF0000h
		or eax, edx
		mov tmp1, eax
		mov eax, tmp2
		mov [ecx+0Ch], eax
		mov eax, tmp1
		mov [esi], eax
		sub esi, 4
		dec edi
		jnz _rngaux_loop

		or esi, 0FFFFFFFFh
		mov edx, 80000000h
		lea eax, [ecx+24h]
_rngaux_loop2:
		mov ecx, [eax]
		and ecx, esi
		or ecx, edx
		mov [eax], ecx
		shr edx, 1
		shr esi, 1
		add eax, 1Ch
		test edx, edx
		jnz _rngaux_loop2
	}
}

/*
 * Initializes the random number generator used to decrypt the file,
 * using a 32 bit seed.
 */
void RNG_Init(DWORD seed)
{
	int i;

	RandomBuffer[1] = 0;
	RandomBuffer[0] = 1;
	RNG_InitAux(GetTickCount(), RandomBuffer);

	for(i = 0; i < 256; i++)
	{
		if(i < 0xF9)
			Bytes[i] = i + 1;
		else Bytes[i] = 0;
	}
	RNG_InitAux(seed, RandomBuffer);
}

/*
 * Returns a 32 bit pseudo random value.
 */
DWORD RNG_Random()
{
	DWORD result;
	__asm
	{
		lea ecx, [RandomBuffer]

		mov eax, [ecx+10h]
		inc dword ptr [ecx+4]
		push esi
		mov edx, dword ptr [eax*4+Bytes]
		lea eax, dword ptr [ecx+eax*4+18h]
		mov [ecx+10h], edx
		mov edx, [ecx+14h]
		mov esi, dword ptr [edx*4+Bytes]
		mov [ecx+14h], esi
		mov ecx, dword ptr [ecx+edx*4+18h]
		xor dword ptr [eax], ecx
		mov eax, [eax]
		mov result, eax
		pop esi
	}
	return result;
}

/*
 * Get the encryption key of the file ReflexiveArcade\RAW_002.wdt.
 * The encryption key depends on the encrypted RWG file size, and on
 * other Reflexive files size.
 */
DWORD getWdtEncryptionKey(char *rwgFile)
{
	char *fileList[] = 
	{
		"ReflexiveArcade\\RAW_003.wdt",
		"ReflexiveArcade\\button_pressed.jpg",
		"ReflexiveArcade\\button_hover.jpg",
		"ReflexiveArcade\\button_normal.jpg",
		"ReflexiveArcade\\Background.jpg"
	};        
	HANDLE hFile;
	DWORD dwEncryptionKey;
	int i;

	hFile = CreateFile(rwgFile, FILE_READ_DATA, FILE_SHARE_READ,
		NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		printf("Game files are corrupt, please re-install the game and try again");
		return -1;
	}
	dwEncryptionKey = GetFileSize(hFile, NULL);
	CloseHandle(hFile);

	for(i = 0; i < sizeof(fileList) / sizeof(char *); i++)
	{
		hFile = CreateFile(fileList[i], FILE_READ_DATA,	FILE_SHARE_READ,
			NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		if(hFile == INVALID_HANDLE_VALUE)
			printf("file '%s' is missing!\n", fileList[i]);
		else
		{
			dwEncryptionKey += GetFileSize(hFile, NULL);
			CloseHandle(hFile);
		}
	}
	printf("Encryption key for WDT file: %08X\n", dwEncryptionKey);
	return dwEncryptionKey;
}

/*
 * Decrypts the file ReflexiveArcade\RAW_002.wdt, and displays its
 * contents. The encryption key is obtained calling getWdtEncryptionKey.
 */
void decryptWdtFile(char *rwgFile)
{
	int i;
	HANDLE hWdtFile;
	DWORD dwWdtFileSize, dwBytesRead;
	LPBYTE pFileData;
	DWORD dwEncryptionKey = getWdtEncryptionKey(rwgFile);
	RNG_Init(dwEncryptionKey);

	hWdtFile = CreateFile("ReflexiveArcade\\RAW_002.wdt", FILE_READ_DATA, FILE_SHARE_READ,
		NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hWdtFile == INVALID_HANDLE_VALUE)
	{
		printf("Game files are corrupt, please re-install the game and try again");
		return;
	}
	dwWdtFileSize = GetFileSize(hWdtFile, NULL);
	pFileData = VirtualAlloc(NULL, dwWdtFileSize, MEM_COMMIT, PAGE_READWRITE);
	ReadFile(hWdtFile, pFileData, dwWdtFileSize, &dwBytesRead, NULL);	
	CloseHandle(hWdtFile);

	for(i = 0; i < dwWdtFileSize; i++)
	{
		*(pFileData + i) -= RNG_Random();
	}
	printf("\nContents of RAW_002.wdt\n-----------------------\n%s\n", pFileData);
	VirtualFree(pFileData, dwWdtFileSize, MEM_DECOMMIT);
}

/*
 * Gets the encryption key for the RWG (encrypted game executable) file,
 * that depends on the file ReflexiveArcade\\RAW_002.wdt.
 */
DWORD getRwgEncryptionKey()
{
	HANDLE hFile;
	DWORD dwFileSize, dwBytesRead;
	DWORD nbRounds;
	LPDWORD pFileData;
	DWORD dwEncryptionKey = 0;
	int i;

	hFile = CreateFile("ReflexiveArcade\\RAW_002.wdt", FILE_READ_DATA, FILE_SHARE_READ,
		NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		printf("Can't open file ReflexiveArcade\\RAW_002.wdt");
		return -1;
	}

	dwFileSize = GetFileSize(hFile, NULL);
	nbRounds = dwFileSize & 3;

	pFileData = VirtualAlloc(NULL, dwFileSize, MEM_COMMIT, PAGE_READWRITE);
	ReadFile(hFile, pFileData, dwFileSize, &dwBytesRead, NULL);
	CloseHandle(hFile);	

	for(i = 0; i < nbRounds; i++)
		dwEncryptionKey += pFileData[i];
	printf("Encryption key for RWG file: %08X\n", dwEncryptionKey);
	VirtualFree(pFileData, dwFileSize, MEM_DECOMMIT);
	return dwEncryptionKey;
}

/*
 * Gets the encryption parameters of the encrypted executable "filename".
 * It returns the offset of the file from which the file is encrypted, and
 * the number of encrypted bytes
 */
int GetEncryptedSectionInfo(char *filename, LPDWORD EncryptedOffset, LPDWORD EncryptedSize)
{
	LOADED_IMAGE LoadedImage;
	DWORD EntryPoint;
	IMAGE_SECTION_HEADER Section;
	DWORD SizeOfSection;
	int i = 0;

	if(MapAndLoad(filename, NULL, &LoadedImage, FALSE, TRUE) == FALSE)
	{
		printf("Could not MapAndLoad.\n");
		return -1;
	}
	EntryPoint = LoadedImage.FileHeader->OptionalHeader.AddressOfEntryPoint;

	if(LoadedImage.NumberOfSections <= 0)
	{
		printf("Error calculating file offset (what type of PE file is this ?)\n");
		return -1;
	}
	
	while(i < LoadedImage.NumberOfSections)
	{
		Section = LoadedImage.Sections[i];
		SizeOfSection = min(Section.Misc.VirtualSize, Section.SizeOfRawData);
		if(Section.VirtualAddress <= EntryPoint && Section.VirtualAddress + SizeOfSection >= EntryPoint)
			break;
		i++;
	}
	*EncryptedSize = SizeOfSection - (EntryPoint - Section.VirtualAddress);

	*EncryptedOffset = (EntryPoint - Section.VirtualAddress) + Section.PointerToRawData;
	UnMapAndLoad(&LoadedImage);
	return 0;
}

/*
 * Decrypts the RWG game executable file.
 * If input is "game.rwg", the decrypted file name will be "game.rwg.exe".
 */
void decryptRwgFile(char *rwgFile)
{
	HANDLE hFile, hOutFile;
	DWORD dwBytesRead;
	LPBYTE pFileData;	
	DWORD EncryptedSize, EncryptedOffset;	
	int i = 0;
	DWORD dwEncryptionKey;
	char *exeFile = VirtualAlloc(NULL, lstrlen(rwgFile + 4 + 1), MEM_COMMIT, PAGE_READWRITE);
	lstrcpy(exeFile, rwgFile);
	lstrcat(exeFile, ".exe");
	CopyFile(rwgFile, exeFile, FALSE);
	
	printf("\nDecrypting %s...\n", rwgFile);
	printf("-----------");
	for(i = 0; i < lstrlen(rwgFile); i++)
		printf("-");
	printf("---\n");
	dwEncryptionKey = getRwgEncryptionKey();

	if(GetEncryptedSectionInfo(rwgFile, &EncryptedOffset, &EncryptedSize))
	{
		printf("Can't get encryption information.\n");
		return;
	}
	printf("%X bytes encrypted at offset %X\n", EncryptedSize, EncryptedOffset);

	hFile = CreateFile(rwgFile, FILE_READ_DATA, FILE_SHARE_READ,
		NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		printf("Can't open file %s.\n", rwgFile);
		return;
	}

	pFileData = VirtualAlloc(NULL, EncryptedSize, MEM_COMMIT, PAGE_READWRITE);
	SetFilePointer(hFile, EncryptedOffset, NULL, FILE_BEGIN);

	ReadFile(hFile, pFileData, EncryptedSize, &dwBytesRead, NULL);
	if(EncryptedSize != dwBytesRead)
	{
		printf("There was an error reading the file contents into memory.\n");
		VirtualFree(pFileData, EncryptedSize, MEM_DECOMMIT);
		CloseHandle(hFile);
		return;
	}
	CloseHandle(hFile);

	RNG_Init(dwEncryptionKey);
	printf("First decrypted bytes:\n");
	for(i = 0; i < EncryptedSize; i++)
	{
		*(pFileData + i) -= RNG_Random();
		if(i < 16)
			printf("%02X ", *(pFileData + i));
	}

	hOutFile = CreateFile(exeFile, FILE_READ_DATA | FILE_WRITE_DATA,
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		printf("Can't open file %s.\n", exeFile);
		return;
	}

	SetFilePointer(hOutFile, EncryptedOffset, NULL, FILE_BEGIN);
	WriteFile(hOutFile, pFileData, EncryptedSize, &dwBytesRead, NULL);

	VirtualFree(pFileData, EncryptedSize, MEM_DECOMMIT);
	CloseHandle(hOutFile);
	printf("\nFile %s successfully decrypted!\nRun %s to play.", rwgFile, exeFile);
	VirtualFree(exeFile, lstrlen(rwgFile + 4 + 1), MEM_DECOMMIT);
}

int main(int argc, char *argv[])
{
	char *gamePath, *endPathPos;
	if(argc != 2)
	{
		printf("Usage:\t %s <RWG_File>\n", argv[0]);
		return 0;
	};

	gamePath = VirtualAlloc(NULL, lstrlen(argv[1] + 1), MEM_COMMIT, PAGE_READWRITE);
	lstrcpy(gamePath, argv[1]);
	endPathPos = strrchr(gamePath, '\\');
	if(endPathPos != NULL)
	{
		*endPathPos = 0;
		printf("%s\n", gamePath);
		SetCurrentDirectory(gamePath);		
	}
	VirtualFree(gamePath, lstrlen(argv[1] + 1), MEM_DECOMMIT);
	decryptWdtFile(argv[1]);
	decryptRwgFile(argv[1]);
	return 0;
}
