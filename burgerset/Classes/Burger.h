//
//  burger.h
//  bishibashi
//
//  Created by Eric on 10/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "UIViewWithStars.h"
@interface Burger : UIViewWithStars {
	ButState	_color;
	int			_pos;
	BOOL			_empty;
	UIInterfaceOrientation _orientation;
}

- (id)initWithColor:(ButState)color AndPos:(int)pos AndEmpty:(BOOL)empty;

@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) BOOL empty;
@property(nonatomic, assign) int pos;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
