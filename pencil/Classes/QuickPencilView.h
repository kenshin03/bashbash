//
//  QuickPencilView.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "QuickPencil.h"
#import "QuickPencilOpponent.h"

@interface QuickPencilView : GameView {
	int _hits;
	int _opponentHits;
	int _opponentScore;
	QuickPencil* _localPencilHoldingHand;
	QuickPencilOpponent*	_opponentPencilHoldingHand;
	UIImageView* _localPencilLead;
	UIImageView* _opponentPencilLead;
	float _duration;
}
@property (nonatomic, assign) int hits;
@property (nonatomic, assign) int opponentHits;
@property (nonatomic, assign) int opponentScore;
@property (nonatomic, assign) float duration;
@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, retain) QuickPencil* localPencilHoldingHand;
@property (nonatomic, retain) QuickPencilOpponent* opponentPencilHoldingHand;
@property (nonatomic, retain) UIImageView* localPencilLead;
@property (nonatomic, retain) UIImageView* opponentPencilLead;

@end
