//
//  Hand.h
//  bishibashi
//
//  Created by Eric on 12/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Hand : UIView {
	BOOL _isOpponent;
	int	_rotateAngle;
	int	_val;
	UIImage*	_image;
}
@property (nonatomic, assign) int rotateAngle;
@property (nonatomic, assign) BOOL isOpponent;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int val;
@end
