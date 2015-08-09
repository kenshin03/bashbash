//
//  PieChartView.m
//  bishibashi
//
//  Created by Eric on 03/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieChartView.h"


@implementation PieChartView

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@synthesize maxVal = _maxVal;
@synthesize curVal = _curVal;


- (id) initWithFrame:(CGRect)frame AndMaxVal:(float)maxVal
{
	self = [super initWithFrame:frame];
	self.backgroundColor=[UIColor clearColor];
	self.maxVal = maxVal;
	self.curVal = 0.0;
	return self;
}

- (void) setCurVal:(float)curVal	{
	_curVal = curVal;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGRect parentViewBounds = self.bounds;
	CGFloat x = CGRectGetWidth(parentViewBounds)/2;
	CGFloat y = CGRectGetHeight(parentViewBounds)/2;
	
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(ctx, 5);

	CGContextMoveToPoint(ctx, x, y);     
    CGContextAddArc(ctx, x, y, x-2.5,  radians(-90), radians((360.0*self.curVal/self.maxVal)-90.0), 0); 
    CGContextClosePath(ctx); 
	CGContextStrokePath(ctx);

	CGContextSetRGBFillColor(ctx, 0.0, 1.0, 0.0, 0.9);
//	CGContextSetGrayFillColor(ctx, 0.5, 1.0);
	CGContextMoveToPoint(ctx, x, y);     
    CGContextAddArc(ctx, x, y, x-2.5,  radians(-90), radians((360.0*self.curVal/self.maxVal)-90.0), 0); 
    CGContextClosePath(ctx); 
    CGContextFillPath(ctx);	

}