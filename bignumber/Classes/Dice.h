//
//  Dice.h
//  bishibashi
//
//  Created by Eric on 25/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface Dice : UIImageView {
	ButState	_color;
	int			_val;
	UIInterfaceOrientation _orientation;
}

@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) int val;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
