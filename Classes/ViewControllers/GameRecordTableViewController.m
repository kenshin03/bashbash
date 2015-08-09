//
//  GameRecordTableViewController.m
//  bishibashi
//
//  Created by Eric on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRecordTableViewController.h"


@implementation GameRecordTableViewController
@synthesize isPlayingSound = _isPlayingSound;
@synthesize gameSelectionView = _gameSelectionView;
@synthesize gameSelectionViewShown = _gameSelectionViewShown;

@synthesize intervalLbls = _intervalLbls;
@synthesize gamesRecords = _gamesRecords;
@synthesize section = _section;
@synthesize placeSeg = _placeSeg;
@synthesize getter = _getter;
@synthesize locationManager = _locationManager;
@synthesize gps_x = _gps_x;
@synthesize gps_y = _gps_y;
@synthesize hasGps = _hasGps;

@synthesize theTimer = _theTimer;
@synthesize terminalViews = _terminalViews;
@synthesize standbyTerminalViews = _standbyTerminalViews;

@synthesize pageControl = _pageControl;
@synthesize scrollView = _scrollView;
@synthesize tables = _tables;
@synthesize locality = _locality;
@synthesize landscapeView = _landscapeView;
@synthesize clearRecordBut = _clearRecordBut;

#pragma mark Public Methods
- (id)initWithStyle:(UITableViewStyle)style AndSection:(int)section AndLocality:(Locality)locality
{
	if (self = [super init])	{
		switch (locality)	{
			case (klocal):
				self.title = NSLocalizedString(@"市內線",nil);
				break;
			case (knearby):
				self.title = NSLocalizedString(@"本地線",nil);
				break;
			case (kcountry):
				self.title = NSLocalizedString(@"國內線",nil);
				break;
			case (kworld):
				self.title = NSLocalizedString(@"國際線",nil);
				break;
		}					
		
		self.locality = locality;
		self.section = section;
		GetGameRecord* getter = [[GetGameRecord alloc]initWithDelegate:self];
		self.getter = getter;
		[getter release];
		self.gameSelectionViewShown = NO;
		self.view.backgroundColor = [UIColor grayColor];
		
		self.clearRecordBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[self.clearRecordBut addTarget:self action:@selector(clearRecordButClicked) forControlEvents:UIControlEventTouchUpInside];
		self.clearRecordBut.frame = CGRectMake(0,0,220,36);
		self.clearRecordBut.backgroundColor = [UIColor clearColor];
		[self.clearRecordBut setTitle:@"Clear Local Records" forState:UIControlStateNormal];

		UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, 320, 480-22-44)];
		self.scrollView = scrollView;
		[scrollView release];
		[self.view addSubview:self.scrollView];
		
		int noTables;
		if (self.locality == klocal)
			noTables = 2;
		else
			noTables = 4;
		self.tables = [NSMutableArray arrayWithCapacity:noTables];
		for  (int i=0; i<noTables; i++)	{
			UITableView* table  = [[UITableView alloc] initWithFrame:CGRectMake(i*320,0, 320, 480-22-44) style:style];
			[self.tables addObject:table];
			table.dataSource = self;
			table.delegate = self;
			table.rowHeight=43;
			table.sectionHeaderHeight=CELLHEIGHT;
			table.separatorColor=[UIColor blackColor];
			table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
			table.backgroundColor = [UIColor blackColor];
			[self.scrollView addSubview:table];
			[table release];			
		}
		
		self.hasGps = NO;
		
		self.terminalViews = [NSMutableArray arrayWithCapacity:10];
		self.standbyTerminalViews = [NSMutableArray arrayWithCapacity:10];
		[self initLocationManager];
		[self initPageControl];
		[self initGameSelection];
	
		sharedSoundEffectsManager = [MediaManager sharedInstance];
		if (self.locality==klocal)	{
			self.intervalLbls = [[NSArray alloc] initWithObjects:NSLocalizedString(@"最近",nil), NSLocalizedString(@"最高",nil), nil];
		}
		else {
			self.intervalLbls = [[NSArray alloc] initWithObjects:NSLocalizedString(@"本日",nil), NSLocalizedString(@"本週",nil), NSLocalizedString(@"本月",nil), NSLocalizedString(@"全部",nil), nil];
		}
		[self getGameRecords];
		
	}
	return self;
}

