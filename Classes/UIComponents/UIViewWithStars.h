//
//  UIViewWithStars.h
//  bishibashi
//
//  Created by Eric on 14/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewWithStars : UIView {
	UIImage*	_image;
	float	*_starPosX;
	float	*_starPosY;
	float	*_starSize;
	float	_redColor;
	float	_greenColor;
	float	_blueColor;
	
	float _starOffsetY;
	CGRect _imageRect;
	int	_numStars;
	BOOL	_showStars;
}
@property (nonatomic, assign) int numStars;
@property (nonatomic, assign) BOOL showStars;
@property (nonatomic, assign) float starOffsetY;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) float redColor;
@property (nonatomic, assign) float blueColor;
@property (nonatomic, assign) float greenColor;
@end
