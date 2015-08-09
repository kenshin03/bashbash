//
//  BigBaby.m
//  bishibashi
//
//  Created by Eric on 06/07/2010.
//  Copyright 2010 Red Soldier. All rights reserved.
//

#import "BigBaby.h"


@implementation BigBaby
@synthesize head = _head;
@synthesize body = _body;
@synthesize rightfoot = _rightfoot;
@synthesize leftfoot = _leftfoot;
@synthesize eyebrow = _eyebrow;
@synthesize leftear = _leftear;
@synthesize rightear = _rightear;
@synthesize worm = _worm;
@synthesize face = _face;
@synthesize background = _background;
@synthesize face2 = _face2;

static const CGRect bodyRectP = {{0, 0}, {200, 260}};
static const CGRect leftfootRectP = {{13, 280}, {97, 83}};
static const CGRect rightfootRectP = {{150, 240}, {97, 93}};
static const CGRect eyebrowRectP = {{101, 70}, {60, 5}};
static const CGRect eyebrowCustomRectP = {{101, 55}, {60, 5}};
static const CGRect rightearRectP = {{47, 33}, {40, 40}};
static const CGRect faceRectP = {{108, 35}, {85,90}}; 
static const CGRect face2RectP = {{103, 35}, {85,90}}; 

static const CGRect faceRectI = {{92, 27}, {78,80}}; 
static const CGRect face2RectI = {{88, 27}, {78,80}}; 
static const CGRect faceCustomRectP = {{70, 10}, {170,165}}; 
static const CGRect face2CustomRectP = {{65, 10}, {170,165}}; 
static const CGRect faceCustomRectI = {{60, 4}, {150,145}}; 
static const CGRect face2CustomRectI = {{55, 4}, {150,145}}; 
	
	
- (id) initWithFrame:(CGRect)frame AndOrientation:(UIInterfaceOrientation) orientation
{
	if (self=[super initWithFrame:frame])	{
		CGRect theFrame = CGRectMake(0,0,frame.size.width, frame.size.height);
		
		NSArray* inGameImages = [LocalStorageManager getGameImagesInUse];
		UIImageView *face, *face2;
		
		UIImageView* eyebrow = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingeyebrowsmoveup" ofType:@"png"]]];
		self.eyebrow = eyebrow;
		[eyebrow release];
		self.eyebrow.frame = theFrame;
		[self.eyebrow setHidden:YES];
		
		if (inGameImages)	{
			face = [[UIImageView alloc] initWithImage:[inGameImages objectAtIndex:0]];
			face2 = [[UIImageView alloc] initWithImage:[inGameImages objectAtIndex:0]];
			if (orientation == 11)	{
				face.frame = faceCustomRectI;
				face2.frame = face2CustomRectI;
			} else {
				face.frame = faceCustomRectP;
				face2.frame = face2CustomRectP;
			}
			
			self.eyebrow = nil;
//			UIImage* tmp = [inGameImages objectAtIndex:0];
//			UIImageView* eyebrow = [[UIImageView alloc] initWithImage:tmp];
//			UIImageView* eyebrow = [[UIImageView alloc] initWithImage:[tmp imageCroppedToRect:CGRectMake(10, 20, 65, 20)]];
//			self.eyebrow = eyebrow;
//			self.eyebrow.frame = eyebrowCustomRectP;
//			[eyebrow release];
//			[self.eyebrow setHidden:YES];
//			self.eyebrow.frame = CGRectMake(self.eyebrow.frame.origin.x, self.eyebrow.frame.origin.y-10, self.eyebrow.frame.size.width, self.eyebrow.frame.size.height);
		}
		else{
			face = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingface" ofType:@"png"]]];
			face2 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingface" ofType:@"png"]]];
			if (orientation == 11)	{
				face.frame = faceRectI;
				face2.frame = face2RectI;
			} else {
				face.frame = faceRectP;
				face2.frame = face2RectP;
			}
			
			UIImageView* eyebrow = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingeyebrowsmoveup" ofType:@"png"]]];
			self.eyebrow = eyebrow;
			[eyebrow release];
			self.eyebrow.frame = theFrame;
			[self.eyebrow setHidden:YES];
		}
		self.face = face;
		[face release];
		[self addSubview:self.face];
		self.face2 = face2;
		[face2 release];
		[self.face2 setHidden:YES];
		
		UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingbackground" ofType:@"png"]]];
		self.background = background;
		[background release];
		self.background.frame = theFrame;
		[self addSubview:self.background];
		
		[self addSubview:self.face2];

		[self addSubview:self.eyebrow];

		UIImageView* body = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingbodymove" ofType:@"png"]]];
		self.body = body;
		[body release];
		self.body.frame = theFrame;
		[self.body setHidden:YES];
		[self addSubview:self.body];

		UIImageView* leftfoot = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingleftfoot" ofType:@"png"]]];
		self.leftfoot = leftfoot;
		[leftfoot release];
		self.leftfoot.frame = theFrame;
		[self.leftfoot setHidden:YES];
		[self addSubview:self.leftfoot];

		UIImageView* rightfoot = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingrightfoot" ofType:@"png"]]];
		self.rightfoot = rightfoot;
		[rightfoot release];
		self.rightfoot.frame = theFrame;
		[self.rightfoot setHidden:YES];
		[self addSubview:self.rightfoot];

		UIImageView* rightear = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingrightear" ofType:@"png"]]];
		self.rightear = rightear;
		[rightear release];
		self.rightear.frame =theFrame;
		[self.rightear setHidden:YES];
		[self addSubview:self.rightear];

		UIImageView* leftear = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancingleftear" ofType:@"png"]] ];
		self.leftear = leftear;
		[leftear release];
		self.leftear.frame =theFrame;
		[self.leftear setHidden:YES];
		[self addSubview:self.leftear];
				
		UIImageView* worm = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"dancinglongerworm" ofType:@"png"]]];
		self.worm = worm;
		[worm release];
		self.worm.frame = theFrame;
		[self.worm setHidden:YES];
		[self addSubview:self.worm];
		
	}
	return self;
}

