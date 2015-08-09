//
//  SocialPanel.h
//  bishibashi
//
//  Created by Eric on 26/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebImageView.h"
#import "FBDataSource.h"
#import "SinaConfigViewController.h"
#import "MBConfigViewController.h"
#import "GetTWUser.h"
#import "CountryTableViewController.h"
#import <GameKit/GKLeaderboardViewController.h>
#import <GameKit/GKLocalPlayer.h>


@interface SocialPanel : UIView<GetTWUserDelegate, GKLeaderboardViewControllerDelegate> {
	UIView*	_socialBackground;
	UIButton*	_fbButton;
	UIButton*	_twIcon;
	UIButton*	_mbIcon;
	UIButton*	_gcIcon;
	
	UIImageView*	_nationalFlag;
	
	WebImageView*	_fbPhoto;
	WebImageView*	_twPhoto;
	WebImageView*	_mbPhoto;
	id	_msgBoard;
	id	_owner;
	
	UITextField*	_nameInput;
	GetTWUser*	_getTWUser;
}
@property (nonatomic, retain) UITextField* nameInput;
@property (nonatomic, retain) UIView* socialBackground;
@property (nonatomic, retain) UIButton* fbButton;
@property (nonatomic, retain) UIButton* twIcon;
@property (nonatomic, retain) UIButton* mbIcon;
@property (nonatomic, retain) UIButton* gcIcon;
@property (nonatomic, retain) UIImageView* nationalFlag;

@property (nonatomic, retain) WebImageView* fbPhoto;
@property (nonatomic, retain) WebImageView* twPhoto;
@property (nonatomic, retain) WebImageView* mbPhoto;

@property (nonatomic, assign) id msgBoard;
@property (nonatomic, assign) id owner;

@property (nonatomic, retain) GetTWUser* getTWUser;
@end
