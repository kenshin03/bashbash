//
//  PlayerProfilePacket.h
//  bishibashi
//
//  Created by Kenny Tang on 9/17/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
	// the handshake packets
    kPacketTypePlayerProfile,            
    kPacketTypeButtonRedClick,
    kPacketTypeButtonBlueClick,
    kPacketTypeButtonGreenClick,
    kPacketTypeScenarios,
    kPacketTypeScenariosAck,
    kPacketTypeRoundResultDecide,
    kPacketTypeRoundScoreSubmit,
    kPacketTypeRoundResultDecidedYouWin,
    kPacketTypeRoundResultDecidedYouLose,
} NetworkPacketType;


typedef enum{
    kCharacterPositionLeft,            
    kCharacterPositionRight,
} CharacterPosition;


@interface PlayerProfilePacket : NSObject {
	NSString* peerID;
	NSString* playerName;
	NSString* facebookImageURL;
	NSInteger winCount;
	NSInteger loseCount;	
}
@property (retain) NSString* peerID;
@property (retain) NSString* playerName;
@property (retain) NSString* facebookImageURL;
@property (assign) NSInteger winCount;
@property (assign) NSInteger loseCount;

@end

@interface PlayerScorePacket : NSObject {
	NSInteger score;
}
@property (assign) NSInteger score;

@end

@interface ScenariosPacket : NSObject {
	NSArray* scenarios;
}
@property (nonatomic, assign) NSArray* scenarios;

@end

