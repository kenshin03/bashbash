    //
//  ConfigViewController.m
//  bishibashi
//
//  Created by Eric on 12/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"
#import "FBDataSource.h"

#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0
#define kTextFieldWidth	260.0
#define kTextFieldHeight		30.0
@implementation ConfigViewController
@synthesize name, switchCtl, usePhoto;

@synthesize state = _state;
@synthesize facebookLoginOutCell = _facebookLoginOutCell;
@synthesize facebookLoginUserName = _facebookLoginUserName;

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillAppear:animated];
	[self.tableView reloadData];

}

-(id) init
{
	if (self=[super initWithStyle:UITableViewStyleGrouped])	{
		self.title = NSLocalizedString(@"設定",nil);
	}
	return self;
}

- (void) FBLoginedWithUserName:(NSString*)username AndImageUrl:(NSString*) imageurl AndUid:(NSString*)uid
{
	[self.facebookLoginUserName setText:username];
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
	NSLog(@"dealloc ConfigViewController");
	[name release];
	[switchCtl release];
	[[FBDataSource sharedInstance] setDelegate:nil];
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	if (section==1)	{
		CountryTableViewController* countryTableViewController = [[CountryTableViewController alloc]init];
		countryTableViewController.delegate = self;
		[self.navigationController pushViewController:countryTableViewController animated:YES];
		[countryTableViewController release];
	}
	else if (section==103)	{
		GameFrameSelectionViewController* gameSelectionViewController = [[GameFrameSelectionViewController alloc]init];
		gameSelectionViewController.delegate = self;
		[self.navigationController pushViewController:gameSelectionViewController animated:YES];
		[gameSelectionViewController release];
	}
	else if (section==3)	{
		// twitter
		MBConfigViewController* mbConfigViewController = [[MBConfigViewController alloc]init];
		[self presentModalViewController:mbConfigViewController animated:YES];
		[mbConfigViewController release];
	}
	else if (section==4)	{
		// sina
		SinaConfigViewController* sinaConfigViewController = [[SinaConfigViewController alloc]init];
		[self presentModalViewController:sinaConfigViewController animated:YES];
		[sinaConfigViewController release];
	}
	else if (section==5)	{
		/*
		// facebook
		FBDataSource *fbDataSource = [FBDataSource sharedInstance];
		if ([fbDataSource.fbSession isConnected])	{
//		if (fbDataSource.isLogined == YES){
		//	self.facebookLoginUserName = @"";
			[fbDataSource logoutFacebook];
			[self.tableView reloadData];

		}else{
			[fbDataSource loginFacebook];
		 */
		;
		
	}
	else if (section==2)	{
		// imageSettings
		ImageSettingsViewController* imageSettingsVC = [[ImageSettingsViewController alloc] init];
		//imageSettingsVC.delegate = self;
		[self.navigationController pushViewController:imageSettingsVC animated:YES];
		[imageSettingsVC release];
	}
	else if (section==106)	{
		// theme
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feature will be available in the future" message:@"Feature will be available in the future"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];	
	}
	else if (section==6)	{
		// language

		UILanguageSelectionViewController* gameSelectionViewController = [[UILanguageSelectionViewController alloc]init];
		gameSelectionViewController.delegate = self;
		[self.navigationController pushViewController:gameSelectionViewController animated:YES];
		[gameSelectionViewController release];
		
	}
}

- (void) countrySelected:(NSString*) country
{
	[LocalStorageManager setObject:country forKey:COUNTRY];
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) frameSelected:(NSString*) gameframe
{
	[LocalStorageManager setObject:gameframe forKey:GAMEFRAME];
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) uiLanguageSelected:(NSString*) lang
{
	[LocalStorageManager setObject:lang forKey:UILANGUAGE];
	[[Constants sharedInstance] setLanguage:lang];
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)changeFacebookButtonToLogout
{
	if (self.facebookLoginOutCell != nil){
		//self.facebookLoginUserName = @"";
		self.facebookLoginOutCell.image = [UIImage imageNamed:@"logout_iphone.png"];
		[self.tableView reloadData];
	}
}

