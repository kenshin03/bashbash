//
//  SinaConfigViewController.m
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SinaConfigViewController.h"
#import "Constants.h"


@implementation SinaConfigViewController

- (id)init {
	// main view start
	mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	mainView.backgroundColor = [UIColor whiteColor];	
	
	// main view end
	UIImage* twitterLogoImage =  [UIImage imageNamed:@"sina_logo.jpg"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:twitterLogoImage];
	tmpView.frame = CGRectMake(30, 20, 50, 50);
	[mainView addSubview:tmpView];
	[tmpView release];		
	
	UIFont *modelProfileLabelFont = [UIFont fontWithName:@"Arial" size:16];
	
	UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 150, 40)];
	loginLabel.text = @"Username or email:";
	loginLabel.font = modelProfileLabelFont;
	loginLabel.textAlignment = UITextAlignmentCenter;
	loginLabel.textColor = [UIColor grayColor];
	loginLabel.backgroundColor = [UIColor clearColor];
	[mainView addSubview:loginLabel];
	
	loginTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 130, 220, 25)];
	loginTextField.textColor = [UIColor blackColor];
	loginTextField.backgroundColor = [UIColor whiteColor];
	loginTextField.placeholder = @"Login";
	loginTextField.borderStyle = UITextBorderStyleLine;
	loginTextField.autocorrectionType = UITextAutocorrectionTypeNo; 
	loginTextField.textAlignment = UITextAlignmentLeft;
	loginTextField.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
	loginTextField.returnKeyType = UIReturnKeyDone;
	loginTextField.tag = 0;
	loginTextField.delegate = self;	
	[mainView addSubview:loginTextField];
	
	//
	
	UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 160, 150, 40)];
	passwordLabel.text = @"Password:";
	passwordLabel.font = modelProfileLabelFont;
	passwordLabel.textAlignment = UITextAlignmentCenter;
	passwordLabel.textColor = [UIColor grayColor];
	passwordLabel.backgroundColor = [UIColor clearColor];
	[mainView addSubview:passwordLabel];
	
	passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 200, 220, 25)];
	passwordTextField.textColor = [UIColor blackColor];
	passwordTextField.backgroundColor = [UIColor whiteColor];
	passwordTextField.placeholder = @"Password";
	passwordTextField.borderStyle = UITextBorderStyleLine;
	passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo; 
	passwordTextField.textAlignment = UITextAlignmentLeft;
	passwordTextField.keyboardType = UIKeyboardTypeDefault; // use the default type input method (entire keyboard)
	passwordTextField.returnKeyType = UIReturnKeyDone;
	passwordTextField.tag = 0;
	passwordTextField.delegate = self;	
	[mainView addSubview:passwordTextField];
	
	UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"streetsign_button_background.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	UIImage *buttonBackgroundImageDown = [[UIImage imageNamed:@"streetsign_button_background_inverted.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
	
	UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[confirmButton setFrame: CGRectMake(35, 280, 232, 80)];
	UILabel *englishConfirmTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 13, 80, 20)];
	[englishConfirmTextLabel setText:@"Confirm"];
	englishConfirmTextLabel.contentMode = UIViewContentModeCenter;
	englishConfirmTextLabel.font = [UIFont systemFontOfSize:13];
	[englishConfirmTextLabel setBackgroundColor:[UIColor clearColor]];
	[confirmButton addSubview:englishConfirmTextLabel];
	[englishConfirmTextLabel release];
	UILabel *chineseConfirmTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 70, 20)];
	[chineseConfirmTextLabel setText:@"確定"];
	[chineseConfirmTextLabel setBackgroundColor:[UIColor clearColor]];
	[confirmButton addSubview:chineseConfirmTextLabel];
	[chineseConfirmTextLabel release];
	[confirmButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	[confirmButton setBackgroundImage:buttonBackgroundImageDown forState:UIControlStateHighlighted];
	[confirmButton addTarget:self action:@selector(confirmSinaInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:confirmButton];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelButton setFrame: CGRectMake(35, 360, 232, 80)];
	UILabel *englishCancelTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 13, 80, 20)];
	[englishCancelTextLabel setText:@"Back"];
	englishCancelTextLabel.contentMode = UIViewContentModeCenter;
	englishCancelTextLabel.font = [UIFont systemFontOfSize:13];
	[englishCancelTextLabel setBackgroundColor:[UIColor clearColor]];
	[cancelButton addSubview:englishCancelTextLabel];
	[englishCancelTextLabel release];
	UILabel *chineseCancelTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 70, 20)];
	[chineseCancelTextLabel setText:@"返回"];
	[chineseCancelTextLabel setBackgroundColor:[UIColor clearColor]];
	[cancelButton addSubview:chineseCancelTextLabel];
	[chineseCancelTextLabel release];
	[cancelButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:buttonBackgroundImageDown forState:UIControlStateHighlighted];
	[cancelButton addTarget:self action:@selector(cancelSinaInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:cancelButton];
	
	
	[self.view addSubview: mainView];
	return self;
}	



- (void)cancelSinaInfoButtonClicked:(id)sender{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
}
- (void)confirmSinaInfoButtonClicked:(id)sender{
	
	[LocalStorageManager setObject:loginTextField.text forKey:SINAUSER];
	[LocalStorageManager setObject:passwordTextField.text forKey:SINAPASSWORD];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
	
}




- (void)viewDidLoad 
{
	loginTextField.delegate = self;
	passwordTextField.delegate = self;
	if ([LocalStorageManager stringForKey:SINAUSER] != nil){
		loginTextField.text = [LocalStorageManager stringForKey:SINAUSER];
		passwordTextField.text = [LocalStorageManager stringForKey:SINAPASSWORD];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	bool loginTextFieldDidResign = [loginTextField resignFirstResponder];
	bool passwordTextFieldDidResign = [passwordTextField resignFirstResponder];
	
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
