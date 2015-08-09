//
//  DancingInstructionView.h
//  bishibashi
//
//  Created by Eric on 10/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "BigBaby.h"
#import "Dot.h"
#import "Beat.h"
@interface DancingInstructionView : InstructionView {
	NSMutableArray*	_beats;
	BigBaby*	_theBaby;
	Dot*	_theDot;
	float	_timeFactor;
	float	_totalDelay;
	NSInteger	_numSeq;
	NSInteger	_currentBeat;
	NSInteger	_roundNo;
}
@property (nonatomic, assign) NSInteger numSeq;
@property (nonatomic, retain) NSMutableArray* beats;
@property (nonatomic, retain) BigBaby*	theBaby;
@property (nonatomic, retain) Dot*	theDot;
@end
