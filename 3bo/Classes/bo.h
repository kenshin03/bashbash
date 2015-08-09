//
//  bo.h
//  bishibashi
//
//  Created by Eric on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface Bo : UIImageView {
	BOOL	_isMyself;
	ButState	_color;
	int			_pos;	
	UIInterfaceOrientation _orientation;
}
@property (nonatomic, assign) BOOL isMyself;
@property(nonatomic, assign) ButState color;
@property(nonatomic, assign) int pos;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
