//
//  OCProgress.h
//  ProgressView
//
//  Created by Brian Harmann on 7/24/09.
//  Copyright 2009 Obsessive Code. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OCProgress : UIView {
	float minValue, maxValue;
	float currentValue;
	UIColor *lineColor, *progressRemainingColor, *progressColor;
	BOOL	_isSingleMode;
	BOOL	_isMyself;
	UILabel* _score;
	UILabel*	_nameLbl;
	NSString*	_name;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) UILabel* nameLbl;
@property (nonatomic, assign) BOOL isSingleMode;
@property (nonatomic, assign) BOOL isMyself;
@property (readwrite) float minValue, maxValue, currentValue;
@property (nonatomic, retain) UIColor *lineColor, *progressRemainingColor, *progressColor;
@property (nonatomic, retain) UILabel *score;
-(void)setNewRect:(CGRect)newFrame;
- (id)initWithFrame:(CGRect)frame ForMyself:(BOOL)isMyself AsSingleMode:(BOOL)singleMode;

@end
