//
//  BillBoard.m
//  bishibashi
//
//  Created by Eric on 11/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BillBoard.h"

@implementation BillBoard
@synthesize billBoardBottom = _billBoardBottom;
@synthesize scrollView = _scrollView;
@synthesize theInner = _theInner;
@synthesize colorIdx = _colorIdx;
@synthesize theTimer = _theTimer;

- (id) initWithPosterSize:(CGSize)posterSize andPosters:(NSArray *)posterImages andOwner:(id)owner andGameLevel:(GameLevel)gamelevel
{
	if (self=[super initWithFrame:CGRectMake(0,0,320,360)]) {
		self.colorIdx = 0;
		self.backgroundColor = [UIColor clearColor];
		UIScrollView* levelSelectScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
		self.scrollView = levelSelectScrollView;
		[levelSelectScrollView release];
		self.scrollView.backgroundColor = [UIColor clearColor];
		self.scrollView.pagingEnabled = NO;
		self.scrollView.contentSize = CGSizeMake(160*[[Constants sharedInstance] noGames], self.scrollView.frame.size.height);
		self.scrollView.showsHorizontalScrollIndicator = NO;
		self.scrollView.showsVerticalScrollIndicator = NO;
		self.scrollView.scrollsToTop = NO;
		self.scrollView.delegate = self;
		self.scrollView.bounces = NO;
		
		BillBoardInner* board = [[BillBoardInner alloc] initWithPosterSize:posterSize andPosters:posterImages andOwner:owner andGameLevel:gamelevel];
		[self.scrollView addSubview:board];
		self.theInner = board;
		[board release];
		
		UIImage* billboardbottomImage = [UIImage imageNamed:@"billboardbottom.png"];
		UIImageView* billboardbottomView = [[UIImageView alloc] initWithImage:billboardbottomImage];
		billboardbottomView.frame = CGRectMake(0,240,320,140);
		self.billBoardBottom = billboardbottomView;
		[self addSubview:billboardbottomView];
		[billboardbottomView release];
		
		for (int i=0; i<4; i++) {
			UIImageView* theView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"uplight%d.png",i]]];
			theView.frame = CGRectMake(i*80, 10, theView.frame.size.width, theView.frame.size.height);
			[self addSubview:theView];
			[theView release];
		}
		for (int i=0; i<5; i++) {
			UIImage* billboardbottomImage = [UIImage imageNamed:@"bottomlight.png"];
			UIImageView* billboardbottomView = [[UIImageView alloc] initWithImage:billboardbottomImage];
			billboardbottomView.frame = CGRectMake(64*i-15,225,35,16);
			[self addSubview:billboardbottomView];
			[billboardbottomView release];
		}
		
        //      [[owner levelSelectPaneView] addSubview:self.scrollView];               
	}
	return self;
}

- (void) reload
{
	NSArray* pinsseq = [LocalStorageManager customObjectForKey:PIN];
	self.theInner.pins = [Pin arrangePins:pinsseq];
	[self.theInner setNeedsDisplay];
}

- (void) startTimer
{
	NSLog(@"start billboard timer");
	[self.theTimer invalidate];
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void) timerFireMethod:(NSTimer*) theTimer
{
	_counter+=6;
	if (_counter % 10 == 0) {
		if (self.colorIdx == 6)
			self.colorIdx = 0;
		else
			self.colorIdx++;
	}
	
	[self setNeedsDisplay];
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
	
    if (hitView == self)        {
		return self.theInner;
	}
    else
        return hitView;
	
}

- (void) dealloc
{
	NSLog(@"dealloc BillBoard");
	self.billBoardBottom = nil;
	self.scrollView = nil;
	self.theInner = nil;
	NSLog(@"invalidate billboard timer");
	[self.theTimer invalidate];
	self.theTimer = nil;
	[super dealloc];
}