#pragma mark Parent Class Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	if (self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)	
		[self.pageControl removeFromSuperview];
	else {
		self.pageControl.frame = CGRectMake(0,0,320,22);
		[self.view addSubview:self.pageControl];
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation==UIInterfaceOrientationLandscapeRight)	{
		if (!self.landscapeView)	{
			GameRecordLandscapeView* tmp3 = [[GameRecordLandscapeView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) andOwner:self andGameRecords:self.gamesRecords];
			self.landscapeView = tmp3;
			[tmp3 release];
		}
		
		[self.navigationController setNavigationBarHidden:YES];
		[self.scrollView removeFromSuperview];
		[self.pageControl removeFromSuperview];
		[self.view addSubview:self.landscapeView];
	}
	
	else	{
		[self.navigationController setNavigationBarHidden:NO];
		[self.view addSubview:self.scrollView];
		self.pageControl.frame = CGRectMake(0,0,320,22);
		[self.view addSubview:self.pageControl];
		[self.landscapeView removeFromSuperview];
		self.landscapeView = nil;
	}
}

- (void)viewDidLoad
{
	// segmented control as the custom title view
	/*
	 NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Local", @"NearBy", @"Country", @"World", nil];
	 UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	 segmentedControl.selectedSegmentIndex = 0;
	 segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	 segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	 segmentedControl.frame = CGRectMake(0, 0, 400, 33);
	 [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	 
	 //defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	 
	 self.navigationItem.titleView = segmentedControl;
	 self.placeSeg = segmentedControl;
	 [segmentedControl release];
	 */
	NSString* gameName;
	if (self.section==-1)
		gameName = NSLocalizedString(@"所有",nil);
	else if (self.section == -2)
		gameName = NSLocalizedString(@"街機模式",nil);		
	else
		gameName = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.section]];
	UIBarButtonItem* gameBut = [[UIBarButtonItem alloc] initWithTitle:gameName style:UIBarButtonItemStyleBordered target:self action:@selector(gameButClicked:)];
	self.navigationItem.rightBarButtonItem = gameBut;
	[gameBut release];
	[super viewDidLoad];
	
}


- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[super viewWillAppear:animated];
	/*
	 UISegmentedControl *segmentedControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
	 
	 // Before we show this view make sure the segmentedControl matches the nav bar style
	 if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent || self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
	 segmentedControl.tintColor = [UIColor darkGrayColor];
	 else
	 segmentedControl.tintColor = defaultTintColor;
	 */
}

- (void) viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];
//	NSArray* gameRecords = [self.gamesRecords objectForKey:[NSNumber numberWithInt:self.section]];
	//	if (gameRecords)
	//	[[self.tables objectAtIndex:self.pageControl.currentPage] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	NSLog(@"viewDidUnload GameRecordTVC");
	[super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated {
	NSLog(@"viewDidDisappear GameRecordTVC");
	[self.theTimer invalidate];
	self.theTimer = nil;
	[sharedSoundEffectsManager stopFlightTerminalBoardSound];
	[super viewDidDisappear:animated];
}

- (void) dealloc {
	NSLog(@"dealloc GameRecordTVC");
	self.intervalLbls = nil;
	self.getter = nil;
	self.gamesRecords = nil;
	self.placeSeg = nil;
	self.locationManager = nil;
	self.terminalViews = nil;
	self.standbyTerminalViews = nil;
	[self.theTimer invalidate];
	self.theTimer = nil;
	self.pageControl = nil;
	self.scrollView = nil;
	[super dealloc];
}

#pragma mark Initilization 
- (void) initPageControl
{
	CGRect frame = CGRectMake(0.0, 0.0, 320.0, 22.0);
	UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:frame];
	[self.view addSubview:pageControl];
	//[pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	pageControl.backgroundColor = [UIColor blackColor];
	
	if (self.locality == klocal)
		pageControl.numberOfPages = 2;
	else
		pageControl.numberOfPages = 4;
	pageControl.currentPage = 1;
	self.pageControl = pageControl;
	[pageControl release];
	
	self.scrollView.pagingEnabled = YES;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * pageControl.numberOfPages, self.scrollView.frame.size.height);
	self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * pageControl.currentPage, 0);
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;	
	self.scrollView.delegate = self;

	
}

