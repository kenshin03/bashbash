//
//  Baby.m
//  bishibashi
//
//  Created by Eric on 28/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Baby.h"


@implementation Baby
@synthesize color = _color;
@synthesize face = _face;
@synthesize cloth = _cloth;
@synthesize orientation = _orientation;
@synthesize cryingface = _cryingface;
@synthesize openmouthface = _openmouthface;

- (id)initWithFrame:(CGRect)frameRect AndColor:(ButState)color AndOrientation:(UIInterfaceOrientation)orientation
{
    self = [super initWithFrame:frameRect];
	self.orientation = orientation;
	self.color = color;
	[self initImages];
    return self;
}


- (void) dealloc	{
	NSLog(@"dealloc Baby");
	self.face = nil;
	self.cloth = nil;
	self.cryingface = nil;
	self.openmouthface = nil;
	[super dealloc];
}


-(void) initImages
{
	NSArray* inGameImages = [LocalStorageManager getGameImagesInUse];
	UIImageView *face, *cryingface, *openmouthface;
	if (!inGameImages)	{
		face = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"closemonthbaby" ofType:@"png"]]];
		cryingface = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"cryingbaby" ofType:@"png"]]];
		openmouthface = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"baby" ofType:@"png"]]];
	}	
	else {
		face = [[UIImageView alloc] initWithImage:[inGameImages objectAtIndex:0]];
		cryingface = [[UIImageView alloc] initWithImage:[inGameImages objectAtIndex:2]];
		openmouthface = [[UIImageView alloc] initWithImage:[inGameImages objectAtIndex:1]];
	}

	self.face = face;
	self.face.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	[face release];
//	self.face.frame = self.frame;
	[self addSubview:self.face];
	
	self.cryingface = cryingface;
	self.cryingface.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	[cryingface release];
//	self.cryingface.frame = self.frame;
	[self addSubview:self.cryingface];
	[self.cryingface setHidden:YES];
	
	self.openmouthface = openmouthface;
	self.openmouthface.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	[openmouthface release];
//	self.openmouthface.frame = self.frame;
	[self addSubview:self.openmouthface];
	[self.openmouthface setHidden:YES];
	
	
	UIImageView* cloth;
	switch (self.color)	{
		case (kRed):
			cloth = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bear" ofType:@"png"]]];
			break;
		case (kGreen):
			cloth = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"frog" ofType:@"png"]]];
			break;
		case (kBlue):
			cloth = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"tiger" ofType:@"png"]]];
			break;
	}
	self.cloth = cloth;
	self.cloth.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	[cloth release];
//	self.cloth.frame = self.frame;
	[self addSubview: self.cloth];
}	

-(void) moveUp
{
	[UIView beginAnimations:@"moveup" context:nil];
	[UIView setAnimationDuration:0.05];
	switch(self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-70, self.frame.size.width, self.frame.size.height)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-70, self.frame.size.width, self.frame.size.height)];
			break;
		case (10):
		case (11):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-35, self.frame.size.width, self.frame.size.height)];
			break;
	}	
	[UIView commitAnimations];
	
}

- (void) moveDown
{
	[UIView beginAnimations:@"moveup" context:nil];
	[UIView setAnimationDuration:0.1];
	switch(self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+70, self.frame.size.width, self.frame.size.height)];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+70, self.frame.size.width, self.frame.size.height)];
			break;
		case (10):
		case (11):
			[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+35, self.frame.size.width, self.frame.size.height)];
			break;
	}	
	[UIView commitAnimations];
}

- (void) beanCome:(ButState) beanState
{
	if (self.color == beanState)
		[UIView beginAnimations:@"beanCome" context:nil];
	else {
		[UIView beginAnimations:@"beanNotCome" context:nil];
	}
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];

	if (self.color == beanState){
		[self.openmouthface setHidden:NO];
		[self.face setHidden:YES];
//		self.face.image = [UIImage imageNamed:@"baby.png"];
		self.cloth.transform = CGAffineTransformMakeRotation(-0.05);
		self.face.transform = CGAffineTransformMakeRotation(-0.05);
	}
	else	{
		[self.cryingface setHidden:NO];
		[self.face setHidden:YES];
//		self.face.image = [UIImage imageNamed:@"cryingbaby.png"];
		self.cloth.transform = CGAffineTransformMakeTranslation(0,0.1);
		self.face.transform = CGAffineTransformMakeTranslation(0,0.1);
	}
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"beanCome"])	{
		self.cloth.transform = CGAffineTransformMakeRotation(0.05);
		self.face.transform = CGAffineTransformMakeRotation(0.05);
		[UIView beginAnimations:@"finishedBeanCome" context:nil];
		[UIView setAnimationDuration:0.05];
		[UIView setAnimationDelegate:self];
		[self.openmouthface setHidden:YES];
		[self.face setHidden:NO];

//		self.face.image = [UIImage imageNamed:@"closemonthbaby.png"];
		self.cloth.transform = CGAffineTransformMakeRotation(0.0);
		self.face.transform = CGAffineTransformMakeRotation(0.0);
		[UIView commitAnimations];
	}
	else if ([animationID isEqualToString:@"beanNotCome"])	{
		[UIView beginAnimations:@"finishedBeanCome" context:nil];
		[UIView setAnimationDuration:0.05];
		[UIView setAnimationDelegate:self];
		[self.cryingface setHidden:YES];
		[self.face setHidden:NO];
//		self.face.image = [UIImage imageNamed:@"closemonthbaby.png"];
		self.cloth.transform = CGAffineTransformMakeRotation(0.0);
		self.face.transform = CGAffineTransformMakeRotation(0.0);
		[UIView commitAnimations];
	}
	
}

- (void) changeToOpenMouth:(UIImage*) image
{
	if (image)
		self.openmouthface.image = image;
	[self.openmouthface setHidden:NO];
	[self.cryingface setHidden:YES];
	[self.face setHidden:YES];
}

- (void) changeToCrying:(UIImage*) image
{
	if (image)
		self.cryingface.image = image;
	[self.cryingface setHidden:NO];
	[self.openmouthface setHidden:YES];
	[self.face setHidden:YES];
}
- (void) changeToNormal:(UIImage*) image
{
	if (image)
		self.face.image = image;
	[self.face setHidden:NO];
	[self.cryingface setHidden:YES];
	[self.openmouthface setHidden:YES];
}

@end
