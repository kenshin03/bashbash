//
//  CreditsViewController.h
//  bishibashi
//
//  Created by Kenny Tang on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"
#import "Constants.h"


@interface CreditsViewController : UIViewController {
	UIView *mainView;
	UIScrollView* buttonsScrollView;
	NSInteger scrollIndex;
	NSInteger _selectedGame;
	id _owner;
	BOOL _isFromTransition;
	
}

@property (nonatomic, assign) BOOL isFromTransition;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic) NSInteger selectedGame;
@property (nonatomic, assign) id owner;




@end