- (void) initLocationManager
{
	if (!self.locationManager)	{
		CLLocationManager * manager = [[CLLocationManager alloc] init];	
		self.locationManager = manager;
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.distanceFilter = 10.0;
		[manager release];
	}
	
	[self.locationManager startUpdatingLocation];
	
}

- (void) initGameSelection
{
	if (!self.gameSelectionView)	{
		UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(190,0,130,([[Constants sharedInstance] noGames]+2)*24)];
		scrollView.contentSize = CGSizeMake(95, 24*([[Constants sharedInstance] noGames]+2));
		scrollView.backgroundColor = [UIColor blackColor];
		for (int i =0; i<[[Constants sharedInstance] noGames]; i++)	{
			NSString* gameName = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:i]];
			UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setTitle:gameName forState:UIControlStateNormal];
			button.frame = CGRectMake(0,i*24,130,24);
			button.tag = i;
			[button addTarget:self action:@selector(gameSelected:) forControlEvents:UIControlEventTouchUpInside]; 
			button.backgroundColor=[UIColor grayColor];
			button.titleLabel.backgroundColor=[UIColor clearColor];
			button.titleLabel.textColor = [UIColor whiteColor];
			button.titleLabel.textAlignment = UITextAlignmentCenter;
			button.font = [UIFont systemFontOfSize:16];
			[scrollView addSubview:button];
		}
		
		NSString* gameName = NSLocalizedString(@"所有",nil);
		UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:gameName forState:UIControlStateNormal];
		button.frame = CGRectMake(0,[[Constants sharedInstance] noGames]*24,130,24);
		button.tag = -1;
		[button addTarget:self action:@selector(gameSelected:) forControlEvents:UIControlEventTouchUpInside]; 
		button.backgroundColor=[UIColor grayColor];
		button.titleLabel.backgroundColor=[UIColor clearColor];
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.textAlignment = UITextAlignmentCenter;
		button.font = [UIFont systemFontOfSize:16];
		[scrollView addSubview:button];
		
		gameName = NSLocalizedString(@"街機模式",nil);
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:gameName forState:UIControlStateNormal];
		button.frame = CGRectMake(0,([[Constants sharedInstance] noGames]+1)*24,130,24);
		button.tag = -2;
		[button addTarget:self action:@selector(gameSelected:) forControlEvents:UIControlEventTouchUpInside]; 
		button.backgroundColor=[UIColor grayColor];
		button.titleLabel.backgroundColor=[UIColor clearColor];
		button.titleLabel.textColor = [UIColor whiteColor];
		button.titleLabel.textAlignment = UITextAlignmentCenter;
		button.font = [UIFont systemFontOfSize:16];
		[scrollView addSubview:button];
		
		self.gameSelectionView = scrollView;
		[scrollView release];
	}
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {

    // Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (page!=self.pageControl.currentPage)	{
		self.pageControl.currentPage = page;
		
		[self getGameRecords];
	}
}

#pragma mark Private Methods
- (void) showGameSelectionView
{
	[self.view addSubview:self.gameSelectionView];
	[self.gameSelectionView setUserInteractionEnabled:NO];
	[self.gameSelectionView setFrame:CGRectMake(320,self.gameSelectionView.frame.origin.y, self.gameSelectionView.frame.size.width, self.gameSelectionView.frame.size.height)];
	[UIView beginAnimations:@"show0" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self.gameSelectionView setFrame:CGRectMake(190-10,self.gameSelectionView.frame.origin.y, self.gameSelectionView.frame.size.width, self.gameSelectionView.frame.size.height)];
	[UIView commitAnimations];		
}

