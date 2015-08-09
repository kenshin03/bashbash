//
//  ConfigView.h
//  bishibashi
//
//  Created by Eric on 19/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"
#import "CountryTableViewController.h"
#import "Constants.h"

@interface ConfigView : UIViewController<UIImagePickerControllerDelegate> {
	UISwitch				*_usePhoto;
	UILabel					*_usePhotoLbl;
	UIButton				*_takePhotoButLeft;
	UIButton				*_takePhotoButCenter;
	UIButton				*_takePhotoButRight;
	UIButton				*_backToGameBut;
	id						_delegate;
	
	UIImageView				*_leftHeadView;
	UIImageView				*_rightHeadView;
	UIImageView				*_centerHeadView;
	UIImageView				*_leftBodyView;
	UIImageView				*_rightBodyView;
	UIImageView				*_centerBodyView;
	
	UISegmentedControl*	_gameLevelSegCtrl;
	UILabel* _gameLevelLabel;
	UIButton* _countryButton;
	UIButton* _languageButton;
	
	UITextField*	_userName;
	
	id _gameView;
	id _owner;
	
	int _state;
	
	BOOL _keyboardShown;
}
@property (nonatomic, retain) UILabel		*usePhotoLbl;
@property (nonatomic, retain) UISwitch		*usePhoto;
@property (nonatomic, retain) UIButton		*takePhotoButLeft;
@property (nonatomic, retain) UIButton		*takePhotoButCenter;
@property (nonatomic, retain) UIButton		*takePhotoButRight;
@property (nonatomic, retain) UIButton		*backToGameBut;
@property (nonatomic, assign) id			delegate;
@property (nonatomic, assign) id gameView;
@property (nonatomic, assign) id owner;

@property (nonatomic, retain) UISegmentedControl *gameLevelSegCtrl;
@property (nonatomic, retain) UILabel *gameLevelLabel;
@property (nonatomic, retain) UIButton *countryButton;
@property (nonatomic, retain) UIButton *languageButton;

@property (nonatomic, retain) UIImageView	*leftHeadView;
@property (nonatomic, retain) UIImageView	*rightHeadView;
@property (nonatomic, retain) UIImageView	*centerHeadView;
@property (nonatomic, retain) UIImageView	*leftBodyView;
@property (nonatomic, retain) UIImageView	*rightBodyView;
@property (nonatomic, retain) UIImageView	*centerBodyView;
@property (nonatomic, retain) UITextField	*userName;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) BOOL keyboardShown;
- (id) init;

@end