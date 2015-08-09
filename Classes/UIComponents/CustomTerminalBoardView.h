//
//  CustomTerminalBoard.h
//  bishibashi
//
//  Created by Eric on 19/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CUSTOMCELLHEIGHT  30
#define CUSTOMCELLWIDTH  20

#define CUSTOMNUMCELL 16


@interface CustomTerminalBoardView : UIView
{
	UIColor* _color;
	CGGradientRef gradient;
	UIView*	_blank;
	NSString* _text;
	NSMutableString* _temptext;
	int	_seq;
	id _timerqueue;
	
}
@property(nonatomic, retain) UIColor* color;
@property(nonatomic, retain) UIView* blank;
@property(nonatomic, retain) NSString* text;
@property(nonatomic, retain) NSMutableString* temptext;
@property(nonatomic, retain) NSMutableArray* labels;
@property(nonatomic, assign) id timerqueue;
@property(nonatomic, assign) int seq;

@end