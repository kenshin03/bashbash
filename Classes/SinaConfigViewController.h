//
//  SinaConfigViewController.h
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"


@interface SinaConfigViewController : UIViewController {
	UIView *mainView;
	UITextField *loginTextField;
	UITextField *passwordTextField;
}

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UITextField *loginTextField;
@property (nonatomic, retain) UITextField *passwordTextField;


@end
