//
//  chip.m
//  bishibashi
//
//  Created by Eric on 19/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Chip.h"


@implementation Chip
@synthesize leftImg = _leftImg;
@synthesize centerImg = _centerImg;
@synthesize rightImg = _rightImg;

@synthesize leftHeadImg = _leftHeadImg;
@synthesize centerHeadImg = _centerHeadImg;
@synthesize rightHeadImg = _rightHeadImg;

@synthesize leftHandUpImg = _leftHandUpImg;
@synthesize leftHandDownImg = _leftHandDownImg;
@synthesize rightHandDownImg = _rightHandDownImg;
@synthesize rightHandUpImg = _rightHandUpImg;
@synthesize state = _state;

@synthesize soundFileURLRef;
@synthesize soundFileObject;


@synthesize mouthPopSoundRef;
@synthesize mouthPopSoundFileObject;

@synthesize orientation = _orientation;


static const CGRect headRectP = {{20, 35}, {140, 110}};
static const CGRect headRectL = {{20, 24}, {140, 70}};
static const CGRect headRectR = {{10, 24}, {70, 70}};

static const CGRect leftHeadRectP = {{10, 40}, {140, 105}};
static const CGRect leftHeadRectL = {{10, 26}, {140, 70}};
static const CGRect leftHeadRectR = {{5, 26}, {70, 70}};

static const CGRect centerHeadRectP = {{30, 40}, {140, 105}};
static const CGRect centerHeadRectL = {{30, 26}, {140, 70}};
static const CGRect centerHeadRectR = {{15, 26}, {70, 70}};

static const CGRect rightHeadRectP = {{20, 40}, {140, 105}};
static const CGRect rightHeadRectL = {{20, 26}, {140, 70}};
static const CGRect rightHeadRectR = {{10, 26}, {70, 70}};


static const CGRect bodyRectP = {{0, 0}, {180, 250}};
static const CGRect bodyRectL = {{0, 0}, {180, 170}};
static const CGRect bodyRectR = {{0, 0}, {90, 170}};

static const CGRect leftHandUpP = {{-16, 130}, {80, 40}};
static const CGRect leftHandUpL = {{-16, 90}, {80, 26}};
static const CGRect leftHandUpR = {{-8, 90}, {40, 26}};

static const CGRect leftHandDownP = {{16, 130}, {45, 80}};
static const CGRect leftHandDownL = {{16, 90}, {45, 55}};
static const CGRect leftHandDownR = {{9, 90}, {22, 55}};

static const CGRect rightHandUpP = {{124, 80}, {45, 80}};
static const CGRect rightHandUpL = {{124, 55}, {45, 55}};
static const CGRect rightHandUpR = {{62, 55}, {22, 55}};

static const CGRect rightHandDownP = {{124, 140}, {45, 80}};
static const CGRect rightHandDownL = {{124, 90}, {45, 55}};
static const CGRect rightHandDownR = {{62, 90}, {22, 55}};



- (id)initWithFrame:(CGRect)frameRect AndOrientation:(UIInterfaceOrientation)orientation
{
    self = [super initWithFrame:frameRect];
	self.orientation = orientation;
	self.state = kGreen;
	[self initImages];
	[self initSounds];
    return self;
}


- (void) dealloc	{
	NSLog(@"dealloc Chip");
	self.rightImg = nil;
	self.centerImg = nil;
	self.rightImg = nil;
	self.rightHeadImg = nil;
	self.centerHeadImg = nil;
	self.rightHeadImg = nil;
	self.leftHandUpImg = nil;
	self.leftHandDownImg = nil;
	self.rightHandUpImg = nil;
	self.rightHandDownImg = nil;
	AudioServicesDisposeSystemSoundID (self.soundFileObject);
	CFRelease (self.soundFileURLRef);
	AudioServicesDisposeSystemSoundID (self.mouthPopSoundFileObject);
	CFRelease (self.mouthPopSoundRef);
	
	[super dealloc];
}


-(void) initSounds
{
	// Get the main bundle for the app
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	
	// Get the URL to the sound file to play
	soundFileURLRef  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("tap"),
												 CFSTR ("aif"),
												 NULL
												 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  soundFileURLRef,
									  &soundFileObject
									  );
	
	// Get the URL to the sound file to play
	mouthPopSoundRef  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("MouthPop"),
												 CFSTR ("wav"),
												 NULL
												 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  mouthPopSoundRef,
									  &mouthPopSoundFileObject
									  );	
}


