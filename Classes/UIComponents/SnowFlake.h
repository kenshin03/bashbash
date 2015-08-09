//
//  SnowFlake.h
//  bishibashi
//
//  Created by Eric on 13/12/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SnowFlake : UIView {
	id _owner;
	BOOL	_isStopped;
}

@property (nonatomic, assign) BOOL isStopped;
@property (nonatomic, assign) id owner;
@end
