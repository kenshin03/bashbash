//
//  SocialPanel.m
//  bishibashi
//
//  Created by Eric on 26/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "SocialPanel.h"


@implementation SocialPanel
@synthesize fbButton = _fbButton;
@synthesize twIcon = _twIcon;
@synthesize mbIcon = _mbIcon;
@synthesize gcIcon = _gcIcon;

@synthesize fbPhoto = _fbPhoto;
@synthesize mbPhoto = _mbPhoto;
@synthesize twPhoto = _twPhoto;
@synthesize msgBoard = _msgBoard;
@synthesize getTWUser = _getTWUser;
@synthesize owner = _owner;
@synthesize socialBackground = _socialBackground;
@synthesize nationalFlag = _nationalFlag;
@synthesize nameInput = _nameInput;

static const CGRect nationalFlagRect = {{0, 0}, {30, 30}};
static const CGRect nameInputRect = {{35, 0}, {110, 30}};

static const CGRect twIconRect = {{225, 0}, {30, 30}};
static const CGRect mbIconRect = {{260, 0}, {30, 30}};
static const CGRect fbIconRect = {{190, 0}, {30, 30}};
static const CGRect gcIconRect = {{155, 0}, {30, 30}};

static const CGRect fbPhotoRect1 = {{90, 0}, {30, 30}};
static const CGRect twPhotoRect1 = {{155, 0}, {30, 30}};
static const CGRect mbPhotoRect1 = {{220, 0}, {30, 30}};

static const CGRect fbPhotoRect2 = {{0, 0}, {30, 30}};
static const CGRect twPhotoRect2 = {{35, 0}, {30, 30}};
static const CGRect mbPhotoRect2 = {{70, 0}, {30, 30}};


static Constants *sharedInstance = nil;

