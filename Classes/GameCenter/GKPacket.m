//
//  GKPacket.m
//  bishibashi
//
//  Created by Eric on 22/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GKPacket.h"

@implementation GKPacket
@synthesize butState = _butState;
@synthesize packetType = _packetType;
@synthesize scenarios = _scenarios;
@synthesize score = _score;
@synthesize round = _round;
@synthesize gameLevel = _gameLevel;
@synthesize game = _game;
@synthesize gameMode = _gameMode;
@synthesize  name = _name;
@synthesize timeUsed = _timeUsed;
@synthesize games = _games;
@synthesize numWins = _numWins;
@synthesize numMatches = _numMatches;

/*
+(char*) NSArrayToBytes:(NSArray*) arr AndSeparator:(char) sep
{
	char* bytes;
	// if array element is not nsarray 
	if (![[arr objectAtIndex:0] isKindOfClass:[NSArray class]])	{
		length = sizeof(char) * [arr count]*2+1;
		bytes = (char*)malloc(length);
		bytes[0] = [arr count];
		for (int i=0; i<[arr length]; i++)	{
			bytes[i*2+1] = sep;
			bytes[i*2+2] = [[arr objectAtIndex:i] intValue];
		}
		return bytes;
	}
	// if array element is nsarray 
	else {
		for (NSArray* subarr in arr)	{
			char* subBytes = [GKPacket NSArrayToBytes:subarr AndSeparator:(sep+1)];
			
	}

*/		

- (void) dealloc
{
	self.name = nil;
	[super dealloc];
}

