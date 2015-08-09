    //
//  StampCollectionViewController.m
//  bishibashi
//
//  Created by Eric on 30/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "StampCollectionViewController.h"


@implementation StampCollectionViewController
@synthesize stamps = _stamps;
@synthesize otherstamps = _otherstamps;
@synthesize theExpandBox = _theExpandBox;
@synthesize pins = _pins;
@synthesize otherpins = _otherpins;
@synthesize pinTexts1 = _pinTexts1;
@synthesize pinTexts2 = _pinTexts2;
@synthesize otherPinTexts1 = _otherPinTexts1;
@synthesize otherPinTexts2 = _otherPinTexts2;

@synthesize stampChop = _stampChop;
@synthesize topLetterBar = _topLetterBar;
@synthesize bottomLetterBar = _bottomLetterBar;

@synthesize backBut = _backBut;

@synthesize pageControl = _pageControl;
@synthesize scrollView = _scrollView;

-(void) initInterface
{
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 480-100-80)];
	scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView = scrollView;
	[scrollView release];
	[self.view addSubview:self.scrollView];
	
	
	self.view.backgroundColor = [UIColor blackColor];
	self.stamps = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noGames]];
	self.otherstamps = [NSMutableArray arrayWithCapacity:6];
	self.pinTexts1 = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noGames]];
	self.pinTexts2 = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noGames]];
	self.otherPinTexts1 = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noOtherPins]];
	self.otherPinTexts2 = [NSMutableArray arrayWithCapacity:[[Constants sharedInstance] noOtherPins]];

	/* Post to GameCenter Achievement */
	NSArray* pinsseq = [LocalStorageManager customObjectForKey:PIN];
	if ([[Constants sharedInstance] gameCenterEnabled])	{
		NSArray* submittedAchievements = nil;
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) 
		 {
			 if (achievements)	{
				for (Pin* pinData in pinsseq)	{
					NSString* achievementId;
					if  (pinData.pinLevel==kIntermediate)			
						achievementId = [NSString stringWithFormat:@"%@%@Beginner", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:pinData.game]];
					else if  (pinData.pinLevel==kMaster)			
						achievementId = [NSString stringWithFormat:@"%@%@Master", [[Constants sharedInstance] appVersionPrefix], [[[Constants sharedInstance] gameAchievementsArray] objectAtIndex:pinData.game]];

					GKAchievement* myAchievement = [[[GKAchievement alloc] initWithIdentifier:achievementId] autorelease];
					if (![achievements containsObject:myAchievement])	{
						myAchievement.percentComplete = 100;
						[myAchievement reportAchievementWithCompletionHandler:^(NSError *error)	{}];
					}
			
				}
			 }
		}];
				
	}
	
	NSArray* otherpinsseq = [LocalStorageManager customObjectForKey:OTHERPIN];

	
	UIImageView* letterBar = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"letterbar" ofType:@"png"]]]; 
	[self.view addSubview:letterBar];
	self.topLetterBar = letterBar;
	[letterBar release];

	letterBar = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"letterbar" ofType:@"png"]]]; 
	letterBar.frame = CGRectOffset(letterBar.frame, 0, 480-letterBar.frame.size.height);
	[self.view addSubview:letterBar];
	self.bottomLetterBar= letterBar;
	[letterBar release];
	
	UIImageView* stampChop = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"stampchop_%@",[[Constants sharedInstance] language]]  ofType:@"png"]]]; 
	[self.view addSubview:stampChop];
	self.stampChop = stampChop;
	self.stampChop.frame = CGRectMake(125, 17, 180,75);
	[stampChop release];
	
	
	self.pins = [Pin arrangePins:pinsseq];
	[self initStamps:self.pins];
	
	self.otherpins = [Pin arrangeOtherPins:otherpinsseq];
	[self  initOtherStamps:self.otherpins];
	
	UIButton* fbShareBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[fbShareBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fb-share" ofType:@"png"]] forState:UIControlStateNormal];
	fbShareBut.frame = CGRectMake(200, 370, 80,36);
	[self.view addSubview:fbShareBut];
	[fbShareBut addTarget:self action:@selector(fbShareClicked) forControlEvents:UIControlEventTouchUpInside];

	UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"]] forState:UIControlStateNormal];
	backBut.frame = CGRectMake(10, 410, 33,33);
	//  switch to use navigationcontroll back button for consistency
	[self.view addSubview:backBut];
	[backBut addTarget:self action:@selector(backButClicked) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void) initPageControl
{
	CGRect frame = CGRectMake(22.0, 78.0, 44.0, 22.0);
	UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:frame];
	[self.view addSubview:pageControl];

	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = 2;
	pageControl.currentPage = 0;
	self.pageControl = pageControl;
	[pageControl release];
	
	self.scrollView.pagingEnabled = YES;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * pageControl.numberOfPages, self.scrollView.frame.size.height);
	self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * pageControl.currentPage, 0);
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;	
	self.scrollView.delegate = self;
	
}

