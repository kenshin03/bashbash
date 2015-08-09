//
//  3in1InstructionView.h
//  bishibashi
//
//  Created by Eric on 11/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Machine.h"
#import "InstructionView.h"
#import "Route.h"

@interface the3in1InstructionView : InstructionView {
	NSMutableArray* _seq;
	int _curSeq;
	int _currentRound;
	int _integratedType;
	
	Machine* _rMachine;
	Machine* _bMachine;
	Machine* _gMachine;
	
	Route*		_theRoute;
	
	NSArray*	_stations;
	CGPoint*	_positions;
}
@property (nonatomic, retain) NSMutableArray* seq;
@property (nonatomic, assign) int curSeq;
@property (nonatomic, assign) int currrentRound;
@property (nonatomic, assign) int integratedType;

@property (nonatomic, retain) Machine* rMachine;
@property (nonatomic, retain) Machine* gMachine;
@property (nonatomic, retain) Machine* bMachine;
@property (nonatomic, retain) NSArray* stations;
@property (nonatomic, assign) CGPoint* positions;
@property (nonatomic) NSInteger currentRound;

@property (nonatomic, retain ) Route* theRoute;
@end
