//
//  DancingView.h
//  bishibashi
//
//  Created by Eric on 04/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Beat.h"
#import "BigBaby.h"
#import "dot.h"
@interface DancingView : GameView {
	NSInteger _currentRound;
	NSMutableArray*	_beats;
	NSMutableArray*	_receivedBeats;
	BigBaby*	_theBaby;
	Dot*	_theDot;
	NSTimeInterval	_totalDelta;
	NSNumber*	_timeFactor;
	NSInteger	_numSeq;
}
@property (nonatomic, assign) NSInteger numSeq;
@property (nonatomic, retain) NSNumber* timeFactor;
@property (nonatomic, retain) NSMutableArray* beats;
@property (nonatomic, retain) NSMutableArray* receivedBeats;
@property (nonatomic, assign) NSInteger currentRound;
@property (nonatomic, retain) BigBaby*	theBaby;
@property (nonatomic, retain) Dot*	theDot;
@property (nonatomic, assign) NSTimeInterval totalDelta;
@end
