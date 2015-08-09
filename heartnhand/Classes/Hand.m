//
//  Hand.m
//  bishibashi
//
//  Created by Eric on 12/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "Hand.h"

@implementation Hand
@synthesize val = _val;
@synthesize image = _image;
@synthesize rotateAngle = _rotateAngle;
@synthesize isOpponent = _isOpponent;

static inline double radians (double degrees) {return degrees * M_PI/180;}


-(id) initWithFrame:(CGRect) rect 
{
	if (self = [super initWithFrame:rect])	{
		self.rotateAngle = 0;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;	
		self.isOpponent = NO;
		self.image = [UIImage imageNamed:[NSString stringWithFormat:@"hand%d.png", self.val+1]];
	}
	return self;
}

-(void) setRotateAngle:(int) rotateAngle
{
	_rotateAngle = rotateAngle;
	self.transform = CGAffineTransformMakeRotation(radians(rotateAngle));
}
-(void) setVal:(int) val
{
	_val = val;
	self.image = [UIImage imageNamed:[NSString stringWithFormat:@"hand%d.png", self.val+1]];
	[self setNeedsDisplay];
}
	
- (void) dealloc
{
	self.image = nil;
}

-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetBlendMode (UIGraphicsGetCurrentContext(), kCGBlendModeDarken);
	[self.image drawInRect:rect];
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	NSString* str= [[NSString alloc] initWithFormat:@"%1d", self.val+1];
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	CGContextSelectFont(context, "Helvetica", 30, kCGEncodingMacRoman);
//	CGContextShowTextAtPoint(context, 30, 40, [str cStringUsingEncoding:kCGEncodingMacRoman], 1);
	[str release];
}

- (void) show
{
	[self setNeedsDisplay];
	[UIView beginAnimations:@"show" context:nil];
	[UIView setAnimationDuration:0.5];
	NSLog(@"hand frame x is %f", self.frame.origin.x);
	if (self.isOpponent)
		self.frame = CGRectOffset(self.frame, -40, 0);
	else
		self.frame = CGRectOffset(self.frame, 40, 0);
	NSLog(@"hand frame x is %f", self.frame.origin.x);
	[UIView commitAnimations];
}

- (void) hide
{
	if (self.isOpponent)
		self.frame = CGRectOffset(self.frame, 40, 0);
	else
		self.frame = CGRectOffset(self.frame, -40, 0);
	[self removeFromSuperview];
}

@end