- (NSData*) toNSData
{
	
	int length;
	char* bytes;
	float temp;
	NSData* data2;
	id scenario;
	switch (self.packetType)	{
		case kGKPacketTypeCountry:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:self.name];
			length = sizeof(char)+2*sizeof(int) + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			int numMatches = self.numMatches;
			int numWins = self.numWins;
			memcpy(bytes+1, &(numMatches), sizeof(int));
			memcpy(bytes+1+sizeof(int), &(numWins), sizeof(int));
//			bytes[1] = (char)(self.numMatches);
//			bytes[2] = (char)(self.numWins);
//			memcpy (bytes+3, data2.bytes, [data2 length]);
			memcpy (bytes+1+2*sizeof(int), data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeCountry %@ numMatches %d numWins %d", self.name, self.numMatches, self.numWins);
			break;			

		case kGKPacketTypeImageUrl:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:self.name];
			length = sizeof(char)*1 + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			memcpy (bytes+1, data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeImageUrl %@", self.name);
			break;			
			
		case kGKPacketTypeExchangeNameAck:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:[[GKLocalPlayer localPlayer] alias]];
			length = sizeof(char)*1 + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			memcpy (bytes+1, data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeExchangeNameAck %d", bytes[0]);
			break;			
		case kGKPacketTypeExchangeName:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:[[GKLocalPlayer localPlayer] alias]];
			length = sizeof(char)*1 + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			memcpy (bytes+1, data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeExchangeName %d", bytes[0]);
			break;
		case kGKPacketTypeGame:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (char)(self.game);
			NSLog(@"send kGKPacketTypeGame %d", bytes[0]);
			break;
		case kGKPacketTypeGameMode:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (char)(self.gameMode);
			NSLog(@"send kGKPacketTypeGameMode %d", bytes[0]);
			break;
			
		case kGKPacketTypeGameLevel:
			length = sizeof(char)*4;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (char)(self.gameLevel);
			NSLog(@"send kGKPacketTypeGameLevel %d %d", bytes[0], bytes[1]);
			break;
			
			
		case kGKPacketTypeButtonClicked:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] =(self.packetType);
			bytes[1] = (self.butState);
			NSLog(@"send kGKPacketTypeButtonClicked %d", bytes[0]);
			break;
			
		case kGKPacketTypeScoreUpdated:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (char)(self.score);
			break;
		
		case kGKPacketTypeTimeUsed:
			length = sizeof(char)*5;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			temp = self.timeUsed;
			memcpy(bytes+1, &temp, 4);
			NSLog(@"send kGKPacketTypeTimeUsed %d", bytes[0]);
			break;
			

		case kGKPacketTypeAckStart:
			length = sizeof(char)*1;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			NSLog(@"send kGKPacketTypeAckStart %d", bytes[0]);
			break;

		case kGKPacketTypeStart:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:self.scenarios];
			NSLog(@"data2 is %@, sceanrio is %@", data2, self.scenarios);
			length = sizeof(char)*1 + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			memcpy (bytes+1, data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeStart %d", bytes[0]);
			break;

		case kGKPacketTypeGamesSequence:
			data2 = [NSKeyedArchiver archivedDataWithRootObject:self.games];
			NSLog(@"data2 is %@, sceanrio is %@", data2, self.games);
			length = sizeof(char)*1 + sizeof(char)*[data2 length];
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			memcpy (bytes+1, data2.bytes, [data2 length]);
			NSLog(@"send kGKPacketTypeGamesSequence %d", bytes[0]);
			break;
			
		case kGKPacketTypeRoundStart:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (self.round);
			NSLog(@"send kGKPacketTypeRoundStart with round %d", bytes[1]);
			break;
			
		case kGKPacketTypeAckRoundStart:
			length = sizeof(char)*1;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			NSLog(@"send kGKPacketTypeAckRoundStart");
			break;
			
		case kGKPacketTypeEndWithScore:
			length = sizeof(char)*2;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			bytes[1] = (char)(self.score);
			NSLog(@"send kGKPacketTypeEnd %d", bytes[0]);
			NSLog(@"score %d", bytes[1]);
			break;

		case kGKPacketTypeEndWithTimeUsed:
			length = sizeof(char)*5;
			bytes = (char*)malloc(length);
			bytes[0] = (self.packetType);
			temp = self.timeUsed;
			memcpy(bytes+1, &temp, 4);
			NSLog(@"send kGKPacketTypeEndWithTimeUsed %d", bytes[0]);
			NSLog(@"timeused %f", temp);
			break;
			
	}			
	NSData* data = [NSData dataWithBytes:bytes length:length];
	free(bytes);
	return data;
}
- (void) initWithNSData: (NSData*)data
{
	char* bytes = data.bytes;
	self.packetType = bytes[0];
	char* bytesCopy;
	float temp;
	int numMatches;
	int numWins;
	switch (self.packetType)	{
		case kGKPacketTypeCountry:
			memcpy (&numMatches, bytes+1, sizeof(int));
			memcpy (&numWins, bytes+1+sizeof(int), sizeof(int));
			self.numMatches = numMatches;
			self.numWins = numWins;
			//self.numMatches = ( int)(bytes[1]);
			//self.numWins = ( int)(bytes[2]);
			
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.name = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1+2*sizeof(int)) length:[data length]-(1+2*sizeof(int))]];
			free (bytesCopy);
			NSLog(@"recv country name%@ numMatches %d numWins %d", self.name, self.numMatches, self.numWins);
			break;
		case kGKPacketTypeImageUrl:
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.name = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1) length:[data length]-1]];
			free (bytesCopy);
			NSLog(@"recv iamgeurl%@", self.name);
			break;
		case kGKPacketTypeExchangeNameAck:
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.name = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1) length:[data length]-1]];
			free (bytesCopy);
			NSLog(@"recv exchangeack name%@", self.name);
			break;
		case kGKPacketTypeExchangeName:
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.name = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1) length:[data length]-1]];
			free (bytesCopy);
			NSLog(@"recv exchange name%@", self.name);
			break;
		case  kGKPacketTypeStart:
			NSLog(@"start");
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.scenarios = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1) length:[data length]-1]];
			NSLog(@"scenarios is %@", self.scenarios);
			free (bytesCopy);
			break;

		case  kGKPacketTypeGamesSequence:
			NSLog(@"game Seq");
			bytesCopy = malloc (sizeof(char)*[data length]);
			[data getBytes:bytesCopy length:[data length]];
			self.games = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:(bytesCopy+1) length:[data length]-1]];
			NSLog(@"games is %@", self.games);
			free (bytesCopy);
			break;
			
		case kGKPacketTypeButtonClicked:
			self.butState = bytes[1];
	//		NSLog(@"recv but stat is %d", self.butState);
			break;
		case kGKPacketTypeScoreUpdated:
			self.score = (int)(bytes[1]);
	//		NSLog(@"recv but stat is %d", self.score);
			break;
		case kGKPacketTypeRoundStart:
			self.round = (int)(bytes[1]);
			break;
		case kGKPacketTypeTimeUsed:
			memcpy (&temp, bytes+1, 4);
			self.timeUsed = temp;
			break;
		case kGKPacketTypeEndWithScore:
			self.score = (int)(bytes[1]);
			break;
		case kGKPacketTypeEndWithTimeUsed:
			memcpy (&temp, bytes+1, 4);
			self.timeUsed = temp;
			break;
		case kGKPacketTypeGame:
			self.game = (Game)(bytes[1]);
			break;
		case kGKPacketTypeGameMode:
			self.gameMode = (GameMode)(bytes[1]);
			NSLog(@"recv game mode is %d", self.gameMode);
			break;
		case kGKPacketTypeGameLevel:
			self.gameLevel = (GameLevel)(bytes[1]);
			NSLog(@"recv game level is %d", self.gameLevel);
			break;
			
	}
}

@end
