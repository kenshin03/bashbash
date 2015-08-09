//
//  ConfigView.m
//  bishibashi
//
//  Created by Eric on 19/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigView.h"


@implementation ConfigView
@synthesize usePhoto = _usePhoto;
@synthesize usePhotoLbl = _usePhotoLbl;
@synthesize takePhotoButLeft = _takePhotoButLeft;
@synthesize takePhotoButCenter = _takePhotoButCenter;
@synthesize takePhotoButRight = _takePhotoButRight;
@synthesize backToGameBut = _backToGameBut;
@synthesize delegate = _delegate;
@synthesize owner = _owner;
@synthesize gameView = _gameView;
@synthesize state = _state;

@synthesize leftHeadView = _leftHeadView;
@synthesize rightHeadView = _rightHeadView;
@synthesize centerHeadView = _centerHeadView;
@synthesize leftBodyView = _leftBodyView;
@synthesize rightBodyView = _rightBodyView;
@synthesize centerBodyView = _centerBodyView;

@synthesize gameLevelLabel = _gameLevelLabel;
@synthesize gameLevelSegCtrl = _gameLevelSegCtrl;
@synthesize countryButton = _countryButton;
@synthesize languageButton = _languageButton;
@synthesize keyboardShown = _keyboardShown;
@synthesize userName = _userName;


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

-(id) init
{
	if (self=[super init])	{
		self.title = @"Config";
		[self initInterface];	
		[self registerForKeyboardNotifications];
	}
	return self;
}
	
- (id)initWithFrame:(CGRect)frameRect FromGameView:gameView
{
    self = [super init];
	self.gameView = gameView;
	[self initInterface];	
	[self registerForKeyboardNotifications];
    return self;
}

