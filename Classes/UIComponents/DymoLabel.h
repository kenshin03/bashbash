//
//  DymoLabel.h
//  bishibashi
//
//  Created by Eric on 04/11/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DymoLabel : UIView {
	CGGradientRef gradient;
	CGGradientRef reversegradient;
	NSString* _text;
	UIColor*	_color;
	float	_fontSize;

}
@property (nonatomic, assign) float fontSize;
@property (nonatomic, retain) UIColor* color;
@property (nonatomic, retain) NSString* text;

-(id) initWithFrame:(CGRect)frame AndText:(NSString*)text AndColor:(UIColor*)color AndTextFontSize:(float)fontSize;
@end