- (void) dismissGameSelectionView
{
	[self.gameSelectionView setUserInteractionEnabled:NO];	
	[UIView beginAnimations:@"dismiss0" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self.gameSelectionView setFrame:CGRectMake(190-10,self.gameSelectionView.frame.origin.y, self.gameSelectionView.frame.size.width, self.gameSelectionView.frame.size.height)];
	[UIView commitAnimations];	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
	if ([animationID isEqualToString:@"dismiss0"])	{
		[UIView beginAnimations:@"dismiss1" context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self.gameSelectionView setFrame:CGRectMake(320,self.gameSelectionView.frame.origin.y, self.gameSelectionView.frame.size.width, self.gameSelectionView.frame.size.height)];
		[UIView commitAnimations];	
	}
	if([animationID isEqualToString:@"dismiss1"])	{
		[self.gameSelectionView removeFromSuperview];
		[self.gameSelectionView setUserInteractionEnabled:YES];
	}
	else if ([animationID isEqualToString:@"show0"]){
		[UIView beginAnimations:@"show1" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self.gameSelectionView setFrame:CGRectMake(190, self.gameSelectionView.frame.origin.y, self.gameSelectionView.frame.size.width, self.gameSelectionView.frame.size.height)];
		[UIView commitAnimations];			
		[self.gameSelectionView setUserInteractionEnabled:YES];
	}
}

- (void) getGameRecords
{
	self.gamesRecords = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil] forKey:[NSNumber numberWithInt:0]];
	self.terminalViews = [NSMutableArray arrayWithCapacity:10];
	self.standbyTerminalViews = [NSMutableArray arrayWithCapacity:10];
	
	int page = self.pageControl.currentPage;
	if (self.locality==klocal)	{
		if (page==0)
			self.gamesRecords = [LocalStorageManager customObjectForKey:LOCALRECORD];
		else if (page==1)
			self.gamesRecords = [LocalStorageManager customObjectForKey:LOCALHIGHESTRECORD];
		[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];
		[[self.tables objectAtIndex:self.pageControl.currentPage] setTableFooterView:self.clearRecordBut];		
	}
	else {
		[self.getter reInit];
		switch (page)	{
			case (0):
				[self.getter addKey:@"interval" AndVal:@"day"];
				break;
			case (1):
				[self.getter addKey:@"interval" AndVal:@"week"];
				break;
			case (2):
				[self.getter addKey:@"interval" AndVal:@"month"];
				break;
			case (3):
				break;
		}
		switch (self.locality)	{
			case (knearby):
				[self.getter addKey:@"gps_x" AndVal:[NSString stringWithFormat:@"%f", self.gps_x]];
				[self.getter addKey:@"gps_y" AndVal:[NSString stringWithFormat:@"%f", self.gps_y]];
				break;
			case (kcountry):
				[self.getter addKey:@"country" AndVal:[LocalStorageManager objectForKey:COUNTRY]];
				break;
			case (kworld):
				break;
		}
		if (self.section == -1){
			[self.getter addKey:@"gameMode" AndVal:@"1"];
		}
		else if (self.section == -2){
//			[self.getter addKey:@"gameMode" AndVal:@"0"];
			[self.getter addKey:@"game" AndVal:@"-1"];
		}
		else{
			[self.getter addKey:@"game" AndVal:[NSString stringWithFormat:@"%d", self.section]];
			[self.getter addKey:@"gameMode" AndVal:@"1"];
		}

		[[self.tables objectAtIndex:page] reloadData];
		[self.getter sendReq];
	}
}