-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	size_t num_locations = 3;
	CGFloat locations[3] = { 0.0, 0.5,1.0 };
	float colorcomponent = 0.8;
	CGFloat componentss[7][12] = 
	{       {       1, 1, 1, 1.0,  // Start color
		1, 1, 1, 0.3,  // middle color
		1, 1, 1, 0.05 }, // End color
		{       colorcomponent, 1, 1, 1.0,  // Start color
			colorcomponent, 1, 1, 0.3,  // middle color
			colorcomponent, 1, 1, 0.05 }, // End color
		{       1, colorcomponent, 1, 1.0,  // Start color
			1, colorcomponent, 1, 0.3,  // middle color
			1, colorcomponent, 1, 0.05 }, // End color
		{       1, 1, colorcomponent, 1.0,  // Start color
			1, 1, colorcomponent, 0.3,  // middle color
			1, 1, colorcomponent, 0.05 }, // End color
		{       colorcomponent, colorcomponent, 1, 1.0,  // Start color
			colorcomponent, colorcomponent, 1, 0.3,  // middle color
			colorcomponent, colorcomponent, 1, 0.05 }, // End color
		{       1, colorcomponent, colorcomponent, 1.0,  // Start color
			1, colorcomponent, colorcomponent, 0.3,  // middle color
			1, colorcomponent,colorcomponent, 0.05 }, // End color
		{       colorcomponent, 1, colorcomponent, 1.0,  // Start color
			colorcomponent, 1, colorcomponent, 0.3,  // middle color
			colorcomponent, 1,colorcomponent, 0.05 } // End color
	}       ;
	CGFloat *components = componentss[self.colorIdx];
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	if (_add && _offset<40)
		_offset+=4;
	else if (_add && _offset==40)   {
		_add = NO;
		_offset-=4;
	}
	else if (!_add && _offset>-40)
		_offset-=4;
	else if (!_add && _offset==-40) {
		_add = YES;
		_offset+=4;
	}
	
	CGPoint myStartPoint[4], myEndPoint[4];
	CGFloat myStartRadius[4], myEndRadius[4];
	
	for (int i=0; i<4; i++) {
		switch (i)      {
			case 0:
				myStartPoint[i].x = 80*i+15;
				myStartPoint[i].y = 20;
				myEndPoint[i].x = 80*i-10+_offset;
				myEndPoint[i].y = 140;
				break;
			case 1:
				myStartPoint[i].x = 80*i+18;
				myStartPoint[i].y = 20;
				myEndPoint[i].x = 80*i+5-_offset;
				myEndPoint[i].y = 140;
				break;
			case 2:
				myStartPoint[i].x = 80*i+18;
				myStartPoint[i].y = 20;
				myEndPoint[i].x = 80*i+25+_offset;
				myEndPoint[i].y = 140;
				break;
			case 3:
				myStartPoint[i].x = 80*i+40;
				myStartPoint[i].y = 20;
				myEndPoint[i].x = 80*i+45-_offset;
				myEndPoint[i].y = 140;
				break;
		}
		
		myStartRadius[i] = 5;
		myEndRadius[i] = 40;
		CGContextDrawRadialGradient (context, myGradient, myStartPoint[i],
									 myStartRadius[i], myEndPoint[i], myEndRadius[i],
									 kCGGradientDrawsAfterEndLocation);
	}
	CGGradientRelease(myGradient);
	
	
	
	
	
	{
		CGGradientRef myGradient;
		size_t num_locations = 2;
		CGFloat locations[2] = { 0.0, 1.0 };
		CGFloat componentss[7][8] = 
		{
			{       1, 1, 1, 0.7,  // Start color
				1, 1, 1, 0.1 }, // End color
			{       colorcomponent, 1, 1, 0.7,  // Start color
				colorcomponent, 1, 1, 0.1 }, // End color
			{       1, colorcomponent, 1, 0.7,  // Start color
				1, colorcomponent, 1, 0.1 }, // End color
			{       1, 1, colorcomponent, 0.7,  // Start color
				1, 1, colorcomponent, 0.1 }, // End color
			{       colorcomponent, colorcomponent, 1, 0.7,  // Start color
				colorcomponent, colorcomponent, 1, 0.1 }, // End color
			{       1, colorcomponent, colorcomponent, 0.7,  // Start color
				1, colorcomponent, colorcomponent, 0.1 }, // End color
			{       colorcomponent, 1, colorcomponent, 0.7,  // Start color
				colorcomponent, 1, colorcomponent, 0.1 } // End color
		}               ;
		CGFloat *components = componentss[self.colorIdx];
		myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
														  locations, num_locations);
		for (int i=0; i<5; i++) {
			CGPoint myStartPoint, myEndPoint;
			myStartPoint.x = i*64+6;
			myStartPoint.y = 250;
			myEndPoint.x = i*64;
			myEndPoint.y = 190;
			CGFloat myStartRadius = 4;
			CGFloat myEndRadius = 35;
			CGContextDrawRadialGradient (context, myGradient, myStartPoint,
										 myStartRadius, myEndPoint, myEndRadius,
										 0);
		}
		CGGradientRelease(myGradient);
	}
	CGColorSpaceRelease(myColorspace);
	
	/*
	 CGRect rects[2 * 10];
	 for (int i=0; i<2 ; i++)        {
	 for (int j=0; j<10; j++)        {
	 rects[i*10+j] = CGRectMake(i*self.theInner.posterSize.width+j*(self.theInner.posterSize.width)/10, 40, (self.theInner.posterSize.width)/10*0.05,self.theInner.posterSize.height);
	 }
	 }
	 CGFloat components2[4]= {0,0,0,1};
	 CGContextSetFillColor(context, components2);
	 CGContextFillRects(context, rects, 2 * 10);
	 
	 CGContextSetBlendMode (context, kCGBlendModeDarken);
	 */
}