/*
- (void)updateUserNameInFacebookButton:(NSString*)userName
{
	
//	self.facebookLoginOutCell.image = [UIImage imageNamed:@"logout_iphone.png"];
	self.facebookLoginUserName.text = userName;
//	[self.tableView reloadData];
}
*/
/*
- (void)clearNameInFacebookButton
{
//	self.facebookLoginUserName = @"";
  //  self.facebookLoginOutCell.textLabel.text = @"";
	self.facebookLoginUserName.text = @"";

}
*/


- (void)changeFacebookButtonToLogin
{
	if (self.facebookLoginOutCell != nil){
		self.facebookLoginOutCell.image = [UIImage imageNamed:@"connect_with_facebook_iphone.png"];
		[self.tableView reloadData];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	UITableViewCell* cell;
	switch (section)	{
		case (0):
			cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"] autorelease];
			}
			[cell.contentView addSubview:self.name];
			break;
		case (1):
			cell = [tableView dequeueReusableCellWithIdentifier:@"country"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"country"] autorelease];
			}
			NSString* country = [LocalStorageManager objectForKey:COUNTRY];
			if (country)	{
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >", country];
				cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[country lowercaseString]]];
			}
			break;
		case (2):
			
			if (row==1)	{
				cell = [tableView dequeueReusableCellWithIdentifier:@"usephoto"];
				if(!cell)
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usephoto"] autorelease];
				}
				cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"更改",nil)];
			}
			
			else if (row==0)	{
				cell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
				if(!cell)
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photo"] autorelease];
				}
				Baby* baby = [[Baby alloc] initWithFrame:CGRectMake(0, 0, 80,80) AndColor:kGreen AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(80, 0, 80,80) AndColor:kGreen AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby.openmouthface setHidden:NO];
				[baby.face setHidden:YES];
				[baby release];
				baby = [[Baby alloc] initWithFrame:CGRectMake(160, 0, 80,80) AndColor:kGreen AndOrientation:11];
				[cell.contentView addSubview:baby];
				[baby.cryingface setHidden:NO];
				[baby.face setHidden:YES];
				[baby release];
			}
			
			break;
			/*
		case (3):
			cell = [tableView dequeueReusableCellWithIdentifier:@"frame"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"frame"] autorelease];
			}
			NSString* gameFrame = [LocalStorageManager objectForKey:GAMEFRAME];
			if (gameFrame)	{
				if ([gameFrame isEqualToString:@"white"])
					cell.textLabel.text = [NSString stringWithFormat:@"Arcade Cabinet %@ >", gameFrame];
				else
					cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ >",NSLocalizedString(@"古老電視",nil), gameFrame];
				cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%@_small.png",gameFrame]];
			}
			else {
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >",NSLocalizedString(@"不需外框", nil)];				
			}
			break;	
			 */
		case (3):
			cell = [tableView dequeueReusableCellWithIdentifier:@"twitter"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twitter"] autorelease];
			}
			cell.textLabel.text = [NSString stringWithFormat:@"%@ >", NSLocalizedString(@"我的 Twitter 帳戶",nil)];
			break;
		case (4):
			cell = [tableView dequeueReusableCellWithIdentifier:@"sinamb"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sinamb"] autorelease];
			}
			cell.textLabel.text = [NSString stringWithFormat:@"%@ >", NSLocalizedString(@"我的 新浪微博 帳戶",nil)];
			break;
		case (5):
			cell = [tableView dequeueReusableCellWithIdentifier:@"facebook"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"facebook"] autorelease];
			}
			self.facebookLoginOutCell = cell;
			FBDataSource *fbDataSource = [FBDataSource sharedInstance];
			fbDataSource.delegate = self;
	//		NSLog(@"fbDataSource.isLogined: %i", fbDataSource.isLogined);

			FBLoginButton* button = [[[FBLoginButton alloc] init] autorelease];
			button.frame = CGRectMake(20, 10, button.frame.size.width, button.frame.size.height);
			[cell.contentView addSubview:button];
			UILabel* tmp = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 180,20)];
			tmp.backgroundColor = [UIColor clearColor];
			tmp.font = [UIFont systemFontOfSize:18];
			[cell.contentView addSubview:tmp];
			if (fbDataSource.username != nil)
				tmp.text = fbDataSource.username;
			[tmp release];			
			self.facebookLoginUserName = tmp;
	
			/*
			if (fbDataSource.isLogined == YES){
				cell.image = [UIImage imageNamed:@"logout_iphone.png"];
			}else{
				cell.image = [UIImage imageNamed:@"connect_with_facebook_iphone.png"];
			}
			cell.textLabel.text = self.facebookLoginUserName;
			 */
			break;
		case (7):
			cell = [tableView dequeueReusableCellWithIdentifier:@"theme"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"theme"] autorelease];
			}
			cell.textLabel.text = [NSString stringWithFormat:@"%@ >", NSLocalizedString(@"地道香港",nil)];
			break;
		case (6):
			cell = [tableView dequeueReusableCellWithIdentifier:@"language"];
			if(!cell)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"language"] autorelease];
			}
			if ([[[Constants sharedInstance]language]isEqualToString:@"en-hk"])
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >", @"English"];
			else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-hk"]) {
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >", @"繁體中文（香港廣東話）"];				
			}
			else if ([[[Constants sharedInstance]language] isEqualToString:@"zh-Hans"]) {
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >", @"简体中文"];				
			}
			else if ([[[Constants sharedInstance]language] isEqualToString:@"zh_TW"]) {
				cell.textLabel.text = [NSString stringWithFormat:@"%@ >", @"繁體中文（台灣）"];				
			}
			break;

			
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if (section == 2 && row==0)
		return 90;
	else
		return 50;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section==2)
		return 2;
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 7;	
//	return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)	{
		case (0):
			return NSLocalizedString(@"稱呼",nil);
			break;
		case (1):
			return NSLocalizedString(@"地區",nil);
			break;
		case (2):
			return NSLocalizedString(@"遊戲用照片",nil);
			break;