- (void) initStamps:(NSArray*)pins
{
	for (int i=0; i<[pins count]; i++)	{	
		Pin* pinData = [pins objectAtIndex:i] ;
		NSString* text1 = [NSString stringWithFormat:@"<%@>%@%@%d%@",  
						   NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
						   NSLocalizedString(@"初心者郵票", nil),
						   NSLocalizedString(@"取得", nil),
						   [[[[[Constants sharedInstance] gamePinScoreArray] objectAtIndex:pinData.game] objectAtIndex:0] intValue] , 
						   NSLocalizedString(@"分以上獲頒", nil)
						   ];
		[self.pinTexts1 addObject: text1];
		NSString* text2 = [NSString stringWithFormat:@"<%@>%@%@%d%@",  
						   NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
						   NSLocalizedString(@"大師級郵票", nil),
						   NSLocalizedString(@"取得", nil),
						   [[[[[Constants sharedInstance] gamePinScoreArray] objectAtIndex:pinData.game] objectAtIndex:1] intValue] , 
						   NSLocalizedString(@"分以上獲頒", nil)
						   ];
		[self.pinTexts2 addObject:text2]; 
		int column = i%4;
		int row = (int)(i/4);
		
		UIButton* imageView = [UIButton buttonWithType:UIButtonTypeCustom];
		if ([[pins objectAtIndex:i] pinLevel]==kBeginner)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else if ([[pins objectAtIndex:i] pinLevel]==kMaster)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gamePinsArray] objectAtIndex:i]] forState:UIControlStateNormal];
			text2 = [NSString stringWithFormat:@"%@%@%@<%@>%@",  
					 NSLocalizedString(@"你於", nil),
					 [NSString YYYYMMDDMin:pinData.time],
					 NSLocalizedString(@"取得", nil),
					 NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
					 NSLocalizedString(@"大師級郵票", nil)
					 ];
			[self.pinTexts2 replaceObjectAtIndex:i withObject:text2];
			[self.pinTexts1 replaceObjectAtIndex:i withObject:@""];				
		}
		else if ([[pins objectAtIndex:i] pinLevel]==kIntermediate)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile:[[[Constants sharedInstance] gameGreyPinsArray] objectAtIndex:i]] forState:UIControlStateNormal];
			text1 = [NSString stringWithFormat:@"%@%@%@<%@>%@",  
					 NSLocalizedString(@"你於", nil),
					 [NSString YYYYMMDDMin:pinData.time],
					 NSLocalizedString(@"取得", nil),
					 NSLocalizedString([[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:pinData.game]],nil), 
					 NSLocalizedString(@"初心者郵票", nil)
					 ];
			[self.pinTexts1 replaceObjectAtIndex:i withObject:text1];
		}
		imageView.frame=CGRectMake(15+(column*75),(row*75),63,63);
		[self.stamps addObject:imageView];
		[self.scrollView addSubview:imageView];
		imageView.tag = i;
		[imageView addTarget:self action:@selector(clickToExpand:) forControlEvents:UIControlEventTouchUpInside];
	}

}

