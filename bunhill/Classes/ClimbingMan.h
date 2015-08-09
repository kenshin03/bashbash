//
//  ClimbingMan.h
//  bishibashi
//
//  Created by Eric on 03/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaManager.h"


@interface ClimbingMan : UIImageView {
	UIImageView*	_arm;
	int _pos;
	UIInterfaceOrientation _orientation;
	BOOL _isComputer;
	UILabel*	_component;
}
@property (nonatomic, retain) UIImageView* arm;
@property (nonatomic, assign) int pos;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL isComputer;
@property (nonatomic, retain) UILabel* component;
@end
