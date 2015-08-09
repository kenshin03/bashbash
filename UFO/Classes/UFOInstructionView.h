//
//  UFOInstructionView.h
//  bishibashi
//
//  Created by Eric on 19/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "UFO.h"
@interface UFOInstructionView : InstructionView {
	float _speed;
	BOOL _toLeft;
	NSMutableArray* _UFOs;
	NSMutableArray* _toLeftUFOs;
	NSMutableArray* _toRightUFOs;
	UFO*	_theUFO;
	UIImageView* _rightBackgroundView;
	NSInteger _currentRound;
}
@property (nonatomic, assign) NSInteger currentRound;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) BOOL toLeft;
@property (nonatomic, retain) NSMutableArray* UFOs;
@property (nonatomic, retain) NSMutableArray* toLeftUFOs;
@property (nonatomic, retain) NSMutableArray* toRightUFOs;
@property (nonatomic, retain) UFO* theUFO;
@property( nonatomic, retain) UIImageView* rightBackgroundView;
-(float) getSpeed;
@end
