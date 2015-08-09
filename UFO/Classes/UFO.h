//
//  UFO.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface UFO : UIImageView <NSCopying>{
	ButState			_color;
	BOOL	_toLeft;
	float		_speed;
	UIInterfaceOrientation _orientation;
}

- (id)initWithSeq:(int)seq AndToLeft:(BOOL)toLeft;

@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) float speed;
@property(nonatomic, assign) BOOL toLeft;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
