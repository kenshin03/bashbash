//
//  JumingGirlView.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "Bun.h"
#import "ClimbingMan.h"

@interface BunHillView : GameView {
	ClimbingMan*	_theClimbingMan;
	ClimbingMan*	_theClimbingManFlipped;
	float _duration;
	int _seq;
	NSArray*	_queues;
}
@property (nonatomic, retain) NSArray* queues;
@property (nonatomic, assign) int seq;
@property (nonatomic, retain) ClimbingMan* theClimbingMan;
@property (nonatomic, retain) ClimbingMan* theClimbingManFlipped;
@property (nonatomic, assign) float duration;

@end
