//
//  machine.h
//  bishibashi
//
//  Created by Eric on 08/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface Machine : UIImageView {
	ButState			_color;
	int		_pos;
	BOOL	_integrated;
	id			_owner;
	CGRect	_finalPos;
	UIInterfaceOrientation _orientation;
}

- (id)initWithOwner:(id)owner AndColor:(ButState)color;

@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) id owner;
@property(nonatomic, assign) int pos;
@property(nonatomic, assign) CGRect finalPos;
@property(nonatomic, assign) BOOL integrated;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
