//
//  GamePacket.h
//  bishibashi
//
//  Created by Kenny Tang on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PacketTypes {
	// the handshake packets
    kPacketTypeDecideHost,            
    kPacketTypeScenariosDataSync,
    kPacketTypeScenariosDataSyncAck,            
    kPacketTypeDecideRoundWinner,            

	// game state sync packets
    kPacketTypeInLandscape,
    kPacketTypeInLandscapeAck,
    kPacketTypeReset,
	kPacketTypeGameStartReady,
    kPacketTypeGoToNextRound,
    kPacketTypeGoToNextRoundAck,
    kPacketTypeBackToMenu,
    kPacketTypeAnnounceRoundWinner,            
	
	// replay
    kPacketTypeScenariosUpdatePlayAgain,
    kPacketTypeScenariosUpdatePlayAgainAck,
	
	
	// game action packets
    kPacketTypeButtonClicked,            
} PacketType;

@interface GamePacket : NSObject {
    PacketType  type;
    NSUInteger  buttonClicked;
	NSArray*	scenarios;
    NSUInteger  decideHostRandomChallenge;
    NSUInteger  difficultiesLevel;
	NSUInteger selectedGame;
	NSUInteger roundResult;
	NSNumber* roundTime;	
}
@property (nonatomic, assign) PacketType type;
@property (nonatomic, assign) NSUInteger buttonClicked;
@property (nonatomic, assign) NSArray* scenarios;
@property (nonatomic, assign) NSUInteger decideHostRandomChallenge;
@property (nonatomic, assign) NSUInteger difficultiesLevel;
@property (nonatomic, assign) NSUInteger selectedGame;
@property (nonatomic, assign) NSUInteger roundResult;
@property (nonatomic, assign) NSNumber* roundTime;

- (id)initWithType:(PacketType)inType buttonClicked:(NSUInteger)inButtonClicked;
- (id)initButtonClickedPacket:(NSUInteger)inButtonClicked;

@end
