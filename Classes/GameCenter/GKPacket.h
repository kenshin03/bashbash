//
//  GKPacket.h
//  bishibashi
//
//  Created by Eric on 22/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Constants.h"
typedef enum GKPacketTypes {
	// match metadata
	kGKPacketTypeGame,
	kGKPacketTypeGameLevel,

	
	// the handshake packets
    kGKPacketTypeStart,
	kGKPacketTypeAckStart,
	kGKPacketTypeEndWithScore,
	kGKPacketTypeEndWithTimeUsed,
	kGKPacketTypeRoundStart,
	kGKPacketTypeAckRoundStart,
	kGKPacketTypeImageUrl,
			
	// game action packets
    kGKPacketTypeButtonClicked,            
	
	// packets to determine win/losee
	kGKPacketTypeScoreUpdated,
	kGKPacketTypeTimeUsed,
	
	kGKPacketTypeExchangeName,
	kGKPacketTypeExchangeNameAck,
	
	kGKPacketTypeCountry,
	
	kGKPacketTypeGameMode,
	kGKPacketTypeGamesSequence,
} GKPacketType;


@interface GKPacket : NSObject {
	GKPacketType	_packetType;
	Game	_game;
	GameLevel	_gameLevel;
	GameMode	_gameMode;
	 int	_score;
	 int _round;
	 int _numMatches;
	 int _numWins;
	NSArray*	_scenarios;
	ButState	_butState;
	float	_timeUsed;
	NSString*	_name;
	NSArray*	_games;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) Game game;
@property (nonatomic, assign) GameMode gameMode;
@property (nonatomic, assign) GameLevel gameLevel;
@property(nonatomic, assign) GKPacketType packetType;
@property(nonatomic, assign) ButState butState;
@property(nonatomic, assign)  int score;
@property(nonatomic, assign)  int round;
@property(nonatomic, assign)  int numMatches;
@property(nonatomic, assign)  int numWins;
@property (nonatomic, assign) float timeUsed;
@property(nonatomic, assign) NSArray* scenarios;
@property(nonatomic, assign) NSArray* games;

- (NSData*) toNSData;
- (void) initWithNSData: (NSData*) data;

@end