- (void)dealloc {
	NSLog(@"dealloc ConfigView");
	self.usePhoto = nil;
	self.usePhotoLbl = nil;
	self.takePhotoButLeft = nil;
	self.takePhotoButRight = nil;
	self.takePhotoButCenter = nil;
	self.backToGameBut = nil;
	self.delegate = nil;
	
	self.leftHeadView = nil;
	self.rightHeadView = nil;
	self.centerHeadView = nil;
	self.centerBodyView = nil;
	self.leftBodyView = nil;
	self.rightBodyView = nil;
	
	self.gameLevelLabel = nil;
	self.gameLevelSegCtrl = nil;
	self.countryButton = nil;
	
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField	{
	[textField resignFirstResponder];
}


- (void) initInterface
{
	self.view = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,320,480)];
	[self.view setContentSize:CGSizeMake(320, 960)];
	
	UISwitch* theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 10, 60, 30)];
	self.usePhoto = theSwitch;
	[self.usePhoto addTarget:self action:@selector(toggleUsePhoto) forControlEvents:UIControlEventValueChanged];
	if ([LocalStorageManager boolForKey:@"eatbeansusephoto"])
		self.usePhoto.on = YES;
	[theSwitch release];
	
	UILabel* usePhotoLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 160, 30)];
	usePhotoLbl.text = @"Use Your Photo";
	self.usePhotoLbl = usePhotoLbl;
	self.usePhotoLbl.backgroundColor = [UIColor clearColor];
	[usePhotoLbl release];
	
	self.takePhotoButLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.takePhotoButLeft.titleLabel.numberOfLines = 2;
	self.takePhotoButLeft.titleLabel.font = [UIFont systemFontOfSize:14];
	[self.takePhotoButLeft setTitle:@"Snap" forState:UIControlStateNormal];
	[self.takePhotoButLeft setFrame:CGRectMake(20, 60, 80, 40)];
	[self.takePhotoButLeft addTarget:self action:@selector(takePhotoLeft) forControlEvents:UIControlEventTouchUpInside];

	self.takePhotoButCenter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.takePhotoButCenter.titleLabel.numberOfLines = 2;
	self.takePhotoButCenter.titleLabel.font = [UIFont systemFontOfSize:14];
	[self.takePhotoButCenter setTitle:@"Snap" forState:UIControlStateNormal];
	[self.takePhotoButCenter setFrame:CGRectMake(120, 60, 80, 40)];
	[self.takePhotoButCenter addTarget:self action:@selector(takePhotoCenter) forControlEvents:UIControlEventTouchUpInside];

	self.takePhotoButRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.takePhotoButRight.titleLabel.numberOfLines = 2;
	self.takePhotoButRight.titleLabel.font = [UIFont systemFontOfSize:14];
	[self.takePhotoButRight setTitle:@"Snap" forState:UIControlStateNormal];
	[self.takePhotoButRight setFrame:CGRectMake(220, 60, 80, 40)];
	[self.takePhotoButRight addTarget:self action:@selector(takePhotoRight) forControlEvents:UIControlEventTouchUpInside];

	UIImage* theBodyImage =  [UIImage imageNamed:@"chipwithouthead.png"];
	UIImageView* tmpView = [[UIImageView alloc] initWithImage:theBodyImage];
	tmpView.frame = CGRectMake(20, 120, 90, 125);
	self.centerBodyView = tmpView;
	[self.view addSubview:self.centerBodyView];
	[tmpView release];		
	
	tmpView = [[UIImageView alloc] initWithImage:theBodyImage];
	tmpView.frame = CGRectMake(120, 120, 90, 125);
	self.leftBodyView = tmpView;
	[self.view addSubview:self.leftBodyView];
	[tmpView release];
	
	tmpView = [[UIImageView alloc] initWithImage:theBodyImage];
	tmpView.frame = CGRectMake(220, 120, 90, 125);
	self.rightBodyView = tmpView;
	[self.view addSubview:self.rightBodyView];
	[tmpView release];		
		
	UIImage* theImage;
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeanleft"];	
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lefthead" ofType:@"png"]];

	if (theImage)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:theImage];
		self.leftHeadView = theView;
		theView.frame = CGRectMake(30,137,70,55);
		[self.view addSubview:theView];
		[theView release];
	}
	
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeancenter"];
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"centerhead" ofType:@"png"]];

	if (theImage)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:theImage];
		self.centerHeadView = theView;
		theView.frame = CGRectMake(130,137,70, 55);
		[self.view addSubview:theView];
		[theView release];
	}
	
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeanright"];
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"righthead" ofType:@"png"]];

	if (theImage)	{
		UIImageView* theView = [[UIImageView alloc]initWithImage:theImage];
		self.rightHeadView = theView;
		theView.frame = CGRectMake(230,137,70, 55);
		[self.view addSubview:theView];
		[theView release];
	}
	
	
	UILabel* lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(20, 255, 60, 30)];
	[lbl2 setTextAlignment:UITextAlignmentLeft];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setText:@"Level"];
	[self.view addSubview:lbl2];
	[lbl2 release];
	NSArray* items = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
	UISegmentedControl* gameLevelSeg = [[UISegmentedControl alloc] initWithItems:items];
	[items release];
	gameLevelSeg.frame = CGRectMake(80, 255, 150, 30);
	gameLevelSeg.selectedSegmentIndex = kNormal;
	[gameLevelSeg addTarget:self
						 action:@selector(setGameLevel)
			   forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:gameLevelSeg];
	self.gameLevelSegCtrl = gameLevelSeg;
	[gameLevelSeg release];
	lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(230, 255, 90, 30)];
	[lbl2 setFont:[UIFont boldSystemFontOfSize:14]];
	[lbl2 setTextAlignment:UITextAlignmentCenter];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setText:@"Normal"];
	self.gameLevelLabel = lbl2;
	[self.view addSubview:lbl2];
	[lbl2 release];
	
	
	self.backToGameBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.backToGameBut setFrame:CGRectMake(30, 400, 260, 60)];
	[self.backToGameBut addTarget:self action:@selector(backToGame) forControlEvents:UIControlEventTouchUpInside];
	

	
	UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 180, 56)];
	[lbl setFont:[UIFont boldSystemFontOfSize:24]];
	[lbl setTextAlignment:UITextAlignmentCenter];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setText:@"Back To Game"];
	[self.backToGameBut addSubview:lbl];
	[lbl release];

	[self.view addSubview:self.usePhoto];
	[self.view addSubview:self.usePhotoLbl];
	[self.view addSubview:self.takePhotoButLeft];
	[self.view addSubview:self.takePhotoButCenter];
	[self.view addSubview:self.takePhotoButRight];
	[self.view addSubview:self.backToGameBut];
	
	if (!self.usePhoto.on)	{
		[self.takePhotoButLeft setHidden:YES];
		[self.takePhotoButCenter setHidden:YES];
		[self.takePhotoButRight setHidden:YES];
	}
	
	lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(20, 290, 60, 30)];
	[lbl2 setTextAlignment:UITextAlignmentLeft];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setText:@"Country"];
	[self.view addSubview:lbl2];
	[lbl2 release];
	UIButton* theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	theButton.frame = CGRectMake(90,290,220,35);
