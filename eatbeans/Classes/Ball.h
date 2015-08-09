//
//  Ball.h
//  bishibashi
//
//  Created by Eric on 07/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "UIViewWithStars.h"

@interface Ball : UIViewWithStars {
//	float	_starPosX[15];
//	float	_starPosY[15];
//	float	_starSize[15];
//	UIImage*				_image;
	ButState			_direction;
	id			_owner;
	float		_speed;
	UIInterfaceOrientation _orientation;	
}

- (id)initWithOwner:(id)owner AndSpeed:(float)speed AndColor:(ButState)color AndOrientation:(UIInterfaceOrientation) orientation;
//@property (nonatomic, retain) UIImage* image;
@property(nonatomic, assign) ButState direction;
@property(nonatomic, assign) id owner;
@property(nonatomic, assign) float speed;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
