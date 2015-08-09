//
//  AlarmClockView.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Arrow.h"

@interface AlarmClockView : GameView {
	float _speed;
	Arrow*	_longArrow;
	Arrow*	_shortArrow;
	NSDate*	_startTime;
	NSInteger _currentRound;
	UIImageView*	_clockView;
	UIImageView*	_zoomView;
	
}
@property (nonatomic, assign) float speed;
@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, retain) UIImageView* clockView;
@property (nonatomic, retain) UIImageView* zoomView;
@property (nonatomic, retain) Arrow* longArrow;
@property (nonatomic, retain) Arrow* shortArrow;
@property (nonatomic) NSInteger currentRound;

- (void) success:(float)value;

@end