-(void) initImages
{
	if (self.leftHeadImg)
		[self.leftHeadImg removeFromSuperview];
	if (self.rightHeadImg)
		[self.rightHeadImg removeFromSuperview];
	if (self.centerHeadImg)
		[self.centerHeadImg removeFromSuperview];
	
	
	if ([LocalStorageManager boolForKey:@"eatbeansusephoto"])	{
		UIImage* photo = [[UIImageView alloc] initWithImage:[LocalStorageManager getStoredImage:@"eatbeanleft"]];
		self.leftHeadImg = photo;
		[photo release];
		
		photo = [[UIImageView alloc] initWithImage:[LocalStorageManager getStoredImage:@"eatbeancenter"]];
		self.centerHeadImg = photo;
		[photo release];
		
		photo = [[UIImageView alloc] initWithImage:[LocalStorageManager getStoredImage:@"eatbeanright"]];
		self.rightHeadImg = photo;
		[photo release];

		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				[self.leftHeadImg setFrame:headRectP];
				[self.rightHeadImg setFrame:headRectP];
				[self.centerHeadImg setFrame:headRectP];				
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				[self.leftHeadImg setFrame:headRectL];
				[self.rightHeadImg setFrame:headRectL];
				[self.centerHeadImg setFrame:headRectL];				
				break;
			case (10):
				[self.leftHeadImg setFrame:headRectR];
				[self.rightHeadImg setFrame:headRectR];
				[self.centerHeadImg setFrame:headRectR];				
				break;
		}	
	}
	else {
		UIImage * tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lefthead" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.leftHeadImg = tmpView;
		[tmpImage release];
		[tmpView release];

		tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"righthead" ofType:@"png"]];
		tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.rightHeadImg = tmpView;
		[tmpImage release];	
		[tmpView release];

		tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"centerhead" ofType:@"png"]];
		tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.centerHeadImg = tmpView;
		[tmpImage release];	
		[tmpView release];
		
		switch (self.orientation)	{
			case (UIInterfaceOrientationPortrait):
			case (UIInterfaceOrientationPortraitUpsideDown):
				[self.leftHeadImg setFrame:leftHeadRectP];
				[self.rightHeadImg setFrame:rightHeadRectP];
				[self.centerHeadImg setFrame:centerHeadRectP];				
				break;
			case (UIInterfaceOrientationLandscapeLeft):
			case (UIInterfaceOrientationLandscapeRight):
				[self.leftHeadImg setFrame:leftHeadRectL];
				[self.rightHeadImg setFrame:rightHeadRectL];
				[self.centerHeadImg setFrame:centerHeadRectL];				
				break;
			case (10):
				[self.leftHeadImg setFrame:leftHeadRectR];
				[self.rightHeadImg setFrame:rightHeadRectR];
				[self.centerHeadImg setFrame:centerHeadRectR];				
				break;
		}	
		
	}
	
	if (!self.centerImg)	{
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chipwithoutheadwithouthands" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.centerImg = tmpView;
		[tmpImage release];
	}

	if (!self.rightHandUpImg)	{
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"righthandup" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.rightHandUpImg = tmpView;
		[tmpImage release];	
		[tmpView release];
	}
	
	if (!self.rightHandDownImg)	{
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"righthanddown" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.rightHandDownImg = tmpView;
		[tmpImage release];	
		[tmpView release];
	}
	
	if (!self.leftHandUpImg)	{
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lefthandup" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.leftHandUpImg = tmpView;
		[tmpImage release];	
		[tmpView release];
	}
	
	if (!self.leftHandDownImg)	{
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lefthanddown" ofType:@"png"]];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		self.leftHandDownImg = tmpView;
		[tmpImage release];	
		[tmpView release];
	}
	
	switch (self.orientation)	{
		case (UIInterfaceOrientationPortrait):
		case (UIInterfaceOrientationPortraitUpsideDown):
			[self.leftImg setFrame:bodyRectP];
			[self.centerImg setFrame:bodyRectP];
			[self.rightImg setFrame:bodyRectP];	
			[self.leftHandUpImg setFrame:leftHandUpP];
			[self.leftHandDownImg setFrame:leftHandDownP];
			[self.rightHandUpImg setFrame:rightHandUpP];
			[self.rightHandDownImg setFrame:rightHandDownP];
			break;
		case (UIInterfaceOrientationLandscapeLeft):
		case (UIInterfaceOrientationLandscapeRight):
			[self.leftImg setFrame:bodyRectL];
			[self.centerImg setFrame:bodyRectL];
			[self.rightImg setFrame:bodyRectL];				
			[self.leftHandUpImg setFrame:leftHandUpL];
			[self.leftHandDownImg setFrame:leftHandDownL];
			[self.rightHandUpImg setFrame:rightHandUpL];
			[self.rightHandDownImg setFrame:rightHandDownL];			
			break;
		case (10):
			[self.leftImg setFrame:bodyRectR];
			[self.centerImg setFrame:bodyRectR];
			[self.rightImg setFrame:bodyRectR];				
			[self.leftHandUpImg setFrame:leftHandUpR];
			[self.leftHandDownImg setFrame:leftHandDownR];
			[self.rightHandUpImg setFrame:rightHandUpR];
			[self.rightHandDownImg setFrame:rightHandDownR];
			break;
	}
	
	[self addSubview:self.leftImg];
	[self addSubview:self.centerImg];
	[self addSubview:self.rightImg];
	
	[self addSubview:self.leftHeadImg];
	[self addSubview:self.centerHeadImg];
	[self addSubview:self.rightHeadImg];

	[self addSubview:self.leftHandUpImg];
	[self addSubview:self.leftHandDownImg];
	[self addSubview:self.rightHandUpImg];
	[self addSubview:self.rightHandDownImg];
	
	self.state = kGreen;
	[self.leftImg setHidden:YES];
	[self.centerImg setHidden:NO];
	[self.rightImg setHidden:YES];
	[self.centerHeadImg setHidden:NO];
	[self.leftHeadImg setHidden:YES];
	[self.rightHeadImg setHidden:YES];
	
	[self.rightHandUpImg setHidden:YES];
	[self.leftHandUpImg setHidden:YES];

}	