#pragma mark Button Clicked
- (void) clearRecordButClicked
{
	NSDictionary* dict = [NSDictionary dictionary];
	[LocalStorageManager setCustomObject:dict forKey:LOCALRECORD];
	self.gamesRecords = dict;
	[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];		
	[[self.tables objectAtIndex:self.pageControl.currentPage] setTableFooterView:self.clearRecordBut];		
}

- (void) gameButClicked:(id) sender
{
	if (!self.gameSelectionViewShown)	{
		self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"遊戲",nil);
		[self showGameSelectionView];
		self.gameSelectionViewShown=YES;
	}
	else {
		[self dismissGameSelectionView];
		self.gameSelectionViewShown=NO;
		
	}

}

- (void) gameSelected:(id) sender
{
	self.section = [sender tag];
	if ([sender tag] == -2)	{
		self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"街機模式",nil);		
	}
	else if ([sender tag]==-1) {
		self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"所有",nil);		
	}
	else 	{
		NSString* gameName = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.section]];
		self.navigationItem.rightBarButtonItem.title = gameName;
	}

	[self dismissGameSelectionView];
	self.gameSelectionViewShown=NO;
	[self getGameRecords];
}

/*
- (void)segmentAction:(id)sender
{
	[self.getter reInit];
	
	switch (self.placeSeg.selectedSegmentIndex)	{
		case (1):
			[self.getter addKey:@"gps_x" AndVal:[NSString stringWithFormat:@"%f", self.gps_x]];
			[self.getter addKey:@"gps_y" AndVal:[NSString stringWithFormat:@"%f", self.gps_y]];
			break;
		case (2):
			[self.getter addKey:@"country" AndVal:[LocalStorageManager objectForKey:COUNTRY]];
			break;
		case (3):
			break;
	}
	
	switch (self.pageControl.currentPage)	{
		case (0):
			[self.getter addKey:@"interval" AndVal:@"day"];
			break;
		case (1):
			[self.getter addKey:@"interval" AndVal:@"week"];
			break;
		case (2):
			[self.getter addKey:@"interval" AndVal:@"month"];
			break;
		case (3):
			break;
	}
	[self.getter addKey:@"game" AndVal:[NSString stringWithFormat:@"%d", self.section]];

	
	if (self.placeSeg.selectedSegmentIndex==0)	{
		self.gamesRecords = [LocalStorageManager customObjectForKey:LOCALRECORD];
		self.intervalLbl.text = @"";
		[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];
		[[self.tables objectAtIndex:self.pageControl.currentPage] setTableFooterView:self.clearRecordBut];		
	}
	else	{
		self.gamesRecords = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil] forKey:[NSNumber numberWithInt:0]];
		[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];
		self.terminalViews = [NSMutableArray arrayWithCapacity:10];
		self.standbyTerminalViews = [NSMutableArray arrayWithCapacity:10];
		[self.getter sendReq];
	}
}
*/


#pragma mark Terminal Views Management
- (void) timerFireMethod:(NSTimer*)theTimer
{
	@synchronized(self){
		NSMutableArray* viewToKeep =[NSMutableArray arrayWithCapacity:[self.terminalViews count]];
		for (TerminalBoardView* view in self.terminalViews)	{
			[view updateView];
			if ([view seq]<=5)
				[viewToKeep addObject:view];
			else	{
				GameRecord* theGameRecord = [[self.gamesRecords objectForKey:[NSNumber numberWithInt:view.sectionNo]] objectAtIndex:view.rankNo-1];
				if ([theGameRecord isKindOfClass:[GameRecord class]])
					theGameRecord.isShown = YES;
			}
		}
		self.terminalViews = viewToKeep;
		
		if (([self.terminalViews count]<2) &&	([self.standbyTerminalViews count]>0)){
			TerminalBoardView* view = [self.standbyTerminalViews objectAtIndex:0];
			[self.terminalViews addObject:view];
			[self.standbyTerminalViews removeObject:view];
		}
		if ([self.terminalViews count]==0 && [self.standbyTerminalViews count]==0)	{
			if (self.isPlayingSound)	{
				[sharedSoundEffectsManager pauseFlightTerminalBoardSound];
				self.isPlayingSound=NO;
			}
		}
		else if (!self.isPlayingSound)	{
			[sharedSoundEffectsManager playFlightTerminalBoardSound];
			self.isPlayingSound=YES;
		}
	}
}