//	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
//	[theButton setTitle:[userDefault objectForKey:USER_CITYLONGNAME] forState:UIControlStateNormal];
	[theButton setTitle:[LocalStorageManager objectForKey:COUNTRY] forState:UIControlStateNormal];
	theButton.titleLabel.font = [UIFont systemFontOfSize:20];
	[theButton addTarget:self action:@selector(countryButClicked:) forControlEvents:UIControlEventTouchUpInside];	
	[self.view addSubview:theButton];
	self.countryButton = theButton;
	
	lbl2 =[[UILabel alloc] initWithFrame:CGRectMake(20, 330, 60, 30)];
	[lbl2 setTextAlignment:UITextAlignmentLeft];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setText:@"UI Language"];
	[self.view addSubview:lbl2];
	[lbl2 release];
	theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	theButton.frame = CGRectMake(90,330,220,35);
	//	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	//	[theButton setTitle:[userDefault objectForKey:USER_CITYLONGNAME] forState:UIControlStateNormal];
	[theButton setTitle:@"Chinese >" forState:UIControlStateNormal];
	theButton.titleLabel.font = [UIFont systemFontOfSize:20];
	
	
	[self.view addSubview:theButton];
	self.languageButton = theButton;
	
	UILabel* useridLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 370, 60, 30)];
	[useridLabel setText:@"User ID:"];
	[useridLabel setTextColor: [UIColor blackColor]];
	[useridLabel setBackgroundColor:[UIColor clearColor]];
	UITextField *userInput = [[UITextField alloc] initWithFrame:CGRectMake(90, 370, 220, 30)];
	userInput.borderStyle= UITextBorderStyleBezel;
//	userInput.background = stretchableButtonImageNormal;
	userInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
	userInput.keyboardType = UIKeyboardTypeEmailAddress;
	userInput.autocorrectionType =UITextAutocorrectionTypeNo;
	userInput.clearButtonMode = UITextFieldViewModeAlways;
	if ([LocalStorageManager objectForKey:USER_NAME])
		userInput.text = [LocalStorageManager objectForKey:USER_NAME];
	userInput.delegate = self;
	self.userName = userInput;
	[self.view addSubview:useridLabel];
	[self.view addSubview:self.userName];
	[useridLabel release];
	[userInput release];
	
	
}

- (void) setGameLevel
{
	switch (self.gameLevelSegCtrl.selectedSegmentIndex)	{
		case (kEasy):
			self.gameLevelLabel.text = @"Easy";
			break;
		case (kNormal):
			self.gameLevelLabel.text = @"Normal";
			break;
		case (kHard):
			self.gameLevelLabel.text = @"Hard";
			break;
		case (kWorldClass):
			self.gameLevelLabel.text = @"World Class";
			break;
	}
}


#pragma mark -
#pragma mark ButtonAction
- (void) takePhotoLeft
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		self.state = -1;
		UIImagePickerController *tempPicker;
		
		tempPicker = [[UIImagePickerController alloc] init];
		tempPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		UIImage* tmpImage = [UIImage imageNamed:@"hknighttakephotoleft.png"];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		[tmpView setFrame:CGRectMake(0, 0, 320, 480)];
		
		tempPicker.cameraOverlayView = tmpView;
		[tmpView release];
		
		tempPicker.delegate = self;
		[self presentModalViewController:tempPicker animated:YES];
	}	
}

- (void) takePhotoCenter
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		self.state = 0;

		UIImagePickerController *tempPicker;
		
		tempPicker = [[UIImagePickerController alloc] init];
		tempPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		UIImage* tmpImage = [UIImage imageNamed:@"hknighttakephotocenter.png"];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		[tmpView setFrame:CGRectMake(0, 0, 320, 480)];
		
		tempPicker.cameraOverlayView = tmpView;
		[tmpView release];
		
		tempPicker.delegate = self;
		[self presentModalViewController:tempPicker animated:YES];
	}	
}

