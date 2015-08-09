//
//  HeartnHandView.h
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Hand.h"
#import "Heart.h"

@interface HeartnHandView: GameView {
	UIImageView*	_me;
	UIImageView*	_opponent;
	Hand*	_myHand;
	Hand*	_opponentHand;
	Heart*	_myHeart;
	Heart*	_opponentHeart;
	BOOL	_myHandShown;
	
	NSMutableArray*	_sampleHands;
	NSInteger _currentRound;
	
}
@property (nonatomic, assign) BOOL myHandShown;
@property (nonatomic, retain) UIImageView* me;
@property (nonatomic, retain) UIImageView* opponent;
@property (nonatomic, retain) Hand* myHand;
@property (nonatomic, retain) Hand* opponentHand;
@property (nonatomic, retain) Heart* myHeart;
@property (nonatomic, retain) Heart* opponentHeart;

@property (nonatomic, retain) NSMutableArray* sampleHands;
@property (nonatomic) NSInteger currentRound;

@end
