//
//  Game1View.h
//  bishibashi
//
//  Created by Eric on 06/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"
#import "Baby.h"
#import "GameView.h"


@interface EatbeansView : GameView {
	int _hits;
	int _noBeans;
	int _beanNo;
	Baby*			_theLeftBaby;
	Baby*			_theCenterBaby;
	Baby*			_theRightBaby;
	UIImageView*	_theCoverImg;
	NSArray*		_ballQueue;
	ButState		_state;
	
}
@property (nonatomic, assign) int hits;
@property(nonatomic, assign) int noBeans;
@property(nonatomic, assign) int beanNo;

@property (nonatomic, retain) Baby* theLeftBaby;
@property (nonatomic, retain) Baby* theCenterBaby;
@property (nonatomic, retain) Baby* theRightBaby;
@property(nonatomic, retain) UIImageView* theCoverImg;
@property(nonatomic, retain) NSArray* ballQueue;
@property(nonatomic, assign) ButState state;

@end
