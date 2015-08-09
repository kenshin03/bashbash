//
//  ExpandBox.m
//  bishibashi
//
//  Created by Eric on 31/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "ExpandBox.h"


@implementation ExpandBox
@synthesize thePin = _thePin;
@synthesize upper = _upper;
@synthesize lower = _lower;
@synthesize theTextView =_theTextView;
@synthesize theExpandBox = _theExpandBox;
@synthesize upperoffset = _uppseroffset;
@synthesize bottomoffset = _bottomoffset;

- (id) initStartY:(float)startY WithUpper:(float)upper AndUpperOffset:(float)upperoffset AndLower:(float)lower 
		AndLowerOffset:(float)loweroffset AndUpperPins:(NSArray*)uppers AndLowerPins:(NSArray*)lowers 
		AndThePin:(UIButton*)thePin AndText1:(NSString*)text1 AndText2:(NSString*)text2 AndIsForOther:(BOOL)isOther
{
	if ((self = [super initWithFrame:CGRectMake(0,0,320,startY+lower)])) {
		self.backgroundColor = [UIColor blackColor];
		UIButton* thePinCopy = [thePin copy];
		if (isOther)
			thePinCopy.frame = CGRectOffset(thePinCopy.frame, -320, 100);			
		else
			thePinCopy.frame = CGRectOffset(thePinCopy.frame, 0, 100);
		self.thePin = thePinCopy;
	//	[thePinCopy release];
		
		self.upperoffset = upperoffset;
		self.bottomoffset = loweroffset;
		UIView* upperbox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, startY)];
		UIView* lowerbox = [[UIView alloc] initWithFrame:CGRectMake(0, startY, 320, lower)];
		upperbox.backgroundColor = [UIColor blackColor];
		lowerbox.backgroundColor = [UIColor blackColor];
		self.upper = upperbox;
		self.lower = lowerbox;
		[upperbox release];
		[lowerbox release];
		if (uppers)	{
			for (UIButton* theView in uppers)	{
				UIButton* thePinCopy = [theView copy];
				if (isOther)
					thePinCopy.frame = CGRectOffset(thePinCopy.frame, -320, 100);				
				else
					thePinCopy.frame = CGRectOffset(thePinCopy.frame, 0, 100);
				[self.upper addSubview: thePinCopy];
	//			[thePinCopy release];
			}
		}
		if (lowers)	{
			for (UIButton* theView in lowers)	{
				UIButton* thePinCopy = [theView copy];
				if (isOther)
					thePinCopy.frame = CGRectOffset(thePinCopy.frame, -320, 100-startY);
				else
					thePinCopy.frame = CGRectOffset(thePinCopy.frame, 0, 100-startY);
				[self.lower addSubview: thePinCopy];
	//			[thePinCopy release];
			}
		}
		UIView* upcover = [[UIView alloc] initWithFrame:self.upper.frame];
		UIView* lowercover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, lower)];
		upcover.backgroundColor = [UIColor whiteColor];
		lowercover.backgroundColor = [UIColor whiteColor];
		upcover.alpha = 0.7;
		lowercover.alpha = 0.7;
		
		[self.upper addSubview:upcover];
		[self.lower addSubview:lowercover];
		[upcover release];
		[lowercover release];
		
		UIImageView* theExpandBox = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expandbox" ofType:@"png"]]]; 
		self.theExpandBox = theExpandBox;
		self.theExpandBox.frame = CGRectMake(0, startY-upperoffset, 320, 200);
		[theExpandBox release];
		UITextView* theTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,15,theExpandBox.frame.size.width, theExpandBox.frame.size.height)];
		self.theTextView = theTextView;
		[theTextView release];
		self.theTextView.backgroundColor = [UIColor clearColor];
		self.theTextView.font = [UIFont systemFontOfSize:16];
		self.theTextView.text = [NSString stringWithFormat:@"%@\n\n%@", text1, text2];
		self.theTextView.textColor = [UIColor whiteColor];
		[self.theExpandBox addSubview:self.theTextView];
		
		[self addSubview:self.theExpandBox];
		[self addSubview:self.upper];
		[self addSubview:self.lower];
		
		[self.upper addSubview:self.thePin];
		[self.thePin addTarget:self action:@selector(compress) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void) expand
{
	[UIView beginAnimations:@"expand" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1];
	
	self.upper.frame = CGRectOffset(self.upper.frame, 0, -self.upperoffset);
	self.lower.frame = CGRectOffset(self.lower.frame, 0, self.bottomoffset);
	
	[UIView commitAnimations];
}

- (void) compress
{
	[UIView beginAnimations:@"compress" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1];
	
	self.upper.frame = CGRectOffset(self.upper.frame, 0, self.upperoffset);
	self.lower.frame = CGRectOffset(self.lower.frame, 0, -self.bottomoffset);
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"compress"])	{
		[self.theExpandBox removeFromSuperview];
		[self.upper removeFromSuperview];
		[self.lower removeFromSuperview];
		[self removeFromSuperview];
	}
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	self.thePin = nil;
	self.upper = nil;
	self.lower = nil;
	self.theTextView = nil;
	self.theExpandBox = nil;
    [super dealloc];
}


@end

@implementation UIButton(Extension)

- (id) copyWithZone:(NSZone*)zone
{
	id result = [UIButton buttonWithType:UIButtonTypeCustom];
	[result setBackgroundImage:[self backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
	[result setFrame:self.frame];
	return result;	
}
