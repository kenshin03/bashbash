//
//  StampCollectionViewController.h
//  bishibashi
//
//  Created by Eric on 30/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ExpandBox.h"
#import "Pin.h"
#import "LocalStorageManager.h"
#import "NSDateExtension.h"
#import "FBDataSource.h"
#import <GameKit/GameKit.h>
#import "GKAchievement-Bashbash.h"
@interface StampCollectionViewController : UIViewController {
	NSArray*	_pins;
	NSArray*	_otherpins;
	NSMutableArray*	_pinTexts1;
	NSMutableArray*	_pinTexts2;
	NSMutableArray*	_otherPinTexts1;
	NSMutableArray*	_otherPinTexts2;

	NSMutableArray*	_stamps;
	NSMutableArray*	_otherstamps;
	ExpandBox* _theExpandBox;
	
	UIImageView*	_topLetterBar;
	UIImageView*	_bottomLetterBar;
	UIImageView*	_stampChop;
	UIImageView*	_backBut;
	
	UIPageControl*	_pageControl;
	UIScrollView*	_scrollView;

}
@property (nonatomic, retain) NSMutableArray* pinTexts1;
@property (nonatomic, retain) NSMutableArray* pinTexts2;
@property (nonatomic, retain) NSMutableArray* otherPinTexts1;
@property (nonatomic, retain) NSMutableArray* otherPinTexts2;

@property (nonatomic, retain) NSArray* pins;
@property (nonatomic, retain) NSArray* otherpins;
@property (nonatomic, retain) ExpandBox* theExpandBox;
@property (nonatomic, retain) NSMutableArray* stamps;
@property (nonatomic, retain) NSMutableArray* otherstamps;

@property (nonatomic, retain) UIImageView* topLetterBar;
@property (nonatomic, retain) UIImageView* bottomLetterBar;
@property (nonatomic, retain) UIImageView* stampChop;

@property (nonatomic, retain) UIImageView* backBut;

@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) UIScrollView*	scrollView;
@end
