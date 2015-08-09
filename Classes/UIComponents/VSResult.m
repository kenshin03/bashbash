//
//  VSResult.m
//  bishibashi
//
//  Created by Eric on 09/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "VSResult.h"


@implementation VSResult
//@synthesize text = _text;
@synthesize image = _image;
@synthesize winImage = _winImage;
@synthesize isWin = _isWin;

const static CGRect winRect = {{90, 5}, {40, 40}};

-(void) setTime:(float) time
{
	self.backgroundColor = [UIColor darkGrayColor];
	if (time>0.0)	{
		self.isWin = YES;
//		self.image = [UIImage imageNamed:@"OK.png"];
		self.text = [NSString stringWithFormat:@"%1.3fS", time];
		NSLog(@"vsResult text is %@", self.text);
	}
	else	{
		self.isWin = NO;
		self.text = @"FAIL";
		NSLog(@"vsResult text is %@", self.text);

/*		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,60,50,50)];
		imgView.image = [UIImage imageNamed:@"cross.png"];
		[self addSubview:imgView];
		[imgView release];
//		self.image = [UIImage imageNamed:@"cross.png"];
		self.text = nil;
 */
	}
}

-(id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])	{
		self.font = [UIFont boldSystemFontOfSize:24];
		self.backgroundColor = [UIColor darkGrayColor];
		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.alpha = 0.8;
	}
	return self;
}

-(void) setWin
{
	self.backgroundColor = [UIColor blackColor];
	/*
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"win" ofType:@"png"]]];
	tmpView.frame = winRect;
	self.winImage = tmpView;
	[self addSubview:tmpView];
	[tmpView release];
	self.backgroundColor = [UIColor lightGrayColor];
	 */
}
/*
-(void)drawRect:(CGRect)rect	{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode (UIGraphicsGetCurrentContext(), kCGBlendModeDarken);
	[self.image drawInRect:CGRectMake(0,60,50,50)];
	if (self.text)	{
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
		CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
		
		CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
		CGContextSetTextDrawingMode(context, kCGTextFillStroke);
		CGContextSelectFont(context, "Helvetica", 32, kCGEncodingMacRoman);
		CGContextShowTextAtPoint(context, 15, 15, [self.text cStringUsingEncoding:kCGEncodingMacRoman], 5);
	}
	[super drawRect:rect];
}
*/
- (void) show
{
	self.backgroundColor = [UIColor clearColor];
//	[[MediaManager sharedInstance] playStarSound];
	[UIView beginAnimations:@"show2" context:nil];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationDelegate:self];
	self.alpha = 0.8;
	[UIView commitAnimations];
}

-(void) dismiss
{
	[UIView beginAnimations:@"dismiss" context:nil];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationDelegate:self];
	self.alpha = 0.0;
	[self.winImage removeFromSuperview];
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self setNeedsDisplay];
	if ([animationID isEqualToString:@"show"])	{
		[UIView beginAnimations:@"dismiss" context:nil];
		[UIView setAnimationDuration:2];
		[UIView setAnimationDelegate:self];
		self.alpha = 0.0;
		[UIView commitAnimations];
	}
	else if ([animationID isEqualToString:@"dismiss"])	{
		[self removeFromSuperview];
	}
}

- (void) dealloc
{
	self.winImage = nil;
	self.text = nil;
	self.image = nil;
	[super dealloc];
}

@end
