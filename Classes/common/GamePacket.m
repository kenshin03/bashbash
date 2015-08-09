//
//  GamePacket.m
//  bishibashi
//
//  Created by Kenny Tang on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GamePacket.h"

@implementation GamePacket

@synthesize type;
@synthesize buttonClicked;
@synthesize scenarios;
@synthesize decideHostRandomChallenge;
@synthesize difficultiesLevel;
@synthesize selectedGame;
@synthesize roundTime;
@synthesize roundResult;

- (id)initWithType:(PacketType)inType buttonClicked:(NSUInteger)inButtonClicked{
    if (self = [super init]) {
        type = inType;
        buttonClicked = inButtonClicked;
	}
	return self;
}

- (id)initScenariosPacket:(NSArray*) inScenarios inDifficultiesLevel:(NSUInteger)inDifficultiesLevel inGame:(NSUInteger)inGame{
    if (self = [super init]) {
        type = kPacketTypeScenariosDataSync;
        scenarios = inScenarios;
		difficultiesLevel = inDifficultiesLevel;
		selectedGame = inGame;
	}
	return self;
}

- (id)initScenariosAckPacket{
    if (self = [super init]) {
        type = kPacketTypeScenariosDataSyncAck;
	}
	return self;
}

- (id)initInLandscapePacket{
    if (self = [super init]) {
        type = kPacketTypeInLandscape;
	}
	return self;
}

- (id)initInLandscapeAckPacket{
    if (self = [super init]) {
        type = kPacketTypeInLandscapeAck;
	}
	return self;
}

- (id)initGameStartReadyPacket{
    if (self = [super init]) {
        type = kPacketTypeGameStartReady;
	}
	return self;
}

- (id)initBackToMenuPacket{
    if (self = [super init]) {
        type = kPacketTypeBackToMenu;
	}
	return self;
}

- (id)initButtonClickedPacket:(NSUInteger)inButtonClicked{
    if (self = [super init]) {
        type = kPacketTypeButtonClicked;
        buttonClicked = inButtonClicked;
	}
	return self;
}

- (id)initDecideHostPacket:(NSUInteger)inDecideHostRandomChallenge{
    if (self = [super init]) {
        self.type = kPacketTypeDecideHost;
		decideHostRandomChallenge = inDecideHostRandomChallenge;
	}
	return self;
}

- (id)initDecideRoundWinnerPacket:(NSUInteger)inRoundResult roundTime:(NSNumber*)inRoundTime{
    if (self = [super init]) {
        self.type = kPacketTypeDecideRoundWinner;
		roundResult = inRoundResult;
		roundTime = inRoundTime;
		NSLog(@"inside initDecideRoundWinnerPacket inRoundResult:%i inRoundTime:%f ", inRoundResult, [inRoundTime floatValue]);
	}
	return self;
}


- (id)initAnnounceRoundWinnerPacket:(NSUInteger)inRoundResult{
    if (self = [super init]) {
        self.type = kPacketTypeAnnounceRoundWinner;
		roundResult = inRoundResult;
	}
	return self;
}


- (id)initScenariosUpdatePlayAgainPacket:(NSArray*) inScenarios{
    if (self = [super init]) {
        self.type = kPacketTypeScenariosUpdatePlayAgain;
        self.scenarios = inScenarios;
	}
	return self;
}

- (id)initScenariosUpdatePlayAgainAckPacket{
    if (self = [super init]) {
        self.type = kPacketTypeScenariosUpdatePlayAgainAck;
	}
	return self;
}


- (id)initGoToNextRoundPacket{
    if (self = [super init]) {
        self.type = kPacketTypeGoToNextRound;
	}
	return self;
}

- (id)initGoToNextRoundAckPacket{
    if (self = [super init]) {
        self.type = kPacketTypeGoToNextRoundAck;
	}
	return self;
}



- (id)initResetPacket {
    return [self initWithType:kPacketTypeReset buttonClicked:0];
}


#pragma mark -
#pragma mark NSCoder (Archiving)
- (void)encodeWithCoder:(NSCoder *)coder {
	NSLog(@"encoding type %i, buttonClicked %i, object %@, decideHostRandomChallenge %i, difficultiesLevel %i, selectedGame %i, roundTime %f, roundResult %i", self.type, self.buttonClicked, self.scenarios, self.decideHostRandomChallenge, self.difficultiesLevel, self.selectedGame, self.roundTime, self.roundResult);
    [coder encodeInt:[self type] forKey:@"type"];
    [coder encodeInteger:[self buttonClicked] forKey:@"buttonClicked"];
    [coder encodeInteger:[self difficultiesLevel] forKey:@"difficultiesLevel"];
	[coder encodeObject:[self scenarios] forKey:@"scenarios"];
	[coder encodeInteger:[self decideHostRandomChallenge] forKey:@"decideHostRandomChallenge"];
	[coder encodeInteger:[self selectedGame] forKey:@"selectedGame"];
	[coder encodeObject:[self roundTime] forKey:@"roundTime"];
	[coder encodeInteger:[self roundResult] forKey:@"roundResult"];
	
}

- (id)initWithCoder:(NSCoder *)coder  {
    if (self = [super init]) {
        [self setType:[coder decodeIntForKey:@"type"]];
        [self setButtonClicked:[coder decodeIntegerForKey:@"buttonClicked"]];
		[self setDifficultiesLevel:[coder decodeIntegerForKey:@"difficultiesLevel"]];
		[self setScenarios:[coder decodeObjectForKey:@"scenarios"]];
		[self setDecideHostRandomChallenge:[coder decodeIntegerForKey:@"decideHostRandomChallenge"]];
		[self setSelectedGame:[coder decodeIntegerForKey:@"selectedGame"]];
		[self setRoundTime:[coder decodeObjectForKey:@"roundTime"]];
		[self setRoundResult:[coder decodeIntegerForKey:@"roundResult"]];
    }
    return self;
}


@end