- (void) initOtherStamps:(NSArray*)pins
{
	
	NSMutableArray* hasNickNames = [LocalStorageManager customObjectForKey:NICKNAME];
	for (int i=0; i<6; i++)	{
		NSString* text1;
		NSString* text2;
		if (i==5)	{
			text1 = [NSString stringWithFormat:@"<%@%@>%@%@%d%@",  
					 NSLocalizedString(@"見習", nil),
					 [[[Constants sharedInstance]nickNamesArray] objectAtIndex:i],
					 NSLocalizedString(@"稱號，於街機模式平均能力", nil),
					 NSLocalizedString(@"取得", nil),
					 35,
					 NSLocalizedString(@"分以上獲頒", nil)
					 ];
			text2 = [NSString stringWithFormat:@"<%@>%@%@%d%@",  
					 [[[Constants sharedInstance]nickNamesArray] objectAtIndex:i],
					 NSLocalizedString(@"稱號，於街機模式平均能力", nil),
					 NSLocalizedString(@"取得", nil),
					 70,
					 NSLocalizedString(@"分以上獲頒", nil)
					 ];
		}
		else{
			text1 = [NSString stringWithFormat:@"<%@%@>%@%@%@%d%@",  
							NSLocalizedString(@"見習", nil),
							[[[Constants sharedInstance]nickNamesArray] objectAtIndex:i],
							NSLocalizedString(@"稱號，於街機模式平均能力", nil),
						   NSLocalizedString([[[Constants sharedInstance] attributesArray] objectAtIndex:i],nil),
						   NSLocalizedString(@"取得", nil),
						   35,
						   NSLocalizedString(@"分以上獲頒", nil)
						   ];
			text2 = [NSString stringWithFormat:@"<%@>%@%@%@%d%@",  
							[[[Constants sharedInstance]nickNamesArray] objectAtIndex:i],
							NSLocalizedString(@"稱號，於街機模式平均能力", nil),
						   NSLocalizedString([[[Constants sharedInstance] attributesArray] objectAtIndex:i],nil),
						   NSLocalizedString(@"取得", nil),
						   70,
						   NSLocalizedString(@"分以上獲頒", nil)
						   ];
		}
		[self.otherPinTexts1 addObject:text1];
		[self.otherPinTexts2 addObject:text2]; 
		int column = i%4;
		int row = (int)(i/4);
		
		UIButton* imageView = [UIButton buttonWithType:UIButtonTypeCustom];
		if ([[hasNickNames objectAtIndex:i] intValue]==0)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"question" ofType:@"png"]] forState:UIControlStateNormal];
		}
		else if ([[hasNickNames objectAtIndex:i] intValue]==1)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",[[[Constants sharedInstance]arcadeAchievementsArray] objectAtIndex:i],@"grey"] ofType:@"png"]] forState:UIControlStateNormal];
			text1 = [NSString stringWithFormat:@"%@%@<%@%@>%@",  
					 NSLocalizedString(@"你已", nil),
					 NSLocalizedString(@"取得", nil),
					 NSLocalizedString(@"見習", nil),
					 [[[Constants sharedInstance] nickNamesArray] objectAtIndex:i],
					 NSLocalizedString(@"稱號", nil)
					 ];
			[self.otherPinTexts2 replaceObjectAtIndex:i withObject:text2];
			[self.otherPinTexts1 replaceObjectAtIndex:i withObject:@""];				
		}
		else if ([[hasNickNames objectAtIndex:i] intValue]==2)	{
			[imageView setBackgroundImage:[UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[[[Constants sharedInstance]arcadeAchievementsArray] objectAtIndex:i] ofType:@"png"]] forState:UIControlStateNormal];
			text2 = [NSString stringWithFormat:@"%@%@<%@>%@",  
					 NSLocalizedString(@"你已", nil),
					 NSLocalizedString(@"取得", nil),
					 [[[Constants sharedInstance] nickNamesArray] objectAtIndex:i],
					 NSLocalizedString(@"稱號", nil)
					 ];
			[self.otherPinTexts2 replaceObjectAtIndex:i withObject:text2];
			[self.otherPinTexts1 replaceObjectAtIndex:i withObject:@""];				
		}
		
		imageView.frame=CGRectMake(320+15+(column*75),(row*75),63,63);
		[self.otherstamps addObject:imageView];
		[self.scrollView addSubview:imageView];
		imageView.tag = i;
		[imageView addTarget:self action:@selector(clickToExpandOther:) forControlEvents:UIControlEventTouchUpInside];
	}
	
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	
    // Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (page!=self.pageControl.currentPage)	{
		self.pageControl.currentPage = page;
	}
}

