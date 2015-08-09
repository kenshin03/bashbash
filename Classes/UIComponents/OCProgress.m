//
//  OCProgress.m
//  ProgressView
//
//  Created by Brian Harmann on 7/24/09.
//  Copyright 2009 Obsessive Code. All rights reserved.
//

#import "OCProgress.h"


@implementation OCProgress

@synthesize  minValue, maxValue, currentValue;
@synthesize lineColor, progressRemainingColor, progressColor;
@synthesize score= _score;
@synthesize isMyself = _isMyself;
@synthesize nameLbl = _nameLbl;
@synthesize name = _name;
@synthesize isSingleMode = _isSingleMode;

- (id)initWithFrame:(CGRect)frame ForMyself:(BOOL)isMyself AsSingleMode:(BOOL)isSingleMode{
    if (self = [super initWithFrame:frame]) {
		self.isSingleMode = isSingleMode;
		minValue = 0;
		maxValue = 1;
		currentValue = 0;
		self.backgroundColor = [UIColor clearColor];
		
		UILabel* tmp;
		if (isMyself)
			if (isSingleMode)
				tmp = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-30,0,30,18)];
			else
				tmp = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-20,0,28,18)];
		else
			tmp = [[UILabel alloc] initWithFrame:CGRectMake(-3,0,28,18)];
		tmp.backgroundColor = [UIColor clearColor];
		tmp.text = @"0";
		tmp.textColor = [UIColor whiteColor];
		tmp.font = [UIFont systemFontOfSize:15];
		[self addSubview:tmp];
		self.score = tmp;
		[tmp release];
		
		if (isMyself)	{
			tmp = [[UILabel alloc] initWithFrame:CGRectMake(5,self.frame.size.height,self.frame.size.width,16)];
			tmp.textColor = [UIColor redColor];
		}
		else	{
			tmp = [[UILabel alloc] initWithFrame:CGRectMake(15,self.frame.size.height,self.frame.size.width,16)];
			tmp.textColor = [UIColor blueColor];
		}
		tmp.backgroundColor = [UIColor clearColor];
		tmp.text = @"";
		tmp.font = [UIFont boldSystemFontOfSize:14];
		[self addSubview:tmp];
		self.nameLbl = tmp;
		[tmp release];
		
		
		lineColor = [[UIColor whiteColor] retain];
		progressColor = [[UIColor redColor] retain];
		progressRemainingColor = [[UIColor lightGrayColor] retain];
		
		self.isMyself=isMyself;
    }
    return self;
}

- (void) setName:(NSString*) name
{
	_name = name;
	self.nameLbl.text = name;
}

- (void) setFrame:(CGRect)frame AsSingleMode:(BOOL)isSingleMode
{
	self.isSingleMode = isSingleMode;
	[super setFrame:frame];
	if (self.isMyself)
		if (isSingleMode)
			self.score.frame = CGRectMake(self.frame.size.width-30,0,30,18);			
		else
			self.score.frame = CGRectMake(self.frame.size.width-20,0,20,18);
	else
		self.score.frame = CGRectMake(0,0,20,18);
}


