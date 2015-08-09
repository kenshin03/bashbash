//
//  MultiPlayersJoinGameViewController.h
//  bishibashi
//
//  Created by Kenny Tang on 9/14/10.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"

@class GameClient;

@interface MultiPlayersJoinGameViewController : UIViewController <UITableViewDelegate, VersusTransitionViewDelegate, UITableViewDataSource>{
	UITableView *_serverSelectTableView;
	NSMutableDictionary* _serverNamesList;
	VersusTransitionView *versusTransitionView;
	
}
@property (nonatomic, retain) UITableView *serverSelectTableView;
@property (nonatomic, retain) NSMutableDictionary *serverNamesList;
@property (nonatomic, retain) VersusTransitionView *versusTransitionView;

@end
