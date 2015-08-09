//
//  PinPopUp.h
//  bishibashi
//
//  Created by Eric on 01/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"
#import "Constants.h"
#import "MediaManager.h"

@interface PinPopUp : UIImageView {
	UILabel*	_text;
	UIImageView*	_pinbg;
	UIImageView*	_pin;
}

@property (nonatomic, retain) UILabel* text;
@property (nonatomic, retain) UIImageView* pinbg;
@property (nonatomic, retain) UIImageView* pin;

@end
