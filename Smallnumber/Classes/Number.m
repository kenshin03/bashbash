//
//  Number.m
//  bishibashi
//
//  Created by Eric on 24/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Number.h"


@implementation Number
@synthesize no = _no;
@synthesize color = _color;
@synthesize pos = _pos;
@synthesize orientation = _orientation;
@synthesize image = _image;

static const CGRect startRectP = {{20, 0}, {80, 40}};
static const CGRect startRectL = {{20, 0}, {80, 23}};
static const CGRect startRectR = {{15, 0}, {40, 23}};
static const CGRect startRectI = {{10, 0}, {70, 25}};

-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetBlendMode (UIGraphicsGetCurrentContext(), kCGBlendModeDarken);
	[self.image drawInRect:rect];
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	NSString* str= [[NSString alloc] initWithFormat:@"%2d", self.no];
	CGContextSetTextDrawingMode(context, kCGTextFillStroke);
	const char* buffer = [str cStringUsingEncoding:kCGEncodingMacRoman];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			CGContextSelectFont(context, "Helvetica", 24, kCGEncodingMacRoman);
			CGContextShowTextAtPoint(context, 19, 20, [str cStringUsingEncoding:kCGEncodingMacRoman], 2);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
		case (11):
			CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
			CGContextShowTextAtPoint(context, 23, 14, [str cStringUsingEncoding:kCGEncodingMacRoman], 2);
			break;
		case (10):
			CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
			CGContextShowTextAtPoint(context, 9, 14, [str cStringUsingEncoding:kCGEncodingMacRoman], 2);
			break;
	}
	[str release];
}

-(id) initWithNo:(int) no AndColor:(ButState)color AndPos:(int)pos AndOrientation:(UIInterfaceOrientation) orientation
{
	self.orientation = orientation;
	NSString* str;
	switch(color)	{
		case (kRed):
			str = [[NSString alloc] initWithFormat:@"boc%d", pos+1];
			self.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
			[str release];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					self = [super initWithFrame:startRectP];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					self = [super initWithFrame:startRectL];
					break;
				case (10):
					self = [super initWithFrame:startRectR];
					break;
				case (11):
					self = [super initWithFrame:startRectI];
					break;
			}
			break;
		case (kGreen):
			str = [[NSString alloc] initWithFormat:@"hsbc%d", pos+1];
			self.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
			[str release];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					self = [super initWithFrame:startRectP];
					self.frame = CGRectMake(self.frame.origin.x+100,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					self = [super initWithFrame:startRectL];
					self.frame = CGRectMake(self.frame.origin.x+100,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (10):
					self = [super initWithFrame:startRectR];
					self.frame = CGRectMake(self.frame.origin.x+50,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (11):
					self = [super initWithFrame:startRectI];
					self.frame = CGRectMake(self.frame.origin.x+80,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
			}
			break;
		case (kBlue):
			str = [[NSString alloc] initWithFormat:@"ifc%d", pos+1];
			self.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
			[str release];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					self = [super initWithFrame:startRectP];
					self.frame = CGRectMake(self.frame.origin.x+200,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					self = [super initWithFrame:startRectL];
					self.frame = CGRectMake(self.frame.origin.x+200,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (10):
					self = [super initWithFrame:startRectR];
					self.frame = CGRectMake(self.frame.origin.x+100,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
				case (11):
					self = [super initWithFrame:startRectI];
					self.frame = CGRectMake(self.frame.origin.x+160,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
					break;
			}
			break;
	}
	self.backgroundColor = [UIColor clearColor];
	self.opaque = YES;
	self.clearsContextBeforeDrawing = YES;	
			
	self.no = no;
	self.color = color;
	self.pos = pos;

	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			self.frame = CGRectMake(self.frame.origin.x, 358-self.pos*self.frame.size.height, self.frame.size.width,self.frame.size.height);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
		case (10):
			self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*self.frame.size.height, self.frame.size.width,self.frame.size.height);
			break;
		case (11):
			self.frame = CGRectMake(self.frame.origin.x, 218-self.pos*self.frame.size.height, self.frame.size.width,self.frame.size.height);
			break;
	}
	
	return self;
}

- (void) dealloc{
	NSLog(@"dealloc Number");
	self.image = nil;
	[super dealloc];
}


- (void) show
{
	if (self.pos==8)	{
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = CGRectMake(self.frame.origin.x, 358-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
			case (10):
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = CGRectMake(self.frame.origin.x, 218-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
		}
	}
	self.pos--;
	if (self.pos <8)	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1];
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				self.frame = CGRectMake(self.frame.origin.x, 358-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
			case (10):
				self.frame = CGRectMake(self.frame.origin.x, 200-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
			case (11):
				self.frame = CGRectMake(self.frame.origin.x, 218-self.pos*self.frame.size.height, self.frame.size.width, self.frame.size.height);
				break;
		}
		[UIView commitAnimations];
	}
}	

- (void) dispose 
{
	[UIView beginAnimations:@"end" context:nil];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];	
	[UIView setAnimationDuration:0.05];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[self.superview bringSubviewToFront:self];
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
		case (11):
			self.frame = CGRectMake(arc4random()%200, 160-arc4random()%70, 240,120);
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
		case (10):
			self.frame = CGRectMake(arc4random()%200, 100-arc4random()%70, 240,120);
			break;
	}
	

	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"end"])	{
		[self removeFromSuperview];
	}
}

@end
