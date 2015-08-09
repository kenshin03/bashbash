//
//  ExpandBox.h
//  bishibashi
//
//  Created by Eric on 31/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ExpandBox : UIView {
	float _upperoffset;
	float _bottomoffset;
	UIView*	_upper;
	UIView* _lower;
	UIImageView*	_theExpandBox;
	UITextView*	_theTextView;
	UIButton*	_thePin;
}
@property (nonatomic, assign) float upperoffset;
@property (nonatomic, assign) float bottomoffset;
@property (nonatomic, retain) UIView* upper;
@property (nonatomic, retain) UIView* lower;
@property (nonatomic, retain) UIButton* thePin;
@property (nonatomic, retain) UIImageView* theExpandBox;
@property (nonatomic, retain) UITextView* theTextView;

- (id) initStartY:(float)startY WithUpper:(float)upper AndUpperOffset:(float)upperoffset AndLower:(float)lower AndLowerOffset:(float)loweroffset AndUpperPins:(NSArray*)uppers AndLowerPins:(NSArray*)lowers  AndThePin:(UIButton*)thePin AndText1:(NSString*)text1 AndText2:(NSString*)text2 AndIsForOther:(BOOL)isOther;
@end

@interface UIButton(Extension)
- (id) copyWithZone:(NSZone*)zone;
@end