//		case (3):
//			return NSLocalizedString(@"框架",nil);
//			break;
		case (3):
			return NSLocalizedString(@"Twitter",nil);
			break;
		case (4):
			return NSLocalizedString(@"Sina 微博",nil);
			break;
		case (5):
			return NSLocalizedString(@"Facebook",nil);
			break;
		case (6):
			return NSLocalizedString(@"語言",nil);
			break;
		case (7):
			return NSLocalizedString(@"主題",nil);
			break;
	}
}

- (UITextField *)name
{
	if (name == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
		name  = [[UITextField alloc] initWithFrame:frame];
		
		name.borderStyle = UITextBorderStyleRoundedRect;
		name.textColor = [UIColor blackColor];
		name.font = [UIFont systemFontOfSize:17.0];
		if ([LocalStorageManager objectForKey:USER_NAME])
			name.text = [LocalStorageManager objectForKey:USER_NAME];
		else
			name.placeholder = NSLocalizedString(@"<輸入稱呼>",nil);
		name.backgroundColor = [UIColor whiteColor];
		name.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		name.keyboardType = UIKeyboardTypeDefault;
		name.returnKeyType = UIReturnKeyDone;
		
		name.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		name.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed

	}
	return name;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[LocalStorageManager setObject:textField.text forKey:USER_NAME];
	NSLog(@"text is %@", textField.text);
	
	if ([textField.text isEqualToString:@"Ka Ka"] || [textField.text isEqualToString:@"Kenny"] || [textField.text isEqualToString:@"Adelene"])	{
		[[Constants sharedInstance] setAPPVERSION:@"version2" ];
		
		// open an alert with just an OK button
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock Full Version" message:@"You have just unlocked the full version"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	}
	else
	 
//		[[Constants sharedInstance] setAPPVERSION:@"version1" ];
//		[[Constants sharedInstance] setAPPVERSION:@"version2" ];
	[textField resignFirstResponder];
	return YES;
}


@end
