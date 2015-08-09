//
//  AlarmClockInstructionView.h
//  bishibashi
//
//  Created by Eric on 20/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Arrow.h"

@interface AlarmClockInstructionView : InstructionView {
	NSTimer* _theTimer;
	Arrow*	_longArrow;
	Arrow*	_shortArrow;
	NSInteger _currentRound;
	float _speed;
	BOOL _toQuit;
}
@property (nonatomic, assign) BOOL toQuit;
@property (nonatomic, assign) float speed;
@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, retain) Arrow* longArrow;
@property (nonatomic, retain) Arrow* shortArrow;
@property (nonatomic) NSInteger currentRound;
@end