- (void) addTerminalView:(TerminalBoardView*)view
{
	@synchronized(self)	{
		if ([self.terminalViews count]<2)	{
			[self.terminalViews addObject:view];
		}
		else	{
			[self.standbyTerminalViews addObject:view];
		}
	}
}
		
- (void) removeTerminalView:(TerminalBoardView*)view
{
	@synchronized(self)	{
		[self.terminalViews removeObject:view];
		[self.standbyTerminalViews removeObject:view];
	}
}


- (void)finished:(NSDictionary*) dict
{
	self.gamesRecords = dict;
	self.terminalViews = [NSMutableArray arrayWithCapacity:10];
	self.standbyTerminalViews = [NSMutableArray arrayWithCapacity:10];
	[[self.tables objectAtIndex:self.pageControl.currentPage] reloadData];
}



#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	if(newLocation)
	{
		NSDate * today = [NSDate date];
		if([today timeIntervalSinceDate:newLocation.timestamp] < 60)
		{
			self.gps_x = newLocation.coordinate.latitude;
			self.gps_y = newLocation.coordinate.longitude;
			self.hasGps = YES;
			[self.locationManager stopUpdatingLocation];
			
			if (self.locality == knearby)	{
				[self getGameRecords];
			}
		}
	}
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	if (error.code != kCLErrorLocationUnknown)	{
		[self.locationManager stopUpdatingLocation];
	}
} 

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	NSArray* gameRecords;
	if (self.section==-1)	
		gameRecords = [self.gamesRecords objectForKey:[NSNumber numberWithInt:section]];
	else if (self.section == -2)
		gameRecords = [self.gamesRecords objectForKey:[NSNumber numberWithInt:0]];		
	else
		gameRecords = [self.gamesRecords objectForKey:[NSNumber numberWithInt:self.section]];
		
	if (gameRecords){
		NSLog(@"count is %d, section is %d", [gameRecords count], section);
		return [gameRecords count];
	}
	else
		return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section;
	if (self.section == -1)
		section = indexPath.section;
	else if (self.section == -2)
		section = 0;
	else	
		section = self.section;
	int row = indexPath.row;
	
	GameRecordTVC* cell = [tableView dequeueReusableCellWithIdentifier:@"gamerecord"];
	if(!cell)
	{
		cell = [[[GameRecordTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gamerecord"] autorelease];
	}
	
	if (![[[self.gamesRecords objectForKey:[NSNumber numberWithInt:section]] objectAtIndex:row] isKindOfClass:[NSString class]])	{
		GameRecord* theGameRecord = [[self.gamesRecords objectForKey:[NSNumber numberWithInt:section]] objectAtIndex:row];
		[cell setRankNo:row+1];
		[cell setSectionNo:section];
		[cell setCellContent:theGameRecord]; 
		if (!theGameRecord.isShown)	{
			[self addTerminalView:cell.terminalView];
			[cell.terminalView setTimerqueue:self];
		}
		else
			NSLog(@"terminal view %d %d is shown already", cell.terminalView.sectionNo, cell.terminalView.rankNo);	
	}
	else {
		[cell setRankNo:row+1];
		[cell setSectionNo:section];
		[cell randomCellContent]; 
		[self addTerminalView:cell.terminalView];
		[cell.terminalView setTimerqueue:self];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.section!=-1)
		return 1;
	else
		return [[Constants sharedInstance] noGames];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString* gameName;
	if (self.section==-1)	{
			gameName = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:section]];
	}
	else if (self.section==-2)
		gameName = NSLocalizedString(@"街機模式", nil);
	else 
		gameName = [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:self.section]];
	NSString* displayText = [[gameName stringByPaddingToLength:(16-[[self.intervalLbls objectAtIndex:self.pageControl.currentPage] length]) withString:@" " startingAtIndex:0] stringByAppendingString:[self.intervalLbls objectAtIndex:self.pageControl.currentPage]];
	CustomTerminalBoardView* theView = [[CustomTerminalBoardView alloc] initWithFrame:CGRectMake(0, 0, CUSTOMCELLWIDTH*CUSTOMNUMCELL, CUSTOMCELLHEIGHT) AndText:displayText AndColor:[UIColor lightGrayColor] AndFixed:YES];
	return theView;
}