- (void) takePhotoRight
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		self.state = 1;

		UIImagePickerController *tempPicker;
		
		tempPicker = [[UIImagePickerController alloc] init];
		tempPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		UIImage* tmpImage = [UIImage imageNamed:@"hknighttakephotoright.png"];
		UIImageView* tmpView = [[UIImageView alloc] initWithImage:tmpImage];
		[tmpView setFrame:CGRectMake(0, 0, 320, 480)];
		
		tempPicker.cameraOverlayView = tmpView;
		[tmpView release];
		
		tempPicker.delegate = self;
		[self presentModalViewController:tempPicker animated:YES];
	}	
}



- (void) backToGame
{
	[LocalStorageManager setObject:self.userName.text forKey:USER_NAME];
	
	[UIView beginAnimations:@"flipToNext" context:nil];
	[UIView setAnimationDuration:0.7];
	UIWindow* window = self.view.superview;
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	[self.gameView reConfig];
	[window addSubview:self.gameView];
	[self.view removeFromSuperview];
	[UIView commitAnimations];
}

- (void) toggleUsePhoto
{
	[LocalStorageManager setBool:self.usePhoto.on forKey:@"eatbeansusephoto"];
	
	if (!self.usePhoto.on)	{
		[self.takePhotoButLeft setHidden:YES];
		[self.takePhotoButCenter setHidden:YES];
		[self.takePhotoButRight setHidden:YES];
	}
	else {
		[self.takePhotoButLeft setHidden:NO];
		[self.takePhotoButCenter setHidden:NO];
		[self.takePhotoButRight setHidden:NO];		
	}

	UIImage* theImage;
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeanleft"];	
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lefthead" ofType:@"png"]];
	
	if (theImage)	{
		[UIView beginAnimations:@"flipToDesp" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.leftHeadView cache:YES];
		self.leftHeadView.image = theImage;
		[UIView commitAnimations];
	}
	
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeancenter"];
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"centerhead" ofType:@"png"]];
	
	if (theImage)	{
		[UIView beginAnimations:@"flipToDesp" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.centerHeadView cache:YES];
		self.centerHeadView.image = theImage;
		[UIView commitAnimations];
	}
	
	if (self.usePhoto.on)
		theImage = [LocalStorageManager getStoredImage:@"eatbeanright"];
	else
		theImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"righthead" ofType:@"png"]];
	
	if (theImage)	{
		[UIView beginAnimations:@"flipToDesp" context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.rightHeadView cache:YES];
		self.rightHeadView.image = theImage;
		[UIView commitAnimations];
	}
}	
	
	
- (void) doneButClicked:(id) sender
{
	if(self.delegate)
	{
		if([self.delegate respondsToSelector:@selector(newPhotoViewControllerDone:)])
		{
			[self.delegate performSelector:@selector(newPhotoViewControllerDone:) withObject:self];
		}
	}
}

- (void) cancelButClicked:(id) sender
{
	if(self.delegate)
	{
		if([self.delegate respondsToSelector:@selector(newPhotoViewControllerCancel:)])
		{
			[self.delegate performSelector:@selector(newPhotoViewControllerCancel:) withObject:self];
		}
	}
}

- (void )countryButClicked:(id) sender
{
	CountryTableViewController* countryTableViewController = [[CountryTableViewController alloc]init];
	countryTableViewController.delegate = self;
	[self.navigationController pushViewController:countryTableViewController animated:YES];
	[countryTableViewController release];
}

- (void) countrySelected:(NSString*) country
{
	[self.countryButton setTitle:country];
	[self.navigationController popViewControllerAnimated:YES];
}

+ (UIImage*)resizedImage:(UIImage*)inImage  inRect:(CGRect)thumbRect {
/*	
	float ratio = inImage.size.height/inImage.size.width;
	if(inImage.size.height >= inImage.size.width)
	{
		thumbRect.size.width = thumbRect.size.height/ratio;
	}
	else 
	{
		thumbRect.size.height = thumbRect.size.width*ratio;
	}
*/	
	NSLog(@"image size is %f %f", inImage.size.width, inImage.size.height);
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}

