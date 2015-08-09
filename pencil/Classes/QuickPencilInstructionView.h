//
//  QuickPencilView.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "QuickPencil.h"

@interface QuickPencilInstructionView: InstructionView {
	int _hits;
	int _opponentHits;
	QuickPencil* _localPencilHoldingHand;
	UIImageView* _localPencilLead;
	float _duration;
}
@property (nonatomic, assign) int hits;
@property (nonatomic, assign) int opponentHits;
@property (nonatomic, assign) float duration;
@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, retain) QuickPencil* localPencilHoldingHand;
@property (nonatomic, retain) UIImageView* localPencilLead;

@end
