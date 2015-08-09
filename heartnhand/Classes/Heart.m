//
//  Heart.m
//  bishibashi
//
//  Created by Eric on 12/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "Heart.h"


@implementation Heart
@synthesize val = _val;
@synthesize image = _image;


-(id) initWithFrame:(CGRect) rect
{
	if (self = [super initWithFrame:rect])	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;	
		self.image = [UIImage imageNamed:@"heart.png"];
	}
	return self;
}

-(void) setVal:(int) val
{
	_val = val;
	[self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetBlendMode (UIGraphicsGetCurrentContext(), kCGBlendModeDarken);
	[self.image drawInRect:rect];
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
	
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	NSString* str= [[NSString alloc] initWithFormat:@"%1d", self.val+1];
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	const char* buffer = [str cStringUsingEncoding:kCGEncodingMacRoman];
	CGContextSelectFont(context, "Helvetica", 40, kCGEncodingMacRoman);
	CGContextShowTextAtPoint(context, 17, 38, [str cStringUsingEncoding:kCGEncodingMacRoman], 1);
	
	[str release];
}

- (void) dealloc
{
	self.image = nil;
}

@end