+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage InRect:(CGRect)rect {
	CGImageRef maskRef = CGImageCreateWithImageInRect ([maskImage CGImage], rect);
//	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	CGImageRelease(mask);
	CGImageRelease(maskRef);
	UIImage* retImage= [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
	return retImage;
	
}

+ (UIImage*) cropImage:(UIImage *)image InRect:(CGRect)rect {
	CGImageRef maskRef = CGImageCreateWithImageInRect ([image CGImage], rect);
	UIImage* retImage= [UIImage imageWithCGImage:maskRef];
	return retImage;	
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.keyboardShown)
        return;
	
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Resize the scroll view (which is the root view of the window)
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    self.view.frame = viewFrame;
	
    // Scroll the active text field into view.
    CGRect textFieldRect = [self.userName frame];
	((UIScrollView*)self.view).scrollEnabled=YES;
    [self.view scrollRectToVisible:textFieldRect animated:YES];
    ((UIScrollView*)self.view).scrollEnabled=NO;
	self.keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Reset the height of the scroll view to its original value
    CGRect viewFrame = [self.view frame];
    viewFrame.size.height += keyboardSize.height;
    self.view.frame = viewFrame;
	((UIScrollView*)self.view).scrollEnabled=YES;
	[self.view scrollRectToVisible:CGRectMake(0,0,100,10) animated:YES];
	((UIScrollView*)self.view).scrollEnabled=NO;
    self.keyboardShown = NO;
}



#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage* image = [ConfigView resizedImage:[info objectForKey:UIImagePickerControllerOriginalImage] inRect:CGRectMake(0,0,300, 400)];
	NSLog(@"image size is %f %f", image.size.width, image.size.height);
	if(image)
	{
		UIImage* maskingImage = [UIImage imageNamed:@"maskingphoto.png"];
		NSLog(@"maskingImage size is %f %f", maskingImage.size.width, maskingImage.size.height);
		UIImage* maskedImage = [ConfigView maskImage:image withMask:maskingImage InRect:CGRectMake(0, 0, 300, 400)];
			NSLog(@"maskedImage size is %f %f", maskedImage.size.width, maskedImage.size.height);
//		UIImage* croppedMaskedImage = [ConfigView cropImage:maskedImage InRect:CGRectMake(170, 310, 240, 220)];
		UIImage* croppedMaskedImage = [ConfigView cropImage:maskedImage InRect:CGRectMake(85, 157, 130, 130)];
			NSLog(@"croppedMaskedImage size is %f %f", croppedMaskedImage.size.width, croppedMaskedImage.size.height);
		UIImage* sizedMaskedImage = [ConfigView resizedImage:croppedMaskedImage inRect:CGRectMake(0,0,130*320/300,130*480/400)];	
		NSLog(@"sizedMaskedImage size is %f %f", sizedMaskedImage.size.width, sizedMaskedImage.size.height);
		if (self.state ==-1)	{
			[LocalStorageManager addImageToStorage:sizedMaskedImage withKey:@"eatbeanleft"];
			if (self.leftHeadView)
				[self.leftHeadView removeFromSuperview];
			UIImageView* theView = [[UIImageView alloc]initWithImage:sizedMaskedImage];
			self.leftHeadView = theView;
			theView.frame = CGRectMake(30,217,70,55);
			[self.view addSubview:theView];
			[theView release];
		}
			
		else if (self.state ==0)	{
			[LocalStorageManager addImageToStorage:sizedMaskedImage withKey:@"eatbeancenter"];
			if (self.centerHeadView)
				[self.centerHeadView removeFromSuperview];
			UIImageView* theView = [[UIImageView alloc]initWithImage:sizedMaskedImage];
			self.centerHeadView = theView;
			theView.frame = CGRectMake(130,217,70, 55);
			[self.view addSubview:theView];
			[theView release];
		}
			
		else if (self.state ==1)	{
			[LocalStorageManager addImageToStorage:sizedMaskedImage withKey:@"eatbeanright"];
			if (self.rightHeadView)
				[self.rightHeadView removeFromSuperview];			
			UIImageView* theView = [[UIImageView alloc]initWithImage:sizedMaskedImage];
			self.rightHeadView = theView;
			theView.frame = CGRectMake(230,217,70, 55);
			[self.view addSubview:theView];
			[theView release];
		}			

	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
