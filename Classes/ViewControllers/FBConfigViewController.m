    //
//  FBConfigViewController.m
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FBConfigViewController.h"
#import "Constants.h"
#import "CJSONDeserializer.h"


@implementation FBConfigViewController

@synthesize loginTextField;
@synthesize passwordTextField;
@synthesize mainView;
@synthesize backView;

- (id)init {
	
	FBDataSource *fbDataSource = [FBDataSource sharedInstance];
	[fbDataSource setDelegate:self];
	
    self = [super init];
	[self initMainView];
	if ([LocalStorageManager stringForKey:FACEBOOK_IMAGE_URL] != nil){
		[self initBackView];
		[self.view addSubview: self.backView];
	}else{
		[self.view addSubview: self.mainView];
	}
	return self;
}

-(void)initBackView{
	backView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	UIImage* backgroundImage =  [UIImage imageNamed:@"black_modal_overlay_fullscreen.png"];
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
	[backView addSubview:backgroundImageView];
	[backgroundImageView release];
	
	UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(5, 15, 287, 368)];
	UIImage* dialogBackgroundImage =  [UIImage imageNamed:@"black_modal_overlay_dialog.png"];
	UIImageView* dialogBackgroundImageView = [[UIImageView alloc] initWithImage:dialogBackgroundImage];
	dialogBackgroundImageView.frame = CGRectMake(5, 15, 287, 368);
	[dialogView addSubview:dialogBackgroundImageView];
	[dialogBackgroundImageView release];
	
	// main view end
	UIImage* facebookLogoImage =  [UIImage imageNamed:@"facebook_logo_long.png"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:facebookLogoImage];
	tmpView.frame = CGRectMake(60, 35, 164, 54);
	[dialogView addSubview:tmpView];
	[tmpView release];		
	
	NSString *profileImageURL = [LocalStorageManager stringForKey:FACEBOOK_IMAGE_URL];
	NSURL *url = [NSURL URLWithString:[profileImageURL stringByReplacingOccurrencesOfString: @"normal" withString: @"reasonably_small"]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage* userProfileImage =  [[UIImage alloc] initWithData:data];
	UIImageView* userProfileImageView = [[UIImageView alloc] initWithImage:userProfileImage];
	userProfileImageView.frame = CGRectMake(50, 110, 64, 64);
	[dialogView addSubview:userProfileImageView];
	[userProfileImageView release];
	[userProfileImage release];
	
	UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 100, 120, 20)];
	[userNameLabel setText:[LocalStorageManager stringForKey:FACEBOOK_USER_NAME]];
	userNameLabel.textColor = [UIColor whiteColor];
	[userNameLabel setBackgroundColor:[UIColor clearColor]];
	userNameLabel.contentMode = UIViewContentModeLeft;
	userNameLabel.font = [UIFont systemFontOfSize:16];
	[dialogView addSubview:userNameLabel];
	[userNameLabel release];
	
	FontLabel *uploadPhotosLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		uploadPhotosLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 180, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}else{
		uploadPhotosLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 180, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}
	[uploadPhotosLabel setText:NSLocalizedString(@"上載圖片:", nil)];
	uploadPhotosLabel.textColor = [UIColor whiteColor];
	uploadPhotosLabel.backgroundColor = [UIColor clearColor];
	[dialogView addSubview:uploadPhotosLabel];
	[uploadPhotosLabel release];
	
	uploadPhotosToFacebookSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160 ,180, 80, 40)];
	[uploadPhotosToFacebookSwitch setBackgroundColor:[UIColor clearColor]];
	[uploadPhotosToFacebookSwitch addTarget:self action:@selector(uploadToFacebookSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUploadPhotoToFacebook = [LocalStorageManager boolForKey:UPLOAD_PHOTO_TO_FACEBOOK];
	if (storedUploadPhotoToFacebook == YES){
		[uploadPhotosToFacebookSwitch setOn:YES];
	}
	[dialogView addSubview:uploadPhotosToFacebookSwitch];
	[uploadPhotosToFacebookSwitch release];
	
	FontLabel *updateLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		updateLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 220, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}else{
		updateLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 220, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}
	[updateLabel setText:NSLocalizedString(@"自動上載分數:", nil)];
	updateLabel.textColor = [UIColor whiteColor];
	updateLabel.backgroundColor = [UIColor clearColor];
	[dialogView addSubview:updateLabel];
	[updateLabel release];
	
	updateToFacebookSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160 ,230, 80, 40)];
	[updateToFacebookSwitch setBackgroundColor:[UIColor clearColor]];
	[updateToFacebookSwitch addTarget:self action:@selector(updateToFacebookSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUpdateToFacebook = [LocalStorageManager boolForKey:POST_SCORE_TO_FACEBOOK];
	if (storedUpdateToFacebook == YES){
		[updateToFacebookSwitch setOn:YES];
	}
	[dialogView addSubview:updateToFacebookSwitch];
	
	FontLabel *useImageAndNameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		useImageAndNameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 270, 240, 35) fontName:ASCII_FONT_NAME pointSize:ASCII_FONT_MENU_SIZE];
	}else{
		useImageAndNameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(50, 270, 240, 35) fontName:ASCII_FONT_NAME pointSize:ASCII_FONT_MENU_SIZE];
	}
	[useImageAndNameLabel setText:NSLocalizedString(@"Use image and name in game:", nil)];
	useImageAndNameLabel.textColor = [UIColor whiteColor];
	useImageAndNameLabel.backgroundColor = [UIColor clearColor];
	[dialogView addSubview:useImageAndNameLabel];
	[useImageAndNameLabel release];
	
	useFacebookNameAndImageInGameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160, 310, 80, 40)];
	[useFacebookNameAndImageInGameSwitch setBackgroundColor:[UIColor clearColor]];
	[useFacebookNameAndImageInGameSwitch addTarget:self action:@selector(useFacebookNameAndImageInGameSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUseTwitterNameAndImageInGame = [LocalStorageManager boolForKey:USE_TWITTER_NAME_AND_IMAGE];
	if (storedUseTwitterNameAndImageInGame == YES){
		[useFacebookNameAndImageInGameSwitch setOn:YES];
	}
	[dialogView addSubview:useFacebookNameAndImageInGameSwitch];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(25, 320, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(25, 320, 50, 50)];
	[backButton addTarget:self action:@selector(cancelFacebookInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[dialogView addSubview:backArrowImageView];	
	[dialogView addSubview:backButton];	
	[backArrowImageView release];
	
	[backView addSubview:dialogView];
	self.backView = backView;
	
}

- (void)initMainView {
	// main view start
	mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	UIImage* backgroundImage =  [UIImage imageNamed:@"black_modal_overlay_fullscreen.png"];
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	backgroundImageView.frame = CGRectMake(0, 0, 320, 480);
	[mainView addSubview:backgroundImageView];
	[backgroundImageView release];
	
	UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(5, 15, 287, 368)];
	UIImage* dialogBackgroundImage =  [UIImage imageNamed:@"black_modal_overlay_dialog.png"];
	UIImageView* dialogBackgroundImageView = [[UIImageView alloc] initWithImage:dialogBackgroundImage];
	dialogBackgroundImageView.frame = CGRectMake(5, 15, 287, 368);
	[dialogView addSubview:dialogBackgroundImageView];
	[dialogBackgroundImageView release];
	
	UIImage* facebookLogoImage =  [UIImage imageNamed:@"facebook_logo_long.png"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:facebookLogoImage];
	tmpView.frame = CGRectMake(60, 35, 164, 54);
	[dialogView addSubview:tmpView];
	[tmpView release];		
	
	UIImage* connectWithFacebookImage =  [UIImage imageNamed:@"connect_with_facebook_button.png"];
	connectWithFacebookPlaceHolderImageView = [[UIImageView alloc] initWithImage:connectWithFacebookImage];
	connectWithFacebookPlaceHolderImageView.frame = CGRectMake(50, 140, 176, 31);
	[dialogView addSubview:connectWithFacebookPlaceHolderImageView];
	[connectWithFacebookPlaceHolderImageView release];		
	
	
	FBLoginButton* fbButton = [[FBLoginButton alloc] init];
	fbButton.frame = CGRectMake(50, 140, 1756, 31);
	[dialogView addSubview:fbButton];
	[dialogView bringSubviewToFront:fbButton];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(25, 320, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(25, 320, 50, 50)];
	[backButton addTarget:self action:@selector(cancelFacebookInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[dialogView addSubview:backArrowImageView];	
	[dialogView addSubview:backButton];	
	[backArrowImageView release];
	
	
	[mainView addSubview:dialogView];
	self.mainView = mainView;
}	

#pragma mark -
#pragma mark delegate method for UISwitch controls

- (void)useFacebookNameAndImageInGameSwitchChanged:(id)sender{
	if ([useFacebookNameAndImageInGameSwitch isOn]){
		[LocalStorageManager setBool:NO forKey:USE_SINA_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_TWITTER_NAME_AND_IMAGE];
		[LocalStorageManager setBool:YES forKey:USE_FACEBOOK_NAME_AND_IMAGE];
		[LocalStorageManager setObject:[LocalStorageManager objectForKey:FACEBOOK_USER_NAME] forKey:USER_NAME];
		[LocalStorageManager setObject:[LocalStorageManager objectForKey:FACEBOOK_IMAGE_URL] forKey:USER_IMAGE];
		
	}else{
		[LocalStorageManager setBool:NO forKey:USE_SINA_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_TWITTER_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_FACEBOOK_NAME_AND_IMAGE];
		[LocalStorageManager setObject:nil forKey:USER_NAME];
		[LocalStorageManager setObject:nil forKey:USER_IMAGE];
	}	
}

- (void)updateToFacebookSwitchChanged:(id)sender{
	if ([updateToFacebookSwitch isOn]){
		[LocalStorageManager setBool:YES forKey:POST_SCORE_TO_FACEBOOK];
	}else{
		[LocalStorageManager setBool:NO forKey:POST_SCORE_TO_FACEBOOK];
	}	
}

- (void)uploadToFacebookSwitchChanged:(id)sender{
	if ([uploadPhotosToFacebookSwitch isOn]){
		[LocalStorageManager setBool:YES forKey:UPLOAD_PHOTO_TO_FACEBOOK];
	}else{
		[LocalStorageManager setBool:NO forKey:UPLOAD_PHOTO_TO_FACEBOOK];
	}
	
}


- (void)cancelFacebookInfoButtonClicked:(id)sender{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];	
}


- (void)viewDidLoad 
{
	loginTextField.delegate = self;
	self.passwordTextField.delegate = self;
}


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
    [super dealloc];
}


#pragma mark -
#pragma mark delegate method for Facebook API

- (void) FBLoginedWithUserName:(NSString*)username AndImageUrl:(NSString*) imageurl AndUid:(NSString*) uid{
	
	NSLog(@"FBLoginedWithUserName called");
	NSLog(@"FBLoginedWithUserName called %@", username);
	NSLog(@"FBLoginedWithUserName called %@", imageurl);
	
	if (imageurl != nil){
		[LocalStorageManager setObject:imageurl forKey:FACEBOOK_IMAGE_URL];
		[LocalStorageManager setObject:username forKey:FACEBOOK_USER_NAME];
	}else{
//		[LocalStorageManager removeObjectForKey:FACEBOOK_IMAGE_URL];
	}
	[LocalStorageManager setObject:username forKey:FACEBOOK_USER_NAME];
	if (imageurl != nil){
		[self initBackView];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[self.mainView removeFromSuperview];
	[self.view addSubview:self.backView];
	[useFacebookNameAndImageInGameSwitch setOn:NO];
	
	[UIView commitAnimations];
	
	/*
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
	 */
}




#pragma mark -
#pragma mark delegate method for UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	bool loginTextFieldDidResign = [self.loginTextField resignFirstResponder];
	bool passwordTextFieldDidResign = [self.passwordTextField resignFirstResponder];
	
	if (loginTextFieldDidResign){
		return loginTextFieldDidResign;
	}else if (passwordTextFieldDidResign){
		return passwordTextFieldDidResign;
	}else{
		return NO;
	}
}


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


@end
