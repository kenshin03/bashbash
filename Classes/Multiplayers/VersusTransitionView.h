//
//  VersusTransitionView.h
//  bishibashi
//
//  Created by ktang on 9/28/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerProfilePacket.h"
#import "MediaManager.h"
#import "WebImageView.h"
#import "Constants.h"
@interface VersusTransitionProfileBottom:UIView{
	NSString* profileName;
	UIImageView* profileImageView;
	WebImageView*	_webImageView;
	UILabel*	_playerTextLabel;
	UIImageView* _countryFlag;
	UILabel*	_playerMatchesTextLabel;
}
@property (nonatomic, retain) WebImageView* webImageView;
@property (nonatomic, assign) NSString *profileName;
@property (nonatomic, assign) UIImageView *profileImageView;
@property (nonatomic, retain) UILabel* playerTextLabel;
@property (nonatomic, retain) UIImageView* countryFlag;
@property (nonatomic, retain) UILabel* playerMatchesTextLabel;
- (id) initWithFrame:(CGRect)frameRect  WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose WithNumMatches:(NSInteger)numMatches WithNumWins:(NSInteger) numWins;

@end


@interface VersusTransitionProfileTop:UIView{
	NSString* profileName;
	UIImageView* profileImageView;
	WebImageView*	_webImageView;
	UILabel*	_playerTextLabel;
	UIImageView* _countryFlag;
	UILabel*	_playerMatchesTextLabel;
}
@property (nonatomic, retain) WebImageView* webImageView;
@property (nonatomic, assign) NSString *profileName;
@property (nonatomic, assign) UIImageView *profileImageView;
@property (nonatomic, retain) UILabel* playerTextLabel;
@property (nonatomic, retain) UIImageView* countryFlag;
@property (nonatomic, retain) UILabel* playerMatchesTextLabel;
- (id) initWithFrame:(CGRect)frameRect  WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose WithNumMatches:(NSInteger)numMatches WithNumWins:(NSInteger) numWins;
@end

@protocol VersusTransitionViewDelegate <NSObject>
- (void)hideTransitionView;

@end



@interface VersusTransitionView : UIView {
	MediaManager *sharedSoundEffectsManager;
	NSString* _serverPeerID;
	NSString* _serverPlayerName;
	NSString* _serverFacebookImageURL;
	
	NSString* _peerPeerID;
	NSString* _peerPlayerName;
	NSString* _peerFacebookImageURL;
	
	VersusTransitionProfileTop* _profileTopView;
	VersusTransitionProfileBottom* _profileBottomView;
	id<VersusTransitionViewDelegate> versusTransitionViewDelegate;
	
	UILabel* _gameName;
	UILabel*	_roundLbl;
	UIImageView*	_gameLogo;
	UIButton*	_forwardBut;
	
	// game selected
	// difficulty
	// peer score
	// server score
	Game	_theGame;
	int	_roundNo;
	
}
@property (nonatomic, assign) id owner;
@property (nonatomic, assign) NSString *serverPeerID;
@property (nonatomic, assign) NSString *serverPlayerName;
@property (nonatomic, assign) NSString *serverFacebookImageURL;
@property (nonatomic, assign) NSString *peerPeerID;
@property (nonatomic, assign) NSString *peerPlayerName;
@property (nonatomic, assign) NSString *peerFacebookImageURL;
@property (nonatomic, retain) VersusTransitionProfileTop *profileTopView;
@property (nonatomic, retain) VersusTransitionProfileBottom *profileBottomView;
@property (nonatomic, assign) Game theGame;
@property (nonatomic, assign) int roundNo;

@property (nonatomic, retain) UILabel* gameName;
@property (nonatomic, retain) UILabel* roundLbl;
@property (nonatomic, retain) UIImageView* gameLogo;
@property (nonatomic, retain) UIButton* forwardBut;

@property (assign) id<VersusTransitionViewDelegate> versusTransitionViewDelegate;


- (id) initWithFrame:(CGRect)frameRect server:(PlayerProfilePacket*)serverPacket peer:(PlayerProfilePacket*)peerPacket;
- (id) initWithFrame:(CGRect)frameRect  WithAlias:(NSString*)alias WithImageUrl:(NSString*) imageUrl WithOpponentAlias:(NSString*)opponentAlias WithOpponentImageUrl:(NSString*)opponentImageUrl 
		WithNumRoundWin:(NSInteger)numRoundWin WithNumRoundLose:(NSInteger)numRoundLose 
		WithMyNumMatches:(NSInteger)myNumMatches WithMyNumWins:(NSInteger)myNumWins 
		WithOpponentNumMatches:(NSInteger)opponentNumMatches WithOpponentNumWins:(NSInteger)opponentNumWins;
@end