@end


@implementation GameRecordLandscapeView
@synthesize owner = _owner;
@synthesize pins = _pins;
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize userLocation = _userLocation;
@synthesize showUserLocation = _showUserLocation;
@synthesize gameRecords = _gameRecords;


- (id) initWithFrame:(CGRect)aRect andOwner:(id)aOwner andGameRecords:(NSDictionary*)gameRecords
{
	if (self = [super initWithFrame:aRect])	{
		self.owner = aOwner;
		self.gameRecords = gameRecords;
		[self initMapView];
		NSMutableArray* pins = [[NSMutableArray alloc]initWithCapacity:10];
		self.pins = pins;
		self.centerX = 0.0;
		self.centerY = 0.0;
		[pins release];
		
		[self initInterface];
		
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"dealloc GameRecordLandscapeView");
	self.mapView = nil;
	self.pins = nil;
	self.userLocation=nil;
	self.locationManager = nil;
	self.userLocation = nil;
	
	[super dealloc];
}


- (void) initInterface
{		
	for (NSArray* records in [self.gameRecords allValues])	{
		for (GameRecord* gameRecord in records)	{
			self.centerX += gameRecord.gps_x;
			self.centerY += gameRecord.gps_y;
			
			PinAnnotation *pin = [[PinAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){gameRecord.gps_x, gameRecord.gps_y}];
			pin.title = [NSString stringWithFormat:@"%@ score:%2d", gameRecord.name, gameRecord.score];
			NSString* level;
			switch (gameRecord.gameLevel)	{
				case (0):
					level = @"Easy";
					break;
				case (1):
					level = @"Normal";
					break;
				case (2):
					level = @"Hard";
					break;
				case (3):
					level = @"Master";
					break;
			}
			pin.subtitle = [NSString stringWithFormat:@"%@ %@", [[[Constants sharedInstance] getGameNamesDictionary] objectForKey:[NSNumber numberWithInt:gameRecord.game]], level];
			[self.pins addObject:pin];
			[pin release];
		}
	}
	[self setMapRegion];	
	[self.mapView addAnnotations:self.pins];
}

