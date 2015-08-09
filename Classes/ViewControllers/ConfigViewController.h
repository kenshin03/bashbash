//
//  ConfigViewController.h
//  bishibashi
//
//  Created by Eric on 12/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LocalStorageManager.h"
#import "CountryTableViewController.h"
#import "GameFrameSelectionViewController.h"
#import "UILanguageSelectionViewController.h"
#import "MBConfigViewController.h"
#import "SinaConfigViewController.h"
#import "Baby.h"
#import "ImageSettingsViewController.h"
#import "FBDataSource.h"

@interface ConfigViewController : UITableViewController <FBDataSourceDelegate>{
	UITextField*	name;
	UISwitch				*switchCtl;
	BOOL	usePhoto;
	
	UIButton				*_takePhotoButLeft;
	UIButton				*_takePhotoButCenter;
	UIButton				*_takePhotoButRight;

	UIImageView				*_leftHeadView;
	UIImageView				*_rightHeadView;
	UIImageView				*_centerHeadView;
	UIImageView				*_leftBodyView;
	UIImageView				*_rightBodyView;
	UIImageView				*_centerBodyView;
	
	int _state;
	
	UITableViewCell			*_facebookLoginOutCell;
	UILabel				*_facebookLoginUserName;
	
}
@property (nonatomic, retain) UISwitch *switchCtl;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, assign) BOOL usePhoto;
@property (nonatomic, retain) UIButton		*takePhotoButLeft;
@property (nonatomic, retain) UIButton		*takePhotoButCenter;
@property (nonatomic, retain) UIButton		*takePhotoButRight;

@property (nonatomic, retain) UIImageView	*	leftHeadView;
@property (nonatomic, retain) UIImageView	*	rightHeadView;
@property (nonatomic, retain) UIImageView	*	centerHeadView;
@property (nonatomic, retain) UIImageView	*	leftBodyView;
@property (nonatomic, retain) UIImageView	*	rightBodyView;
@property (nonatomic, retain) UIImageView	*	centerBodyView;
@property (nonatomic, retain) UITableViewCell	*	facebookLoginOutCell;
@property (nonatomic, retain) UILabel	*	facebookLoginUserName;


@property (nonatomic, assign) int state;
@end
