//
//  TransitionView.h
//  bishibashi
//
//  Created by Kenny Tang on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionView.h";
#import <iAd/iAd.h>
#import "MediaManager.h";
#import "Constants.h";
#import "InstructionView.h";
#import "BurgerseqInstructionView.h";
#import "JumpingGirlInstructionView.h";
#import "3boInstructionView.h"
#import "SmallnumberInstructionView.h"
#import "UFOInstructionView.h"
#import "BurgersetInstructionView.h"
#import "BignumberInstructionView.h"
#import "AlarmClockInstructionView.h"
#import "EatbeansInstructionView.h"
#import "QuickPencilInstructionView.h"
#import "3In1InstructionView.h"
#import "DancingInstructionView.h"
#import "BunHillInstructionView.h"
#import "CreditsViewController.h"
#import "AdMobDelegateProtocol.h"
#import "PentagonChart.h"
#import "DymoLabel.h"
#import "AroundTheWorldViewController.h"
#import "SnowFlakeView.h"
@protocol TransitionViewDelegate
-(void) finishedTransitionIn;
-(void) finishedTransitionOut;
@end

typedef enum _transitionViewType {
	showLevelInfo = 0,
	showLevelInstruction
} transitionViewType;

@interface TransitionView : UIView<ADBannerViewDelegate, AdMobDelegate> {
	PentagonChart* _pentagonChart;
	UIImageView*	_polaroid;

	UIImageView*	_note;
	
	BOOL bannerIsVisible;
	BOOL admobBannerIsVisible;
	transitionViewType _type;
	id <TransitionViewDelegate> delegate;

	NSInteger currentGame;
	NSInteger levelNumber;
	NSInteger levelScore;
	NSDictionary* gameNamesDictionary;
	NSDictionary* gameInstructionsDictionary;
	
	DymoLabel* _levelInfoLevelNumberLabel;
	DymoLabel* _levelInfoLevelNameLabel;
	NSMutableArray* _levelInfoLevelScriptsLabel;
	UILabel* _levelInstructionsTitleLabel;
	NSMutableArray* _levelInstructionsGameInstructionsLabels;
	InstructionView* _levelInstructionsView;
	
	UIButton* _toPlayBtn;
	UIButton* _toPlayLbl;
	UIButton* _infoBut;
	UIButton* _mapBut;
	
	UIView* _mainView;
	ADBannerView*	_iAdBannerView;
	AdMobView* _adMobView;
	
	MediaManager *sharedSoundEffectsManager;
	Constants *constantsInstance;
	SnowFlakeView*	_snowFlakeView;
}
//@property (nonatomic, assign) NSDictionary *gameNamesDictionary;
//@property (nonatomic, assign) NSDictionary *gameInstructionsDictionary;

@property (nonatomic, retain) UIImageView* note;
@property (nonatomic, retain) PentagonChart* pentagonChart;
@property (nonatomic, retain) UIImageView* polaroid;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, assign) BOOL admobBannerIsVisible;
@property(nonatomic, retain) ADBannerView* iAdBannerView;
@property(nonatomic, retain) AdMobView* adMobView;
@property (nonatomic, assign) 	UIInterfaceOrientation orientation;
@property( nonatomic, retain) UIButton* toPlayBtn;
@property (nonatomic, retain) UIButton* toPlayLbl;
@property (nonatomic, retain) UIButton* infoBut;
@property (nonatomic, retain) UIButton* mapBut;
@property (nonatomic) NSInteger levelNumber;
@property (nonatomic) NSInteger levelScore;
@property (nonatomic) NSInteger currentGame;
@property (assign, nonatomic) id <TransitionViewDelegate> delegate;
@property (retain, nonatomic) DymoLabel* levelInfoLevelNumberLabel;
@property (retain, nonatomic) DymoLabel* levelInfoLevelNameLabel;
@property (retain, nonatomic) NSMutableArray* levelInfoLevelScriptsLabel;
@property (retain, nonatomic) UILabel* levelInstructionsTitleLabel;
@property (retain, nonatomic) NSMutableArray* levelInstructionsGameInstructionsLabels;
@property (retain, nonatomic) InstructionView* levelInstructionsView;
@property (retain, nonatomic) UIView* mainView;

@property (nonatomic, retain) SnowFlakeView* snowFlakeView;

- (id)initWithFrame:(CGRect)frameRect;
- (void)showTransitionInGameTitle;
- (void)hideTransitionInGameTitle;
- (void)showTransitionOut;
- (void)hideTransitionOut;

//- (void)showLevelInstructions:(NSDictionary*)gameInstructionsDictionary;
- (void)showLevelInstructions;

@end
