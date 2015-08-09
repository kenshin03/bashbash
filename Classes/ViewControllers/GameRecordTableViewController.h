//
//  GameRecordTableViewController.h
//  bishibashi
//
//  Created by Eric on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRecord.h"
#import "LocalStorageManager.h"
#import "GameRecordTVC.h"
#import "GetGameRecord.h"
#import "CustomTerminalBoardView.h"
#import <MapKit/MapKit.h>
#import "PinAnnotation.h"

@interface GameRecordTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GetGameRecordDelegate, UIScrollViewDelegate>{
	BOOL _isPlayingSound;
	
	MediaManager *sharedSoundEffectsManager;
	
	UIScrollView* _gameSelectionView;
	BOOL _gameSelectionViewShown;
	NSArray* _intervalLbls;
	NSMutableArray* _tables;
	NSDictionary*	_gamesRecords;
	int	_section;
	UISegmentedControl* _placeSeg;
	GetGameRecord*	_getter;
	CLLocationManager*	_locationManager;
	float	_gps_x;
	float	_gps_y;
	BOOL _hasGps;
	NSTimer*	_theTimer;
	NSMutableArray*	_terminalViews;
	NSMutableArray*	_standbyTerminalViews;
	
	UIPageControl*	_pageControl;
	UIScrollView*	_scrollView;
	UIButton* _clearRecordBut;
	
	Locality _locality;
	
	UIView*	_landscapeView;
}
@property (nonatomic, assign) BOOL isPlayingSound;
@property (nonatomic, assign) BOOL gameSelectionViewShown;
@property (nonatomic, retain) UIScrollView* gameSelectionView;
@property (nonatomic, retain) NSArray* intervalLbls;
@property (nonatomic, retain) NSMutableArray* tables;
@property (nonatomic, copy) NSDictionary* gamesRecords;
@property (nonatomic, assign) int section;
@property (nonatomic, retain) UISegmentedControl* placeSeg;
@property (nonatomic, retain) GetGameRecord* getter;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, assign) float gps_x;
@property (nonatomic, assign) float gps_y;
@property (nonatomic, assign) BOOL hasGps;

@property (nonatomic, retain) NSTimer* theTimer;
@property (nonatomic, retain) NSMutableArray* terminalViews;
@property (nonatomic, retain) NSMutableArray* standbyTerminalViews;
@property (nonatomic, retain) UIPageControl*	pageControl;
@property (nonatomic, retain) UIScrollView* scrollView;

@property (nonatomic, retain) UIButton* clearRecordBut;
@property (nonatomic, assign) Locality locality;
@property (nonatomic, retain) UIView* landscapeView;
@end

@interface GameRecordLandscapeView : UIView {
	id _owner;
	NSDictionary*	_gameRecords;
	CLLocationManager					*_locationManager;
	MKMapView							*_mapView;
	
	NSMutableArray						*_pins;
	float								_centerX;
	float								_centerY;
	CLLocation							*_userLocation;
	BOOL								_showUserLocation;
	
}
@property (nonatomic, assign) NSDictionary* gameRecords;
@property (nonatomic, assign) id owner;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *pins;

@property (nonatomic, assign) float centerX;
@property (nonatomic, assign) float centerY;
@property (nonatomic, retain) CLLocation* userLocation;
@property (nonatomic, assign) BOOL showUserLocation;
@end