- (void) setMapRegion
{
	MKCoordinateSpan span;
	CLLocationCoordinate2D center;
	if ([self.pins count]<=1 && !self.showUserLocation)	{
		span = MKCoordinateSpanMake(0.001, 0.001);
		center.latitude = self.centerX;
		center.longitude= self.centerY;
	}
	else	{
		float deltaX = 0.001;
		float deltaY = 0.001;
		for (int i=0; [self.pins count]>0 && i<[self.pins count]; i++)	{
			for (int j=i+1; j<[self.pins count]; j++)	{
				if (fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.latitude-((PinAnnotation*)[self.pins objectAtIndex:j]).coordinate.latitude) > deltaX)
					deltaX = fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.latitude-((PinAnnotation*)[self.pins objectAtIndex:j]).coordinate.latitude);
				if (fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.longitude-((PinAnnotation*)[self.pins objectAtIndex:j]).coordinate.longitude) > deltaY)
					deltaY = fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.longitude-((PinAnnotation*)[self.pins objectAtIndex:j]).coordinate.longitude);
			}
			
			if (self.showUserLocation)	{
				if (fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.latitude-self.userLocation.coordinate.latitude) > deltaX)
					deltaX = fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.latitude-self.userLocation.coordinate.latitude);
				if (fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.longitude-self.userLocation.coordinate.longitude) > deltaY)
					deltaY = fabs(((PinAnnotation*)[self.pins objectAtIndex:i]).coordinate.longitude-self.userLocation.coordinate.longitude);
			}		
		}
		
		NSLog(@"delta is %f %f", deltaX, deltaY);
		if (deltaX>deltaY)
			deltaY = deltaX;
		else
			deltaX = deltaY;
		span = MKCoordinateSpanMake(deltaX*1.1, deltaY*1.1);
		if (self.showUserLocation)	{
			center.latitude = (self.centerX + self.userLocation.coordinate.latitude) / ([self.pins count]+1);
			center.longitude = (self.centerY + self.userLocation.coordinate.longitude) / ([self.pins count]+1);
		}
		else	{
			center.latitude = self.centerX/[self.pins count];
			center.longitude = self.centerY/[self.pins count];
		}
	}
	
	NSLog(@"span is %f %f", span.latitudeDelta, span.longitudeDelta);
	NSLog(@"centre is %f %f", center.latitude, center.longitude);
	
	MKCoordinateRegion region = [self.mapView regionThatFits:(MKCoordinateRegion){center, span}];
	[self.mapView setRegion:region animated:YES];
	[self.mapView setCenterCoordinate:center animated:NO];
}

- (void) locationClicked:(id) sender
{
	if (self.showUserLocation)	{
		self.showUserLocation = NO;	
		self.mapView.showsUserLocation=NO;
	}
	else	{
		self.showUserLocation = YES;
		
		if (!self.locationManager)	{
			CLLocationManager* manager = [[CLLocationManager alloc] init];
			self.locationManager = manager;
			self.locationManager.delegate = self;
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
			self.locationManager.distanceFilter = 10.0;
			[manager release];
		}
		[self.locationManager startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error	{
	NSLog(@"fail to update location , error is %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if (self.showUserLocation)	{
		self.userLocation = newLocation;
		self.mapView.showsUserLocation=YES;
		[self performSelectorOnMainThread:@selector(setMapRegion) withObject:nil waitUntilDone:NO];
	}
	// We only update location once, and let users to do the rest of the changes by dragging annotation to place they want
	[manager stopUpdatingLocation];
}


- (void) initMapView
{
	CGRect mapRect = CGRectMake(0, 0, 480, 320); 
	
	if (!self.mapView)	{
		MKMapView * tmpMapView = [[MKMapView alloc] initWithFrame:mapRect];
		tmpMapView.delegate = self;
		self.mapView = tmpMapView;
		[tmpMapView release];
		[self clearMap];
		[self addSubview:self.mapView];		
	}								  
	[self.mapView setHidden:NO];
}								  


- (void) clearMap
{
	CLLocationCoordinate2D center = {0.0, 0.0};
	MKCoordinateRegion region = [self.mapView regionThatFits:(MKCoordinateRegion){center, MKCoordinateSpanMake(170.0, 100.0)}];
	[self.mapView setRegion:region animated:YES];	
	[self.mapView removeAnnotations:self.pins];
	NSMutableArray* pins = [[NSMutableArray alloc]initWithCapacity:10];
	self.pins = pins;
	[pins release];
	self.centerX = 0.0;
	self.centerY = 0.0;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	if (annotationView == nil) {
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
	}
	// Dragging annotation will need _mapView to convert new point to coordinate;
	//	annotationView.mapView = mapView;
	annotationView.canShowCallout = YES;
	annotationView.animatesDrop = YES;
	//	annotationView.rightCalloutAccessoryView = self.theImage;
	
	//	self.pin.coordinate = self.location.coordinate;
	//	self.addressLabel.text = [[[NSString alloc]initWithFormat:@"? %@",[self.pin.annotation subtitle]]autorelease] ;
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	[self.mapView selectAnnotation:[self.pins lastObject] animated:YES];
}
@end
