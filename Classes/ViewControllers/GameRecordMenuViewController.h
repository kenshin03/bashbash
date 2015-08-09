//
//  GameRecordMenuViewController.h
//  bishibashi
//
//  Created by Eric on 19/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTerminalBoardView.h"
#import "GameRecordTableViewController.h"
#import "MediaManager.h"

@interface GameRecordMenuViewController : UITableViewController {
	BOOL _isPlayingSound;
	MediaManager *sharedSoundEffectsManager;

	NSMutableArray* _terminalViews;
	NSMutableArray* _standbyTerminalViews;
	NSTimer* _theTimer;
	int _section;
}
@property (nonatomic, assign) BOOL isPlayingSound;
@property (nonatomic, assign) int section;
@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, retain) NSMutableArray* terminalViews;
@property (nonatomic, retain) NSMutableArray* standbyTerminalViews;
@end