-(void) clickToExpand:(id)sender
{
	int row = [sender tag] / 4;
	int column = [sender tag] % 4;
	
	NSArray* upperset = nil;
	NSArray* lowerset = nil;
	if ((row+1)*4 <[self.stamps count])	{
		lowerset = [self.stamps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange((row+1)*4, [self.stamps count]-(row+1)*4)]];
		upperset = [self.stamps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,(row+1)*4)]];
	}
	else
		upperset = [self.stamps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[sender tag]+1)]];
	ExpandBox* theExpandBox = [[ExpandBox alloc] initStartY:100+(row+1)*75 WithUpper:row*75 AndUpperOffset:66 AndLower:480-(row*75) AndLowerOffset:66 AndUpperPins:upperset AndLowerPins:lowerset AndThePin:sender AndText1:[self.pinTexts1 objectAtIndex:[sender tag]] AndText2:[self.pinTexts2 objectAtIndex:[sender tag]] AndIsForOther:NO];
	[self.view addSubview:theExpandBox];
	self.theExpandBox = theExpandBox;
	[theExpandBox release];
	[self.theExpandBox expand];
}

-(void) clickToExpandOther:(id)sender
{
	int row = [sender tag] / 4;
	int column = [sender tag] % 4;
	
	int upIndex = [self.otherstamps count];
	if ((row+1)*4<upIndex)
		upIndex = (row+1)*4;
	NSArray* upperset = [self.otherstamps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,upIndex)]];
	NSArray* lowerset = nil;
	if ((row+1)*4 <[self.otherstamps count])
		lowerset = [self.otherstamps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange((row+1)*4, [self.otherstamps count]-(row+1)*4)]];
	
	ExpandBox* theExpandBox = [[ExpandBox alloc] initStartY:100+(row+1)*75 WithUpper:row*75 AndUpperOffset:66 AndLower:480-(row*75) AndLowerOffset:66 AndUpperPins:upperset AndLowerPins:lowerset AndThePin:sender AndText1:[self.otherPinTexts1 objectAtIndex:[sender tag]] AndText2:[self.otherPinTexts2 objectAtIndex:[sender tag]] AndIsForOther:YES];
	[self.view addSubview:theExpandBox];
	self.theExpandBox = theExpandBox;
	[theExpandBox release];
	[self.theExpandBox expand];
}

- (void) backButClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) fbShareClicked
{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	
	[self.view.layer renderInContext:ctx];
	
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
	NSData * imageData = UIImageJPEGRepresentation(image1, 0.1);
	NSString* imageStr = [NSString base64StringFromData:imageData length:[imageData length]];
	
	UIGraphicsEndImageContext();
	CFUUIDRef   uuid; 
    
	uuid = CFUUIDCreate(NULL); 
	NSString* uuidStr = (NSString *) CFUUIDCreateString(NULL, uuid);
	if (uuidStr && imageStr)	{
		NSString* code = [self signImage:uuidStr];
		NSString* urlStr = [NSString stringWithFormat:@"%@%@uuid=%@&code=%@", HOSTURL,UPLOADIMAGEREQ, uuidStr, code];
		NSString* escapedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL* url = [NSURL URLWithString:escapedUrl];
		NSURLRequest* req = [NSMutableURLRequest requestWithURL:url];
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody:[[NSString stringWithFormat:@"img=%@",imageStr] dataUsingEncoding:NSUTF8StringEncoding]];
		[NSURLConnection connectionWithRequest:req delegate:self];
		
		[self postUpdateToFacebook:uuidStr];
	}

	
	CFRelease(uuid); 
}