- (void) changeState:(ButState) theState
{
	self.state = theState;
	switch (theState)	{
		case (kRed):
			[self.leftHeadImg setHidden:NO];
			[self.centerHeadImg setHidden:YES];
			[self.rightHeadImg setHidden:YES];
			break;
		case (kGreen):
			[self.leftHeadImg setHidden:YES];
			[self.centerHeadImg setHidden:NO];
			[self.rightHeadImg setHidden:YES];
			break;
		case (kBlue):
			[self.leftHeadImg setHidden:YES];
			[self.centerHeadImg setHidden:YES];
			[self.rightHeadImg setHidden:NO];
			break;
	}
}
			
- (void) beanCome:(ButState) beanState
{
	switch (beanState)	{
		case (kRed):
			if (self.state == beanState)	{
				AudioServicesPlaySystemSound(self.mouthPopSoundFileObject);
				[UIView beginAnimations:@"lefthandup" context:nil];
				[UIView setAnimationBeginsFromCurrentState:NO];
				[UIView setAnimationDuration:1];
				[UIView setAnimationDelegate:self]; 
				[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
				switch (self.orientation)	{
					case (UIInterfaceOrientationPortrait):
					case (UIInterfaceOrientationPortraitUpsideDown):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownP.origin.x-1, leftHandDownP.origin.y, leftHandDownP.size.width, leftHandDownP.size.height)];
						break;
					case (UIInterfaceOrientationLandscapeLeft):
					case (UIInterfaceOrientationLandscapeRight):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownL.origin.x-1, leftHandDownL.origin.y, leftHandDownL.size.width, leftHandDownL.size.height)];
						break;
					case (10):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownR.origin.x-1, leftHandDownR.origin.y, leftHandDownR.size.width, leftHandDownR.size.height)];
						break;
				}	
				[self.leftHandDownImg setHidden:YES];
				[self.leftHandUpImg setHidden:NO];
				[UIView commitAnimations];	
			}
			else 
				AudioServicesPlayAlertSound (self.soundFileObject);				
			break;
		case (kGreen):
			if (self.state == beanState)	{
				AudioServicesPlaySystemSound(self.mouthPopSoundFileObject);
				[UIView beginAnimations:@"lefthandup" context:nil];
				[UIView setAnimationBeginsFromCurrentState:NO];
				[UIView setAnimationDuration:1];
				[UIView setAnimationDelegate:self]; 
				[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
				switch (self.orientation)	{
					case (UIInterfaceOrientationPortrait):
					case (UIInterfaceOrientationPortraitUpsideDown):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownP.origin.x-1, leftHandDownP.origin.y, leftHandDownP.size.width, leftHandDownP.size.height)];
						break;
					case (UIInterfaceOrientationLandscapeLeft):
					case (UIInterfaceOrientationLandscapeRight):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownL.origin.x-1, leftHandDownL.origin.y, leftHandDownL.size.width, leftHandDownL.size.height)];
						break;
					case (10):
						[self.leftHandDownImg setFrame:CGRectMake(leftHandDownR.origin.x-1, leftHandDownR.origin.y, leftHandDownR.size.width, leftHandDownR.size.height)];
						break;
				}
				[self.leftHandDownImg setHidden:YES];
				[self.leftHandUpImg setHidden:NO];
				[UIView commitAnimations];	
				
				[UIView beginAnimations:@"righthandup" context:nil];
				[UIView setAnimationBeginsFromCurrentState:YES];
				[UIView setAnimationDuration:2];
				[UIView setAnimationDelegate:self]; 
				[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
				switch (self.orientation)	{
					case (UIInterfaceOrientationPortrait):
					case (UIInterfaceOrientationPortraitUpsideDown):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownP.origin.x-1, rightHandDownP.origin.y, rightHandDownP.size.width, rightHandDownP.size.height)];
						break;
					case (UIInterfaceOrientationLandscapeLeft):
					case (UIInterfaceOrientationLandscapeRight):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownL.origin.x-1, rightHandDownL.origin.y, rightHandDownL.size.width, rightHandDownL.size.height)];
						break;
					case (10):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownR.origin.x-1, rightHandDownR.origin.y, rightHandDownR.size.width, rightHandDownR.size.height)];
						break;
				}
				[self.rightHandDownImg setHidden:YES];
				[self.rightHandUpImg setHidden:NO];
				[UIView commitAnimations];
			}
			else 
				AudioServicesPlayAlertSound (self.soundFileObject);		
			break;
		case (kBlue):
			if (self.state == beanState)	{
				AudioServicesPlaySystemSound(self.mouthPopSoundFileObject);
				[UIView beginAnimations:@"righthandup" context:nil];
				[UIView setAnimationBeginsFromCurrentState:NO];
				[UIView setAnimationDuration:1];
				[UIView setAnimationDelegate:self]; 
				[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
				switch (self.orientation)	{
					case (UIInterfaceOrientationPortrait):
					case (UIInterfaceOrientationPortraitUpsideDown):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownP.origin.x-1, rightHandDownP.origin.y, rightHandDownP.size.width, rightHandDownP.size.height)];
						break;
					case (UIInterfaceOrientationLandscapeLeft):
					case (UIInterfaceOrientationLandscapeRight):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownL.origin.x-1, rightHandDownL.origin.y, rightHandDownL.size.width, rightHandDownL.size.height)];
						break;
					case (10):
						[self.rightHandDownImg setFrame:CGRectMake(rightHandDownR.origin.x-1, rightHandDownR.origin.y, rightHandDownR.size.width, rightHandDownR.size.height)];
						break;
				}
				[self.rightHandDownImg setHidden:YES];
				[self.rightHandUpImg setHidden:NO];
				[UIView commitAnimations];	
			}
			else {
				AudioServicesPlayAlertSound (self.soundFileObject);
				[UIView beginAnimations:@"righthanddown" context:nil];
				[UIView setAnimationDuration:1];
				[self.rightHandDownImg setHidden:NO];
				switch (self.orientation)	{
					case (UIInterfaceOrientationPortrait):
					case (UIInterfaceOrientationPortraitUpsideDown):
						[self.rightHandDownImg setFrame:rightHandDownP];
						break;
					case (UIInterfaceOrientationLandscapeLeft):
					case (UIInterfaceOrientationLandscapeRight):
						[self.rightHandDownImg setFrame:rightHandDownL];
						break;
					case (10):
						[self.rightHandDownImg setFrame:rightHandDownR];
						break;
				}
				[self.rightHandUpImg setHidden:YES];
				[UIView commitAnimations];	
			}

			break;
	}
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([finished boolValue])	{
		if ([animationID isEqualToString:@"lefthandup"])	{
			[UIView beginAnimations:@"lefthanddown" context:nil];
			[UIView setAnimationDuration:1];
			[self.leftHandDownImg setHidden:NO];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[self.leftHandDownImg setFrame:leftHandDownP];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[self.leftHandDownImg setFrame:leftHandDownL];
					break;
				case (10):
					[self.leftHandDownImg setFrame:leftHandDownR];
					break;
			}	
			[self.leftHandUpImg setHidden:YES];
			[UIView commitAnimations];	
		}
		
		if ([animationID isEqualToString:@"righthandup"])	{
			[UIView beginAnimations:@"righthanddown" context:nil];
			[UIView setAnimationDuration:1];
			[self.rightHandDownImg setHidden:NO];
			switch (self.orientation)	{
				case (UIInterfaceOrientationPortrait):
				case (UIInterfaceOrientationPortraitUpsideDown):
					[self.rightHandDownImg setFrame:rightHandDownP];
					break;
				case (UIInterfaceOrientationLandscapeLeft):
				case (UIInterfaceOrientationLandscapeRight):
					[self.rightHandDownImg setFrame:rightHandDownL];
					break;
				case (10):
					[self.rightHandDownImg setFrame:rightHandDownR];
					break;
			}
			[self.rightHandUpImg setHidden:YES];
			[UIView commitAnimations];	
		}		
	}
}
	

	
@end
