//
//  Ingredient.h
//  bishibashi
//
//  Created by Eric on 21/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface Ingredient : UIImageView {
	ButState	_color; // -2 is bottom, -1 is top
	int			_pos;
	BOOL			_sample;
	UIInterfaceOrientation _orientation;

}

@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) BOOL sample;
@property(nonatomic, assign) int pos;
@property (nonatomic, assign) UIInterfaceOrientation orientation;

@end