- (void)drawRect:(CGRect)rect {
	if (self.isSingleMode)
		rect.size.width -= 30;
	else
		rect.size.width -= 20;
	float xoffset;
	if (self.isMyself)
		xoffset = 0;
	else 
		xoffset = 20;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2);
	
	CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
	CGContextSetFillColorWithColor(context, [[progressRemainingColor colorWithAlphaComponent:.7] CGColor]);

	
	float radius = (rect.size.height / 2) - 2 ; /* 16 is for showing name */
	CGContextMoveToPoint(context, xoffset+2, rect.size.height/2);

	CGContextAddArcToPoint(context, xoffset+2, 2, xoffset+radius + 2, 2, radius);
	CGContextAddLineToPoint(context, xoffset+rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, xoffset+rect.size.width - 2, 2, xoffset+rect.size.width - 2, rect.size.height / 2, radius);
	CGContextFillPath(context);
	
	CGContextSetFillColorWithColor(context, [progressRemainingColor CGColor]);

	CGContextMoveToPoint(context, xoffset+rect.size.width - 2, rect.size.height/2);
	CGContextAddArcToPoint(context, xoffset+rect.size.width - 2, rect.size.height - 2, xoffset+rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, xoffset+radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, xoffset+2, rect.size.height - 2, xoffset+2, rect.size.height/2, radius);
	CGContextFillPath(context);
	
	
	CGContextMoveToPoint(context, xoffset+2, rect.size.height/2);
	
	CGContextAddArcToPoint(context, xoffset+2, 2, xoffset+radius + 2, 2, radius);
	CGContextAddLineToPoint(context, xoffset+rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, xoffset+rect.size.width - 2, 2, xoffset+rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, xoffset+rect.size.width - 2, rect.size.height - 2, xoffset+rect.size.width - radius - 2, rect.size.height - 2, radius);
	
	CGContextAddLineToPoint(context, xoffset+radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, xoffset+2, rect.size.height - 2, xoffset+2, rect.size.height/2, radius);
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, [[progressColor colorWithAlphaComponent:.78] CGColor]);

	radius = radius - 2;
	CGContextMoveToPoint(context, xoffset+4, rect.size.height/2);
	float amount = (currentValue/(maxValue - minValue)) * (rect.size.width);
	
	if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
		CGContextAddArcToPoint(context, xoffset+4, 4, xoffset+radius + 4, 4, radius);
		CGContextAddLineToPoint(context, xoffset+amount, 4);
		//CGContextAddLineToPoint(context, amount, radius + 4);
		CGContextAddArcToPoint(context, xoffset+amount + radius + 4, 4,  xoffset+amount + radius + 4, rect.size.height/2, radius);

		CGContextFillPath(context);
		
		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
		CGContextMoveToPoint(context, xoffset+4, rect.size.height/2);
		CGContextAddArcToPoint(context, xoffset+4, rect.size.height - 4, xoffset+radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, xoffset+amount, rect.size.height - 4);
		CGContextAddArcToPoint(context, xoffset+amount + radius + 4, rect.size.height - 4,  xoffset+amount + radius + 4, rect.size.height/2, radius);
		//CGContextAddLineToPoint(context, amount, radius + 4);
		CGContextFillPath(context);
	} else if (amount > radius + 4) {
		CGContextAddArcToPoint(context, xoffset+4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, xoffset+rect.size.width - radius - 4, 4);
		CGContextAddArcToPoint(context, xoffset+rect.size.width - 4, 4, xoffset+rect.size.width - 4, rect.size.height/2, radius);
		CGContextFillPath(context);
		
		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
		CGContextMoveToPoint(context, xoffset+4, rect.size.height/2);
		CGContextAddArcToPoint(context, xoffset+4, rect.size.height - 4, xoffset+radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, xoffset+rect.size.width - radius - 4, rect.size.height - 4);
		CGContextAddArcToPoint(context, xoffset+rect.size.width - 4, rect.size.height - 4, xoffset+rect.size.width - 4, rect.size.height/2, radius);
		CGContextFillPath(context);
	} else if (amount < radius + 4 && amount > 0) {
		CGContextAddArcToPoint(context, xoffset+4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, xoffset+radius + 4, rect.size.height/2);
		CGContextFillPath(context);
		
		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
		CGContextMoveToPoint(context, xoffset+4, rect.size.height/2);
		CGContextAddArcToPoint(context, xoffset+4, rect.size.height - 4, xoffset+radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, xoffset+radius + 4, rect.size.height/2);
		CGContextFillPath(context);
	}
	
	
}

-(void)setNewRect:(CGRect)newFrame 
{
	self.frame = newFrame;
	[self setNeedsDisplay];

}

-(void)setMinValue:(float)newMin
{
	minValue = newMin;
	[self setNeedsDisplay];

}

-(void)setMaxValue:(float)newMax
{
	maxValue = newMax;
	[self setNeedsDisplay];

}

-(void)setCurrentValue:(float)newValue
{
	currentValue = newValue;
	NSString* tmp = [[NSString alloc] initWithFormat:@"%.0f", newValue];
	self.score.text = tmp;
	[tmp release];
	[self setNeedsDisplay];
}

-(void)setLineColor:(UIColor *)newColor
{
	[newColor retain];
	[lineColor release];
	lineColor = newColor;
	[self setNeedsDisplay];

}

-(void)setProgressColor:(UIColor *)newColor
{
	self.nameLbl.textColor = newColor;
	[newColor retain];
	[progressColor release];
	progressColor = newColor;
	[self setNeedsDisplay];

}

-(void)setProgressRemainingColor:(UIColor *)newColor
{
	[newColor retain];
	[progressRemainingColor release];
	progressRemainingColor = newColor;
	[self setNeedsDisplay];

}

- (void)dealloc {
	[lineColor release];
	[progressColor release];
	[progressRemainingColor release];
	self.score = nil;
	self.name = nil;
	self.nameLbl = nil;
    [super dealloc];
}


@end