+ (id)sharedInstance {
    @synchronized(self) {
        if(sharedInstance == nil)
            [[self alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedInstance == nil)  {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id) initWithFrame:(CGRect) frame WithMsgBoard:(id) msgBoard AndOwner:(id) owner
{
	if (self=[super initWithFrame:frame])	{
		self.backgroundColor = [UIColor blackColor];
		
		self.msgBoard = msgBoard;
		self.owner = owner;
	/*	
		WebImageView* fbPhoto = [[WebImageView alloc] initWithFrame:fbPhotoRect1 AndImageUrl:nil];
		self.fbPhoto = fbPhoto;
		[fbPhoto release];
		[self addSubview:self.fbPhoto];
*/
		WebImageView* twPhoto = [[WebImageView alloc] initWithFrame:twPhotoRect1 AndImageUrl:nil];
		self.twPhoto = twPhoto;
		[twPhoto release];
		[self addSubview:self.twPhoto];
/*		
		UIView* socialBackground = [[UIView alloc] initWithFrame:CGRectMake(0,0,275,31)];
		[self addSubview:socialBackground];
		socialBackground.backgroundColor = [UIColor blueColor];
		socialBackground.alpha = 0.3;
		self.socialBackground = socialBackground;
		[socialBackground release];
*/		
		NSString* country = [LocalStorageManager objectForKey:COUNTRY];
		if (country)	{
			self.nationalFlag = [UIButton buttonWithType:UIButtonTypeCustom];
			self.nationalFlag.frame = nationalFlagRect;
			[self.nationalFlag setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[country lowercaseString]]]  forState:UIControlStateNormal];
			[self addSubview:self.nationalFlag];
			[self.nationalFlag addTarget:self action:@selector(nationalFlagClicked) forControlEvents:UIControlEventTouchUpInside];
		}
		

		UITextField*	nameInput = [[UITextField alloc] initWithFrame:nameInputRect];
		nameInput.backgroundColor = [UIColor blackColor];
		if (msgBoard)	{
			nameInput.borderStyle = UITextBorderStyleLine;
			nameInput.textColor = [UIColor whiteColor];
		}
		else{
			nameInput.borderStyle = UITextBorderStyleRoundedRect;
			nameInput.textColor = [UIColor blackColor];
		}
		nameInput.delegate = self;
		if ([LocalStorageManager objectForKey:USER_NAME])
			nameInput.text = [LocalStorageManager objectForKey:USER_NAME];

		self.nameInput = nameInput;
		[nameInput release];
		[self addSubview:self.nameInput];
		
		
		FBDataSource *fbDataSource = [FBDataSource sharedInstance];
		[fbDataSource setDelegate:self];
		FBLoginButton* fbButton = [[FBLoginButton alloc] init];
		fbButton.style = FBLoginButtonStyleSmall;
		self.fbButton = fbButton;
		[fbButton release];
		self.fbButton.frame = fbIconRect;
		[self addSubview:self.fbButton];
		 
		 
		self.twIcon = [UIButton buttonWithType:UIButtonTypeCustom];
		self.mbIcon = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.twIcon setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter-icon" ofType:@"png"]] forState:UIControlStateNormal];
		[self.mbIcon setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sina-icon" ofType:@"png"]] forState:UIControlStateNormal];
		self.twIcon.frame = twIconRect;
		self.mbIcon.frame = mbIconRect;
		if ([[Constants sharedInstance] gameCenterEnabled]) {
			[self addGCIcon];
		}
		[self addSubview:self.twIcon];
		[self addSubview:self.mbIcon];
		[self.twIcon addTarget:self action:@selector(twIconClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.mbIcon addTarget:self action:@selector(mbIconClicked) forControlEvents:UIControlEventTouchUpInside];

		NSString* twscreenname = [LocalStorageManager objectForKey:TWITTER_USER];
		if (twscreenname)	{
			GetTWUser* getTWUser = [[GetTWUser alloc] initWithDelegate:self];
			self.getTWUser = getTWUser;
			[getTWUser release];
			
			[self.getTWUser addKey:@"twscreenname" AndVal:twscreenname];
			[self.getTWUser sendReq];
		}
		if ([fbDataSource.fbSession isConnected])
			[self.fbPhoto initImageUrl:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL]];
	}
	return self;
}

- (void) addGCIcon	{
	self.gcIcon = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.gcIcon setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gamecenter_icon" ofType:@"png"]] forState:UIControlStateNormal];
	self.gcIcon.frame = gcIconRect;
//	[self.gcIcon addTarget:self action:@selector(gcIconClicked) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.gcIcon];
}	

- (void)gcIconClicked{
	NSString* prefix = @"bashbash.";
#ifdef LITE_VERSION
	prefix = @"bashbashlite.";
#endif
	
	if ([[Constants sharedInstance] gameCenterEnabled]) {
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		
		if (![self.owner respondsToSelector:@selector(theGame)])	{			
			[self.owner gameCenterButtonClicked];
		}
		else {
			leaderboardController.category = [NSString stringWithFormat:@"%@freeselect.%@", prefix,[[[Constants sharedInstance] gameLeaderboardsArray] objectAtIndex:[self.owner theGame]]];			

			NSLog(leaderboardController.category);
			
			if (leaderboardController != nil)
			{
				leaderboardController.leaderboardDelegate = self;
				[self.owner presentModalViewController: leaderboardController animated: YES];
			}
			[leaderboardController release];
		}
	}
	
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self.owner dismissModalViewControllerAnimated:YES];
}

-(void) mbIconClicked{
	SinaConfigViewController* sinaConfigViewController = [[SinaConfigViewController alloc]init];
	[self.owner presentModalViewController:sinaConfigViewController animated:YES];
	[sinaConfigViewController release];
//	self.currentMenu = no_change;
}

- (void) twIconClicked{
	MBConfigViewController* mbConfigViewController = [[MBConfigViewController alloc]init];
	[self.owner presentModalViewController:mbConfigViewController animated:YES];
	[mbConfigViewController release];
//	self.currentMenu = no_change;
}

- (void) disableButtons
{
	[self.socialBackground setHidden:YES];
	[self.mbIcon setHidden:YES];
	[self.fbButton setHidden:YES];
	[self.twIcon setHidden:YES];
	[self.gcIcon setHidden:YES];
	self.fbPhoto.frame = fbPhotoRect2;
	self.twPhoto.frame = twPhotoRect2;

	
	[UIView animateWithDuration:0.5 animations:^{self.frame = CGRectOffset(self.frame, 0, -80);}
					 completion:^(BOOL finished)
						 {
							 [self removeFromSuperview];
							 self.frame = CGRectOffset(self.frame, 0, 80);
						 }];
	
}
- (void) enableButtons
{
	[self.socialBackground setHidden:NO];
	[self.mbIcon setHidden:NO];
	[self.fbButton setHidden:NO];
	[self.twIcon setHidden:NO];
	[self.gcIcon setHidden:NO];
	
	self.fbPhoto.frame = fbPhotoRect1;
	self.twPhoto.frame = twPhotoRect1;

	
	self.frame = CGRectOffset(self.frame, 0, -80);
	[UIView beginAnimations:@"enableButtons" context:nil];
	[UIView setAnimationDuration:0.5];
	self.frame = CGRectOffset(self.frame, 0, 80);
	[UIView commitAnimations];
}

- (void) FBLoginedWithUserName:(NSString*)username AndImageUrl:(NSString*) imageurl AndUid:(NSString*) uid;
{
	if (imageurl)
		[LocalStorageManager setObject:imageurl forKey:FACEBOOK_IMAGE_URL];
	else
		[LocalStorageManager removeObjectForKey:FACEBOOK_IMAGE_URL];
	[self.fbPhoto initImageUrl:imageurl];
	if (self.msgBoard)	{
		if (uid)	{
			[[self.msgBoard msgGetter] addKey:@"fbuid" AndVal:uid];
			[[self.msgBoard msgGetter] sendReq];
		}
		else {
			[self.msgBoard clear];
		}
	}
}

- (void) nationalFlagClicked
{
	CountryTableViewController* countryTableViewController = [[CountryTableViewController alloc]init];
	countryTableViewController.delegate = self;
	[[self.owner navigationController] pushViewController:countryTableViewController animated:YES];
	[countryTableViewController release];
}


- (void) countrySelected:(NSString*)country
{
	[LocalStorageManager setObject:country forKey:COUNTRY];
	[[self.owner navigationController] popViewControllerAnimated:YES];
	
	[self.nationalFlag setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[country lowercaseString]]]  forState:UIControlStateNormal];
	
}

-(void) dealloc
{
	self.nationalFlag = nil;
	self.socialBackground = nil;
	self.getTWUser = nil;
	self.fbPhoto = nil;
	self.twIcon = nil;
	self.gcIcon = nil;
	self.mbIcon = nil;
	self.fbButton = nil;
	self.twPhoto = nil;
	self.mbPhoto = nil;
	self.nameInput = nil;
}

#pragma mark -
#pragma mark GetMsgDelegate	
- (void)finished:(NSString*) twuserimageurl;
{
	[self.twPhoto initImageUrl:twuserimageurl];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[LocalStorageManager setObject:textField.text forKey:USER_NAME];
	NSLog(@"text is %@", textField.text);
	
	[textField resignFirstResponder];
	return YES;
}
@end
