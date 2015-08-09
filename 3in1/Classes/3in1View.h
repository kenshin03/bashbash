//
//  3in1View.h
//  bishibashi
//
//  Created by Eric on 08/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Machine.h"
#import "GameView.h"
#import "Route.h"
@interface the3in1View : GameView {
	NSMutableArray* _seq;
	int _curSeq;
	int _integratedType;
	
	Machine* _rMachine;
	Machine* _bMachine;
	Machine* _gMachine;
	UILabel*	_rButton;
	UILabel*	_bButton;
	UILabel*	_gButton;
	
	NSInteger _currentRound;
	Route*		_theRoute;
	
	NSArray*	_stations;
	CGPoint*	_positions;
}
@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, assign) int curSeq;
@property (nonatomic, assign) int integratedType;

@property (nonatomic, retain) Machine* rMachine;
@property (nonatomic, retain) Machine* gMachine;
@property (nonatomic, retain) Machine* bMachine;
@property (nonatomic, retain) UILabel* rButton;
@property (nonatomic, retain) UILabel* gButton;
@property (nonatomic, retain) UILabel* bButton;
@property (nonatomic, retain) NSArray* stations;
@property (nonatomic, assign) CGPoint* positions;
@property (nonatomic) NSInteger currentRound;

@property (nonatomic, retain ) Route* theRoute;
@end


