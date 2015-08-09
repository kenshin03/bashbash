//
//  MBConfigViewController.h
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"
#import "FontLabel.h"
#import "Constants.h"
#import "TwitterRequest.h"

@interface MBConfigViewController : UIViewController <UITextFieldDelegate> {
	UIView *mainView;
	UIView *backView;
	UITextField *loginTextField;
	UITextField *passwordTextField;
	
	
	UISwitch *updateToTwitterSwitch;
	UISwitch *uploadPhotosToTwitterSwitch;
	UISwitch *useTwitterNameAndImageInGameSwitch;
	BOOL enableUpdateScoreToTwitter;
	BOOL enableUploadPhtotoToTwitter;
}

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UITextField *loginTextField;
@property (nonatomic, retain) UITextField *passwordTextField;


@end
