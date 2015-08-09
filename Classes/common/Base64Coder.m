

#import "Base64Coder.h"

/* Base64 Encoding Table */
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (NSStringAdditions)

- (NSString *) urlEncoding
{	
	CFStringRef escapeChars = (CFStringRef) @":/?#[]@!$&’()*+,;=";	
	NSString * encoded = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) self, NULL, escapeChars, kCFStringEncodingUTF8);
	return [encoded autorelease];
}

+ (id)dataWithBase64EncodedString:(NSString *)string
{
	if (string == nil)
		[NSException raise:NSInvalidArgumentException format:nil];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

+ (NSString *) base64StringFromData: (NSData *)data length: (int)length 
{
	
	char * input = (char *)[data bytes];
	int iLen = [data length];
	int oDataLen = (iLen*4+2)/3; // output length without padding
	int oLen = ((iLen + 2)/3)*4; // output length including padding
	char * output = malloc(oLen);
	int ip = 0;
	int op = 0;
	while (ip < iLen)
	{
		int i0 = input[ip++] & 0xff;
		int i1 = ip < iLen ? input[ip++] & 0xff : 0;
		int i2 = ip < iLen ? input[ip++] & 0xff : 0;
		int o0 = (i0 & 0xfc) >> 2;
		int o1 = ((i0 & 3) << 4) | ((i1 & 0xf0) >> 4);
		int o2 = ((i1 & 0xf) << 2) | ((i2 & 0xc0) >> 6);
		int o3 = i2 & 0x3f;
		output[op++] = encodingTable[o0];
		output[op++] = encodingTable[o1];
		output[op] = op < oDataLen ? encodingTable[o2] : '=';
		op++;
		output[op] = op < oDataLen ? encodingTable[o3] : '=';
		op++;
	}
	NSString * str = [[[NSString alloc] initWithBytesNoCopy:output length:op encoding:NSUTF8StringEncoding freeWhenDone:YES] autorelease];
	
	return [str urlEncoding];
	
}



@end