@end

@implementation BillBoardInner
@synthesize owner = _owner;
@synthesize posters = _posters;
@synthesize posterSize = _posterSize;
@synthesize pins = _pins;
@synthesize gameLevel = _gameLevel;
- (id) initWithPosterSize:(CGSize) posterSize andPosters:(NSArray*)posterImages andOwner:(id)owner andGameLevel:(GameLevel) gamelevel
{
	if (self=[super initWithFrame:CGRectMake(0,0,posterSize.width * [posterImages count], posterSize.height+40)])   {
		self.gameLevel = gamelevel;
		self.owner = owner;
		self.posterSize = posterSize;
		self.posters = posterImages;
		self.backgroundColor = [UIColor clearColor];
		
		NSArray* pinsseq = [LocalStorageManager customObjectForKey:PIN];
		self.pins = [Pin arrangePins:pinsseq];
		
	}
	return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	int no = (int)([[[touches allObjects] objectAtIndex:0] locationInView:self].x / 160);
	//      NSLog(@"touchesEnded self.owner currentMenu: %i", [self.owner currentMenu]);
	if (no==10 && ([self.owner currentMenu] == localmp_level_select_menu || [self.owner currentMenu] == gc_level_select_menu))      {
		// open an alert with just an OK button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此遊戲暫不設對戰",nil) 
														message:nil
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alert.tag = 0;
		[alert show];   
		[alert release];        
	}
	else if ([self.owner currentMenu] == localmp_level_select_menu) {
		[self.owner localMPLevelSelectButtonClicked:(Game)(no)];
	} else if ([self.owner currentMenu] == gc_level_select_menu){
		[self.owner gcLevelSelectButtonClicked:(Game)(no)];
	}
	else{
		
		if ((no==kdancing || no==kpencil) && self.gameLevel==kWorldClass)      {
			// open an alert with just an OK button
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此遊戲暫不設置大師級選擇",nil) 
															message:nil
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			alert.tag = 0;
			[alert show];   
			[alert release];        
		}
		else if ((self.gameLevel==kWorldClass) && ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version1"]) && no!=0)     {
			// open an alert with just an OK button
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此遊戲大師級可在完整版選擇",nil) 
															message:NSLocalizedString(@"透過iTune 購買拍拍機BashBash! 完整版？",nil)
														   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"購買!",nil), NSLocalizedString(@"再玩多陣",nil),nil];
			alert.tag = 1;
			[alert show];   
			[alert release];        
		}
		else if ([[self.pins objectAtIndex:no] pinLevel]!=kMaster && self.gameLevel==kWorldClass)       {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此遊戲需獲得大師級後才可選擇",nil) 
															message:nil
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			alert.tag = 0;
			[alert show];   
			[alert release];        
		}
		else if (([[Constants sharedInstance] isGameAvailable:(Game)no ForMode:kSingle]) &&
				 (self.gameLevel!=kWorldClass || ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version2"]) || no==0))      
			[self.owner onePlayerGameSelectButtonClicked:(Game)(no)];
		else    {
			// open an alert with just an OK button
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"此遊戲可在完整版選擇",nil) 
															message:NSLocalizedString(@"透過iTune 購買拍拍機BashBash! 完整版？",nil)
														   delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"購買!",nil), NSLocalizedString(@"再玩多陣",nil),nil];
			alert.tag = 1;
			[alert show];   
			[alert release];
		}
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ((alertView.tag !=0) && (buttonIndex==0))    {
		NSString *buyString=@"itms://itunes.com/apps/redsoldier/拍拍機bashbash";
		NSURL *url = [[NSURL alloc] initWithString:[buyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:url];
		[url release];
	}
}