- (void) move
{
	[UIView beginAnimations:@"babymove" context:nil];
	[UIView setAnimationDuration:0.08];
	[UIView setAnimationDelegate:self];
	if (arc4random()%2==0)	{
		[self.body setHidden:NO];
		self.body.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		if (arc4random()%2==0)	{
			[self.eyebrow setHidden:NO];
			if ([LocalStorageManager getGameImagesInUse])
				self.eyebrow.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(-1.0,-6.0), 1.3, 1.3);		
			else
				self.eyebrow.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		}
		[self.face2 setHidden:NO];
		self.face2.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		[self.worm setHidden:NO];
		self.worm.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		if (arc4random()%2==0)	{
			[self.leftear setHidden:NO];
			self.leftear.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		}
		if (arc4random()%2==0)	{
			[self.rightear setHidden:NO];
			self.rightear.transform = CGAffineTransformMakeTranslation(1.0,1.0);
		}
	}
	if (arc4random()%2==0)	{
		[self.leftfoot setHidden:NO];
		self.leftfoot.transform = CGAffineTransformMakeTranslation(1.0,1.0);
	}
	if (arc4random()%2==0)	{
		[self.rightfoot setHidden:NO];
		self.rightfoot.transform = CGAffineTransformMakeTranslation(1.0,1.0);
	}
	
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
	if ([animationID isEqualToString:@"babymove"])	{
		[UIView beginAnimations:@"babyrestore" context:nil];
		[UIView setAnimationDuration:0.08];
		[UIView setAnimationDelegate:self];
		[self.eyebrow setHidden:YES];
		[self.rightear setHidden:YES];
		[self.rightfoot setHidden:YES];
		[self.leftfoot setHidden:YES];
		[self.leftear setHidden:YES];
		[self.body setHidden:YES];
		[self.worm setHidden:YES];
		[self.face2 setHidden:YES];
		self.body.transform = CGAffineTransformMakeTranslation(0.0,0.0);
		self.face2.transform = CGAffineTransformMakeTranslation(0.0,0.0);

		self.eyebrow.transform = CGAffineTransformMakeTranslation(0.0,0.0);
		self.worm.transform = CGAffineTransformMakeTranslation(0.0,0.0);
		self.leftfoot.transform = CGAffineTransformMakeTranslation(0,0);
		self.leftear.transform = CGAffineTransformMakeTranslation(0,0);
		self.rightfoot.transform = CGAffineTransformMakeTranslation(0,0);
		self.rightear.transform = CGAffineTransformMakeTranslation(0,0);
		[UIView commitAnimations];
	}
}	


- (void) dealloc
{
	NSLog(@"dealloc BigBaby");
	self.background = nil;
	self.face = nil;
	self.face2 = nil;
	self.worm = nil;
	self.head = nil;
	self.body = nil;
	self.rightfoot = nil;
	self.leftfoot = nil;
	self.eyebrow = nil;
	self.rightear = nil;
	self.leftear = nil;
	[super dealloc];
}


@end
