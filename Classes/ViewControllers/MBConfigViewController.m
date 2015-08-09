//
//  MBConfigViewController.m
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MBConfigViewController.h"
#import "Constants.h"
#import "CJSONDeserializer.h"


@implementation MBConfigViewController

@synthesize loginTextField;
@synthesize passwordTextField;
@synthesize mainView;
@synthesize backView;

- (id)init {
    self = [super init];
	[self initMainView];
	if ([LocalStorageManager stringForKey:TWITTER_USER_IMAGE] != nil){
		[self initBackView];
		[self.view addSubview: self.backView];
	}else{
		[self.view addSubview: self.mainView];
	}
	return self;
}

-(void)initBackView{
	
	NSLog(@"initBackView");
	
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
	UIImage* twitterLogoImage =  [UIImage imageNamed:@"twitter_banner_withbird.png"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:twitterLogoImage];
	tmpView.frame = CGRectMake(80, 45, 152, 28);
	[dialogView addSubview:tmpView];
	[tmpView release];		
	
	
	NSLog(@"initBackView 2");
	NSString *profileImageURL = [LocalStorageManager stringForKey:TWITTER_USER_IMAGE];
	NSString *twitterStatus = [LocalStorageManager stringForKey:@"TWITTER_STATUS"];
	
	NSURL *url = [NSURL URLWithString:[profileImageURL stringByReplacingOccurrencesOfString: @"normal" withString: @"reasonably_small"]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage* userProfileImage =  [[UIImage alloc] initWithData:data];
	UIImageView* userProfileImageView = [[UIImageView alloc] initWithImage:userProfileImage];
	userProfileImageView.frame = CGRectMake(50, 90, 64, 64);
	[dialogView addSubview:userProfileImageView];
	[userProfileImageView release];
	[userProfileImage release];
	
	UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 80, 120, 20)];
	[userNameLabel setText:[LocalStorageManager stringForKey:TWITTER_USER]];
	userNameLabel.textColor = [UIColor whiteColor];
	[userNameLabel setBackgroundColor:[UIColor clearColor]];
	userNameLabel.contentMode = UIViewContentModeLeft;
	userNameLabel.font = [UIFont systemFontOfSize:16];
	[dialogView addSubview:userNameLabel];
	[userNameLabel release];
	
	NSLog(@"initBackView 3");
	
	UILabel *userStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 105, 110, 50)];
	[userStatusLabel setText:[LocalStorageManager stringForKey:TWITTER_STATUS]];
	userStatusLabel.textColor = [UIColor whiteColor];
	[userStatusLabel setBackgroundColor:[UIColor clearColor]];
	userStatusLabel.contentMode = UIViewContentModeLeft;
	userStatusLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:13];
	userStatusLabel.numberOfLines = 0;
	[dialogView addSubview:userStatusLabel];
	[userStatusLabel release];
	
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
	
	uploadPhotosToTwitterSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160 ,180, 80, 40)];
	[uploadPhotosToTwitterSwitch setBackgroundColor:[UIColor clearColor]];
	[uploadPhotosToTwitterSwitch addTarget:self action:@selector(uploadToTwitterSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUploadPhotoToTwitter = [LocalStorageManager boolForKey:UPLOAD_PHOTO_TO_TWITTER];
	if (storedUploadPhotoToTwitter == YES){
		[uploadPhotosToTwitterSwitch setOn:YES];
	}
	[dialogView addSubview:uploadPhotosToTwitterSwitch];
	[uploadPhotosToTwitterSwitch release];
	
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
	
	NSLog(@"initBackView 4");
	
	updateToTwitterSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160 ,230, 80, 40)];
	[updateToTwitterSwitch setBackgroundColor:[UIColor clearColor]];
	[updateToTwitterSwitch addTarget:self action:@selector(updateToTwitterSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUpdateToTwitter = [LocalStorageManager boolForKey:POST_SCORE_TO_TWITTER];
	if (storedUpdateToTwitter == YES){
		[updateToTwitterSwitch setOn:YES];
	}
	[dialogView addSubview:updateToTwitterSwitch];
	
	
	
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
	
	useTwitterNameAndImageInGameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(160, 310, 80, 40)];
	[useTwitterNameAndImageInGameSwitch setBackgroundColor:[UIColor clearColor]];
	[useTwitterNameAndImageInGameSwitch addTarget:self action:@selector(useImageAndNameSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
	BOOL storedUseTwitterNameAndImageInGame = [LocalStorageManager boolForKey:USE_TWITTER_NAME_AND_IMAGE];
	if (storedUseTwitterNameAndImageInGame == YES){
		[useTwitterNameAndImageInGameSwitch setOn:YES];
	}
	[dialogView addSubview:useTwitterNameAndImageInGameSwitch];
	
	NSLog(@"initBackView 5");
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(25, 320, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(25, 320, 50, 50)];
	[backButton addTarget:self action:@selector(cancelTwitterInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
	
	// main view end
	UIImage* twitterLogoImage =  [UIImage imageNamed:@"twitter_banner_withbird.png"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:twitterLogoImage];
	tmpView.frame = CGRectMake(80, 45, 152, 28);
	[dialogView addSubview:tmpView];
	[tmpView release];		
	
	FontLabel *twitterNameLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		twitterNameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 90, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}else{
		twitterNameLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 90, 160, 35) fontName:ASCII_FONT_NAME pointSize:ASCII_FONT_MENU_SIZE];
	}
	[twitterNameLabel setText:NSLocalizedString(@"Username or email:", nil)];
	twitterNameLabel.textColor = [UIColor whiteColor];
	twitterNameLabel.backgroundColor = [UIColor clearColor];
	[dialogView addSubview:twitterNameLabel];
	
	UITextField *newloginTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 130, 220, 25)];
	newloginTextField.textColor = [UIColor blackColor];
	newloginTextField.font = [UIFont systemFontOfSize:14.0];
	newloginTextField.placeholder = NSLocalizedString(@"<輸入名稱>",nil);
	newloginTextField.borderStyle = UITextBorderStyleRoundedRect;
	newloginTextField.autocorrectionType = UITextAutocorrectionTypeNo; 
	newloginTextField.textAlignment = UITextAlignmentLeft;
	newloginTextField.keyboardType = UIKeyboardTypeDefault;
	newloginTextField.returnKeyType = UIReturnKeyDone;
	newloginTextField.delegate = self;	
	self.loginTextField = newloginTextField;
	[dialogView addSubview:self.loginTextField];
	[newloginTextField release];
	
	FontLabel *passwordLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		passwordLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 170, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}else{
		passwordLabel = [[FontLabel alloc] initWithFrame:CGRectMake(35, 170, 160, 35) fontName:ASCII_FONT_NAME pointSize:ASCII_FONT_MENU_SIZE];
	}
	[passwordLabel setText:NSLocalizedString(@"Password:", nil)];
	passwordLabel.textColor = [UIColor whiteColor];
	passwordLabel.backgroundColor = [UIColor clearColor];
	[dialogView addSubview:passwordLabel];
	
	UITextField *newpasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 200, 220, 25)];
	newpasswordTextField.textColor = [UIColor blackColor];
	newpasswordTextField.placeholder = NSLocalizedString(@"<輸入密碼>",nil);
	newpasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
	newpasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo; 
	newpasswordTextField.textAlignment = UITextAlignmentLeft;
	newpasswordTextField.keyboardType = UIKeyboardTypeDefault;
	newpasswordTextField.returnKeyType = UIReturnKeyDone;
	newpasswordTextField.delegate = self;	
	newpasswordTextField.secureTextEntry = YES;
	self.passwordTextField = newpasswordTextField;
	[dialogView addSubview:newpasswordTextField];
	[newpasswordTextField release];
	
	UIImageView* confirmImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_small_button" ofType:@"png"]]];
	confirmImageView.frame = CGRectMake(70, 230, 232, 90);
	FontLabel *confirmLabel = nil;
	if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"]){
		confirmLabel = [[FontLabel alloc] initWithFrame:CGRectMake(85, 30, 160, 35) fontName:TW_FONT_NAME pointSize:TW_FONT_MENU_SIZE];
	}else{
		confirmLabel = [[FontLabel alloc] initWithFrame:CGRectMake(85, 30, 160, 35) fontName:ASCII_FONT_NAME pointSize:ASCII_FONT_MENU_SIZE];
	}
	[confirmLabel setText: NSLocalizedString(@"Confirm",nil)];
	confirmLabel.textColor = [UIColor blueColor];
	confirmLabel.backgroundColor = [UIColor clearColor];
	[confirmImageView addSubview:confirmLabel];
	
	UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[confirmButton setFrame: CGRectMake(70, 230, 232, 90)];
	[confirmButton addTarget:self action:@selector(confirmTwitterInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[confirmButton setBackgroundImage:[UIImage imageNamed:@"menu_small_button_pressed.png"] forState:UIControlStateHighlighted];
	[dialogView addSubview:confirmImageView];	
	[dialogView addSubview:confirmButton];	
	[confirmLabel release];
	
	UIImageView* backArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_arrow" ofType:@"png"]]];
	backArrowImageView.frame = CGRectMake(25, 320, 35, 35);
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setFrame: CGRectMake(25, 320, 50, 50)];
	[backButton addTarget:self action:@selector(cancelTwitterInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[dialogView addSubview:backArrowImageView];	
	[dialogView addSubview:backButton];	
	[backArrowImageView release];
	
	
	[mainView addSubview:dialogView];
	self.mainView = mainView;
}	

#pragma mark -
#pragma mark delegate method for UISwitch controls

- (void)useImageAndNameSwitchChanged:(id)sender{
	if ([useTwitterNameAndImageInGameSwitch isOn]){
		[LocalStorageManager setBool:NO forKey:USE_SINA_NAME_AND_IMAGE];
		[LocalStorageManager setBool:YES forKey:USE_TWITTER_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_FACEBOOK_NAME_AND_IMAGE];
		[LocalStorageManager setObject:[LocalStorageManager objectForKey:TWITTER_USER_NAME] forKey:USER_NAME];
		[LocalStorageManager setObject:[LocalStorageManager objectForKey:TWITTER_USER_IMAGE] forKey:USER_IMAGE];
		
	}else{
		[LocalStorageManager setBool:NO forKey:USE_SINA_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_TWITTER_NAME_AND_IMAGE];
		[LocalStorageManager setBool:NO forKey:USE_FACEBOOK_NAME_AND_IMAGE];
		[LocalStorageManager setObject:nil forKey:USER_NAME];
		[LocalStorageManager setObject:nil forKey:USER_IMAGE];
	}	
}

- (void)updateToTwitterSwitchChanged:(id)sender{
	if ([updateToTwitterSwitch isOn]){
		[LocalStorageManager setBool:YES forKey:POST_SCORE_TO_TWITTER];
	}else{
		[LocalStorageManager setBool:NO forKey:POST_SCORE_TO_TWITTER];
	}	
}

- (void)uploadToTwitterSwitchChanged:(id)sender{
	if ([uploadPhotosToTwitterSwitch isOn]){
		[LocalStorageManager setBool:YES forKey:UPLOAD_PHOTO_TO_TWITTER];
	}else{
		[LocalStorageManager setBool:NO forKey:UPLOAD_PHOTO_TO_TWITTER];
	}
	
}


- (void)cancelTwitterInfoButtonClicked:(id)sender{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];	
}

- (void)confirmTwitterInfoButtonClicked:(id)sender{
	
	NSLog(@"confirmTwitterInfoButtonClicked:%@,%@", self.loginTextField.text, self.passwordTextField.text);
	
	[LocalStorageManager setObject:self.loginTextField.text forKey:TWITTER_USER];
	[LocalStorageManager setObject:self.passwordTextField.text forKey:TWITTER_PASSWORD];
	
	TwitterRequest *twitterUpdater = [[TwitterRequest alloc] init];
	twitterUpdater.username = [LocalStorageManager stringForKey:TWITTER_USER];
	twitterUpdater.password = [LocalStorageManager stringForKey:TWITTER_PASSWORD];
	[twitterUpdater getUserProfile:twitterUpdater.username delegate:self requestSelector:@selector(twitterInfoUpdatedCallback:)];
	[twitterUpdater release];
	
}

- (void)twitterInfoUpdatedCallback:(NSData*)content{
	NSString *jsonString = [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
	
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *jsonDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	NSDictionary *statusDictionary = [jsonDictionary objectForKey:@"status"];
	[LocalStorageManager setObject:[statusDictionary objectForKey:@"text"] forKey:TWITTER_STATUS];
	
	// store
	[LocalStorageManager setObject:[jsonDictionary objectForKey:@"profile_image_url"] forKey:TWITTER_USER_IMAGE];
	[LocalStorageManager setObject:[jsonDictionary objectForKey:@"screen_name"] forKey:TWITTER_USER_NAME];
	
	NSLog(@"USER_NAME: %@", [LocalStorageManager stringForKey:USER_NAME]);
	NSLog(@"USER_IMAGE: %@", [LocalStorageManager stringForKey:USER_IMAGE]);
	
	if ([LocalStorageManager objectForKey:TWITTER_USER_IMAGE] != nil){
		[self initBackView];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[self.mainView removeFromSuperview];
	[self.view addSubview:self.backView];
	[useTwitterNameAndImageInGameSwitch setOn:NO];
	
	[UIView commitAnimations];
	[jsonString release];
}


- (void)viewDidLoad 
{
	loginTextField.delegate = self;
	self.passwordTextField.delegate = self;
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




@end
