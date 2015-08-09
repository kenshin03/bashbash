//
//  BillBoard.h
//  bishibashi
//
//  Created by Eric on 11/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "LocalStorageManager.h"
#import "GameCenterManager.h"
#import "Pin.h"

@interface BillBoardInner : UIView {
	NSArray* _posters;
	CGSize _posterSize;
	id	_owner;
	NSArray*	_pins;
	GameLevel	_gameLevel;
	GameMode	_gameMode;
}
@property (nonatomic, assign) GameLevel gameLevel;
@property (nonatomic, assign) GameMode gameMode;
@property(nonatomic, assign) CGSize posterSize;
@property(nonatomic, retain) NSArray* posters;
@property(nonatomic, assign) id owner;
@property (nonatomic, retain) NSArray* pins;

@end

@interface BillBoard: UIView{
	UIScrollView*	_scrollView;
	UIImageView* _billBoardBottom;
	BillBoardInner*	_theInner;
	int	_colorIdx;
	int _counter;
	int _offset;
	BOOL _add;
	NSTimer* _theTimer;
}
@property(nonatomic, retain) NSTimer *theTimer;
@property(nonatomic, assign) int colorIdx;
@property(nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic, retain) UIImageView* billBoardBottom;
@property(nonatomic, retain) BillBoardInner* theInner;
@end
