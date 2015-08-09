//
//  MenuController.h
//  bishibashi
//
//  Created by ktang on 10/25/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GameCenterManager.h"
#import "UILanguageSelectionViewController.h"
#import "AroundTheWorldViewController.h"
#import "VideoTableViewController.h"
#import "GameCenterManager.h"
#import "BillBoard.h"
#import "GameRecordMenuViewController.h"
#import "StampCollectionViewController.h"
#import "ImageSettingsViewController.h"
#import "FontLabel.h"
#import "FBConfigViewController.h"
#import "GetMsg.h"
#import "MultiPlayersJoinGameViewController.h"

@interface MenuController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, GetMsgDelegate, UITableViewDelegate, UITableViewDataSource>{
	UIImageView *_backgroundImageView;
	MediaManager *_sharedSoundEffectsManager;
	UIView *_mainOptionsView;
	UIView *_singlePlayerOptionsView;
	UIView *_gameCenterOptionsView;
	UIView *_arcadeModeDifficultyView;
	UIView *_freeSelectDifficultyView;
	UIView *_randomFiveModeDifficultyView;
	UIView *_versusFreeSelectDifficultyView;
	UIView *_versusOptionsView;
	UIView *_settingOptionsView;
	UIView *_versusCreateGameOptionsView;
	UIView *_levelSelectPaneView;
	UIView *_versusModeLevelSelectPaneView;
	UIView *_communityMenuView;
	UIView *_meCommunityOverlayView;
	UIView *_communityCommunityOverlayView;
	UIScrollView *_meCommunityScrollViewContentsView;
	UITableView* _newsTableView;
	NSArray* _msgs;
	UIImageView* _gcLeaderBoardImageView;
	UIButton* _gcLeaderBoardButton;
	UIAlertView*	_waitingForClientsAlertView;
	
	BillBoard* _billBoard;
	BillBoard* _multiPlayerBillBoard;
	FontLabel *soundOnOffLabel;
	FontLabel *musicOnOffLabel;
	UIImageView* mePhotoImageView;
	UITextField *myNameTextField;
	GetMsg*	_msgGetter;
	
	BOOL showingOverlay;
	BOOL showingMeOverlay;
	BOOL showingCommunityOverlay;
	BOOL showingNewsOverlay;
	
	GameViewController *_gameViewController;
}
@property(nonatomic, assign) MediaManager* sharedSoundEffectsManager;
@property(nonatomic, retain) UIImageView* backgroundImageView;
@property(nonatomic, retain) UIView* mainOptionsView;

@property(nonatomic, retain) UIView* singlePlayerOptionsView;
@property(nonatomic, retain) UIView* gameCenterOptionsView;
@property(nonatomic, retain) UIView* arcadeModeDifficultyView;
@property(nonatomic, retain) UIView* randomFiveModeDifficultyView;
@property(nonatomic, retain) UIView* freeSelectDifficultyView;
@property(nonatomic, retain) UIView* versusFreeSelectDifficultyView;
@property(nonatomic, retain) UIView* versusCreateGameOptionsView;
@property(nonatomic, retain) UIScrollView* meCommunityScrollViewContentsView;

@property(nonatomic, retain) UIImageView* gcLeaderBoardImageView;
@property(nonatomic, retain) UIButton* gcLeaderBoardButton;


@property(nonatomic, retain) UIView* versusOptionsView;
@property(nonatomic, retain) UIView* settingOptionsView;
@property(nonatomic, retain) UIView* levelSelectPaneView;
@property(nonatomic, retain) UIView* versusModeLevelSelectPaneView;
@property(nonatomic, retain) UIView* communityMenuView;
@property(nonatomic, retain) UIView* meCommunityOverlayView;
@property(nonatomic, retain) UIView* newsCommunityOverlayView;
@property(nonatomic, retain) UIView* communityCommunityOverlayView;

@property(nonatomic, retain) UIImageView* mePhotoImageView;
@property(nonatomic, retain) BillBoard* billBoard;
@property(nonatomic, retain) BillBoard* multiPlayerBillBoard;
@property(nonatomic, retain) GameViewController* gameViewController;
@property(nonatomic, retain) FontLabel* soundOnOffLabel;
@property(nonatomic, retain) FontLabel* musicOnOffLabel;
@property(nonatomic, retain) UITextField* myNameTextField;
@property (nonatomic, retain) GetMsg* msgGetter;
@property (nonatomic, retain) UITableView* newsTableView;
@property (nonatomic, retain) NSArray* msgs;
@property (nonatomic, retain) UIAlertView* waitingForClientsAlertView;

- (void)initTitleLogo;
- (void)initFooterText;



@end
