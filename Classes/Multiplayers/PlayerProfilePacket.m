//
//  PlayerProfilePacket.m
//  bishibashi
//
//  Created by Kenny Tang on 9/17/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "PlayerProfilePacket.h"


@implementation PlayerProfilePacket

@synthesize peerID, playerName, facebookImageURL, winCount, loseCount;

#pragma mark -
#pragma mark NSCoder (Archiving)
- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.peerID forKey:@"peerID"];
	[coder encodeObject:self.playerName forKey:@"playerName"];
	[coder encodeObject:self.facebookImageURL forKey:@"facebookImageURL"];
	[coder encodeInteger:[self winCount] forKey:@"winCount"];
	[coder encodeInteger:[self loseCount] forKey:@"loseCount"];
}

- (id)initWithCoder:(NSCoder *)coder  {
    if (self = [super init]) {
		[self setPeerID:[coder decodeObjectForKey:@"peerID"]];
		[self setPlayerName:[coder decodeObjectForKey:@"playerName"]];
		[self setFacebookImageURL:[coder decodeObjectForKey:@"facebookImageURL"]];
		[self setWinCount:[coder decodeIntegerForKey:@"winCount"]];
		[self setLoseCount:[coder decodeIntegerForKey:@"loseCount"]];
    }
    return self;
}


@end



@implementation PlayerScorePacket

@synthesize score;

#pragma mark -
#pragma mark NSCoder (Archiving)
- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInteger:[self score] forKey:@"score"];
}

- (id)initWithCoder:(NSCoder *)coder  {
    if (self = [super init]) {
		[self setScore:[coder decodeIntegerForKey:@"score"]];
    }
    return self;
}


@end



@implementation ScenariosPacket

@synthesize scenarios;

#pragma mark -
#pragma mark NSCoder (Archiving)
- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:[self scenarios] forKey:@"scenarios"];
}

- (id)initWithCoder:(NSCoder *)coder  {
    if (self = [super init]) {
		[self setScenarios:[coder decodeObjectForKey:@"scenarios"]];
    }
    return self;
}


@end

