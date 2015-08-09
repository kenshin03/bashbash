//
//  BunHillInstructionView.h
//  bishibashi
//
//  Created by Eric on 08/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "ClimbingMan.h"
#import "Bun.h"
@interface BunHillInstructionView : InstructionView {
	ClimbingMan*	_theClimbingMan;
	int _seq;
	NSArray*	_queues;
	
}
@property (nonatomic, retain) NSArray* queues;
@property (nonatomic, assign) int seq;
@property (nonatomic, retain) ClimbingMan* theClimbingMan;
@end
