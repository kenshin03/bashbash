//
//  PentagonChartViewController.h
//  bishibashi
//
//  Created by Eric on 22/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PentagonChart.h"
#import "Constants.h"
#import "GameRecordMenuViewController.h"
#import "LocalStorageManager.h"
#import "StampCollectionViewController.h"
#import "SocialPanel.h"
#import "VideoTableViewController.h"
#import "AroundTheWorldViewController.h"

@interface PentagonChartViewController : UIViewController {
	UIImageView*	_redLabel;
	UIImageView*	_gameFrame;
	UIImageView*	_polaroid;
	UIImageView*	_note;
	PentagonChart* _theChart;
	UILabel* _titleLabel;
	UILabel* _totalScore;
	UILabel* _rank;
	UIButton* _redBut;
	UIButton* _greenBut;
	UIButton* _blueBut;
	UIView* _bottomPanel;
	NSArray* _nickNames;
	id _gameView;
	
	// for after game panels
	UIImageView* _submitPanel;
	UIImageView* _replayPanel;
	UIButton*	_gcBut;
	UIButton*	_submitScoreBut;
	UIButton*	_readScoreBut;
	UIButton*	_replayBut;
	UIButton*	_homeBut;

	
	UIButton*	_socialBut;
	UIButton*	_infoBut;
	UIButton*	_globeBut;
	UIButton*	_soundBut;
	UIButton*	_exitBut;
	
	UIActivityIndicatorView*	_submitAi;
	
	SocialPanel*	_socialPanel;
}
@property (nonatomic, retain) UIImageView* redLabel;
@property (nonatomic, retain) UIImageView* note;
@property (nonatomic, retain) UIImageView* polaroid;
@property (nonatomic, retain) UIImageView* gameFrame;
@property (nonatomic, retain) PentagonChart* theChart;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* totalScore;
@property (nonatomic, retain) UILabel* rank;
@property (nonatomic, retain) UIButton* redBut;
@property (nonatomic, retain) UIButton* greenBut;
@property (nonatomic, retain) UIButton* blueBut;
@property (nonatomic, retain) UIView* bottomPanel;
@property (nonatomic, assign) id gameView;
@property (nonatomic, retain) NSArray* nickNames;
@property (nonatomic, retain) UIButton* socialBut;
@property (nonatomic, retain) UIButton* infoBut;
@property (nonatomic, retain) UIButton* globeBut;
@property (nonatomic, retain) UIButton* soundBut;
@property (nonatomic, retain) UIButton* exitBut;

@property (nonatomic, retain) UIButton* gcBut;
@property (nonatomic, retain) UIButton* submitScoreBut;
@property (nonatomic, retain) UIButton* readScoreBut;
@property (nonatomic, retain) UIButton* replayBut;
@property (nonatomic, retain) UIButton* homeBut;

@property (nonatomic, retain) UIImageView* replayPanel;
@property (nonatomic, retain) UIImageView* submitPanel;
@property (nonatomic, retain) SocialPanel* socialPanel;
@property (nonatomic, retain) UIActivityIndicatorView* submitAi;
-(id) initWithScore:(int)score AndScores:(NSArray*)scoress AndNumGame:(int)numGames AndGameView:(id) gameView AndPass:(BOOL)pass;

@end
