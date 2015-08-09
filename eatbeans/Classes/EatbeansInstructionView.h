//
//  EatbeansInstructionView.h
//  bishibashi
//
//  Created by Eric on 29/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionView.h"
#import "Baby.h"
#import "Ball.h"

@interface EatbeansInstructionView : InstructionView {
	int _noBeans;
	int _beanNo;
	Baby*			_theLeftBaby;
	Baby*			_theCenterBaby;
	Baby*			_theRightBaby;
	UIImageView*	_theCoverImg;
	NSArray*		_ballQueue;
	ButState		_state;
	
}
@property(nonatomic, assign) int noBeans;
@property(nonatomic, assign) int beanNo;

@property (nonatomic, retain) Baby* theLeftBaby;
@property (nonatomic, retain) Baby* theCenterBaby;
@property (nonatomic, retain) Baby* theRightBaby;
@property(nonatomic, retain) UIImageView* theCoverImg;
@property(nonatomic, retain) NSArray* ballQueue;
@property(nonatomic, assign) ButState state;

@end
