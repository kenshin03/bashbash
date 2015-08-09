//
//  SnowFlakeView.h
//  bishibashi
//
//  Created by Eric on 13/12/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnowFlake.h"

@interface SnowFlakeView : UIView {
	NSMutableArray*	_snowFlakes;
}

@property (nonatomic, retain) NSMutableArray* snowFlakes;
@end
