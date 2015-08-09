//
//  JumpingGirl.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface JumpingGirl : UIImageView {
	UIImage*	_toLeftImg;
	UIImage*	_toRightImg;
	UIImage*	_toLeftJumpingImg;
	UIImage*	_toRightJumpingImg;
	ButState			_color;
	id			_owner;
	UIInterfaceOrientation _orientation;
}
@property (nonatomic, retain) UIImage* toLeftImg;
@property (nonatomic, retain) UIImage* toRightImg;
@property (nonatomic, retain) UIImage* centerImg;
@property (nonatomic, retain) UIImage* toLeftJumpingImg;
@property (nonatomic, retain) UIImage* toRightJumpingImg;
@property (nonatomic, assign) ButState color;
@property (nonatomic, assign) id owner;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
