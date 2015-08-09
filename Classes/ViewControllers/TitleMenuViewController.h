//
//  TitleMenuViewController.h
//  bishibashi
//
//  Created by kenny on 26/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"
#import "GameViewController.h"
#import "GameRecordMenuViewController.h"
#import "Constants.h"
#import "ConfigViewController.h"
#import "BillBoard.h"
#import "FBDataSource.h"
#import "SinaConfigViewController.h"
#import "MBConfigViewController.h"
#import "WebImageView.h"
#import "FBDataSource.h"
#import "MsgBoard.h"
#import "SocialPanel.h"
#import "VideoTableViewController.h"
#import "StampCollectionViewController.h"
#import "AroundTheWorldViewController.h"
#import "FBViewController.h"
#import "Pin.h"
#import "GameCenterManager.h"
#import "MultiPlayersJoinGameViewController.h"
#import "SnowFlakeView.h"

@class GameViewController;



@interface TitleMenuViewController : UIViewController <UIScrollViewDelegate, GKPeerPickerControllerDelegate, FBDialogDelegate>{
	MsgBoard*	_msgBoard;
	SocialPanel*	_socialPanel;
	
	UIButton*	_stampBut;
	UIButton*	_fbBut;
	UIButton*	_youtubeBut;
	UIButton*	_mapBut;
	UIButton*	_soundBut;
	UIButton*	_redBut;
	UIButton*	_blueBut;
	UIButton*	_greenBut;
	UIButton* _backBut;
	UIButton* _multiPlayerBackBut;
	id _owner;
	UIImageView *_logoImageView;
	UIView *_onePlayerButtonsPaneView;
	UIView *_onePlayerButtonsDifficultiesSelectView;
	UIView *_multiPlayersButtonsPaneView;
	UIView *_multiPlayersButtonsDifficultiesSelectView;
	UIView *_extraButtonsPaneView;
	UIView *_levelSelectPaneView;
	UIView *_multiPlayersLevelSelectPaneView;
	UIScrollView *_multiPlayersLevelSelectScrollView;
	
	
	BillBoard* _billBoard;
	BillBoard* _multiPlayerBillBoard;
	UIImageView *_newBottomPanel;
	currrentMenuScreen _currentMenu;
	MediaManager *_sharedSoundEffectsManager;
	BOOL	_isFreeGame;
	BOOL	_isLite;
	
	float _difficultiesLevel;
	UIPageControl* _multiPlayersLevelSelectPageControl;
	
	NSInteger _selectedGame;
	
	
	BOOL shouldContinueBlinking;
	
	UIButton*	_masterLevelSelectButton;
	UIAlertView*	_waitingForClientsAlertView;
}
@property (nonatomic, retain) MsgBoard* msgBoard;

@property (nonatomic, retain) SocialPanel* socialPanel;

@property(nonatomic, retain) BillBoard* billBoard;
@property(nonatomic, retain) BillBoard* multiPlayerBillBoard;

@property(nonatomic, retain) UIButton* stampBut;
@property(nonatomic, retain) UIButton* fbBut;
@property (nonatomic, retain) UIButton* youtubeBut;
@property (nonatomic, retain) UIButton* mapBut;
@property (nonatomic, retain) UIButton* soundBut;

@property (nonatomic, retain) UIButton* masterLevelSelectButton;
@property(nonatomic, retain) UIButton* redBut;
@property(nonatomic, retain) UIButton* greenBut;
@property(nonatomic, retain) UIButton* blueBut;
@property(nonatomic, retain) UIButton* backBut;
@property(nonatomic, retain) UIButton* multiPlayerBackBut;
@property(nonatomic, retain) UIImageView* logoImageView;
@property(nonatomic, retain) UIView* onePlayerButtonsPaneView;
@property(nonatomic, retain) UIView* onePlayerButtonsDifficultiesSelectView;
@property(nonatomic, retain) UIView* extraButtonsPaneView;
@property(nonatomic, retain) UIView* levelSelectPaneView;
@property(nonatomic, retain) UIView* multiPlayersButtonsPaneView;
@property(nonatomic, retain) UIView* multiPlayersButtonsDifficultiesSelectView;
@property(nonatomic, retain) UIView* multiPlayersLevelSelectPaneView;
@property(nonatomic, retain) UIPageControl* multiPlayersLevelSelectPageControl;
@property(nonatomic, retain) UIScrollView* multiPlayersLevelSelectScrollView;


@property(nonatomic, assign) MediaManager* sharedSoundEffectsManager;
@property(nonatomic, retain) UIImageView* newBottomPanel;
@property(nonatomic, assign) currrentMenuScreen currentMenu;
@property(nonatomic, assign) BOOL isFreeGame;
@property(nonatomic, assign) BOOL isLite;
@property (nonatomic, assign) id owner;
@property (nonatomic, assign) float difficultiesLevel;
@property(nonatomic, assign) NSInteger selectedGame;

@property (nonatomic, retain) UIAlertView* waitingForClientsAlertView;

- (IBAction)changePage:(id)sender;

@end