- (void) postUpdateToFacebook:(NSString*)uuid
{
	FBDataSource *fbDataSource = [FBDataSource sharedInstance];
	if ([fbDataSource.fbSession isConnected])	{
		NSString* tweetPic = @"";
		
		if (uuid){
			tweetPic = [NSString stringWithFormat:@"%@serveImage?uuid=%@", HOSTURL,uuid];
		}
		NSString* tweetStringFull;
		if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version1"])
			tweetStringFull = [NSString stringWithFormat:@"{\"name\":\"%@\","
							   "\"href\":\"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835\","
							   "\"caption\":\"%@\",\"description\":\"%@\","
							   "\"media\":[{\"type\":\"image\","
							   "\"src\":\"%@\","
							   "\"href\":\"%@\"}],"
							   "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"http://itunes.com/apps/redsoldier/拍拍機bashbashlite\"}}}", 
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! Lite v1.4",nil),
							   NSLocalizedString(@"於iPhone 拍拍機BashBash! 中， 獲得這些襟章!!",nil),
							   @"", tweetPic, tweetPic,
							   NSLocalizedString(@"透過iTune下載", nil),
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! Lite 1.2",nil)];
		else if ([[[Constants sharedInstance] APPVERSION] isEqualToString:@"version2"])
			tweetStringFull = [NSString stringWithFormat:@"{\"name\":\"%@\","
							   "\"href\":\"http://www.facebook.com/pages/Hong-Kong/Red-Soldier/104123529642835\","
							   "\"caption\":\"%@\",\"description\":\"%@\","
							   "\"media\":[{\"type\":\"image\","
							   "\"src\":\"%@\","
							   "\"href\":\"%@\"}],"
							   "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"http://itunes.com/apps/redsoldier/拍拍機bashbash\"}}}", 
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! v1.4",nil),
							   NSLocalizedString(@"於iPhone 拍拍機BashBash! 中， 獲得這些襟章!!",nil),
							   @"", tweetPic, tweetPic,
							   NSLocalizedString(@"透過iTune下載", nil),
							   NSLocalizedString(@"iPhone App 拍拍機 BashBash! 1.4",nil)];
		
		
		[fbDataSource postMessageToFacebook:tweetStringFull];
	}
}


- (NSString*) signImage:(NSString*)uuid
{
	NSMutableString *shared_secret = [[NSMutableString alloc] init];
	[shared_secret appendString:uuid];
	[shared_secret appendString:SHAREDSECRET];
	NSMutableData *signedData = [[NSMutableData alloc] init];
	[signedData appendData:[[shared_secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
	NSMutableString *codeString = [NSMutableString string];
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	if (CC_MD5([signedData bytes], [signedData length], digest)) {
		for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
			[codeString appendFormat: @"%02x", (int)(digest[i])];
		}
	}
	[shared_secret release];
	[signedData release];
	
	return codeString;
	
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	/*
	self.title = NSLocalizedString(@"拍拍郵票珍藏", nil);
	UIImageView* titleImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pintitle" ofType:@"png"]]]; 
	
	// Create the bar button item for the segmented control
	UIBarButtonItem *titleBarButton = [[UIBarButtonItem alloc]
											 initWithCustomView:titleImage];
	[titleImage release];
	self.navigationItem.rightBarButtonItem=titleBarButton; 
	[titleBarButton release];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	 */
	[self initInterface];
	[self initPageControl];

}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	for (UIImageView* image in self.stamps)	{
		[image removeFromSuperview];
	}
    [super viewWillDisappear:animated];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.otherstamps = nil;
	self.otherpins = nil;
	self.pageControl = nil;
	self.scrollView = nil;
	self.backBut = nil;
	self.topLetterBar = nil;
	self.bottomLetterBar = nil;
	self.stampChop = nil;
	self.pinTexts1 = nil;
	self.pinTexts2 = nil;
	self.otherPinTexts1 = nil;
	self.otherPinTexts2 = nil;
	self.pins = nil;
	self.stamps = nil;
	self.theExpandBox = nil;
    [super dealloc];
}


@end