- (void) dealloc
{
	self.posters = nil;
	self.pins = nil;
	[super dealloc];
}


-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
	/*
	 CGRect rects[[self.posters count] * 10];
	 for (int i=0; i<[self.posters count] ; i++)     {
	 for (int j=0; j<10; j++)        {
	 rects[i*10+j] = CGRectMake(i*self.posterSize.width+j*(self.posterSize.width)/10, 40, (self.posterSize.width)/10*0.05,self.posterSize.height);
	 }
	 }
	 CGFloat components[4]= {0,0,0,1};
	 CGContextSetFillColor(context, components);
	 CGContextFillRects(context, rects, [self.posters count] * 10);
	 
	 CGContextSetBlendMode (context, kCGBlendModeDarken);
	 */
	CGContextTranslateCTM(context, 0, self.posterSize.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	int posteroffset=4;
	
	UIImage* lockImage = [UIImage imageNamed:@"lock.png"];
	UIImage* pinBgImage = [UIImage imageNamed:@"pinblackbg.png"];
	for (int i=0; i<[self.posters count] ; i++)     {
		UIImage* image = [UIImage imageWithContentsOfFile:[self.posters objectAtIndex:i]];
		
		if (([[Constants sharedInstance] isGameAvailable:i ForMode:kSingle])    &&
			(self.gameLevel!=kWorldClass || (([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version2"])&&self.gameLevel==kWorldClass&&[[self.pins objectAtIndex:i] pinLevel]==kMaster&&i!=kpencil&&i!=kdancing)  || (i==0&&self.gameLevel==kWorldClass&&[[self.pins objectAtIndex:i] pinLevel]==kMaster)))       {
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width+posteroffset, -40+posteroffset, self.posterSize.width-2*posteroffset, self.posterSize.height-2*posteroffset), image.CGImage);
		}
		else {
			float component[] = {0.8,0.8,0.8,1.0};
			CGContextSetFillColor(context, component);
			CGContextFillRect(context, CGRectMake(i*self.posterSize.width+posteroffset, -40+posteroffset, self.posterSize.width-2*posteroffset, self.posterSize.height-2*posteroffset));
			CGContextSetBlendMode (context, kCGBlendModeOverlay);
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width+posteroffset, -40+posteroffset, self.posterSize.width-2*posteroffset, self.posterSize.height-2*posteroffset), image.CGImage);
			CGContextSetBlendMode (context, kCGBlendModeNormal);
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width+20, -40+40, 120,120), lockImage.CGImage);
		}
		
		CGContextSetBlendMode (context, kCGBlendModeNormal);
		UIImage* pinImage = nil;
		if ([[self.pins objectAtIndex:i] pinLevel]==kMaster)    {
			pinImage = [UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:i]];
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width-2, 115, 45,45), pinBgImage.CGImage);
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width, 118, 40,40), pinImage.CGImage);
		}
		else if ([[self.pins objectAtIndex:i] pinLevel]==kIntermediate) {
			pinImage = [UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:i]];
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width-2, 115, 45,45), pinBgImage.CGImage);
			CGContextDrawImage(context, CGRectMake(i*self.posterSize.width, 118, 40,40), pinImage.CGImage);
		}
		
		
		
		//CGContextDrawImage(context, CGRectMake(i*self.posterSize.width+3, -40+3, self.posterSize.width-6, self.posterSize.height-6), image.CGImage);
		//[image drawInRect:CGRectMake(i*self.posterSize.width, 0, self.posterSize.width, self.posterSize.height)];
	}
	
}

@end