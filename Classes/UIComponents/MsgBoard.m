//
//  MsgBoard.m
//  bishibashi
//
//  Created by Eric on 06/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "MsgBoard.h"


@implementation MsgBoard
@synthesize owner = _owner;
@synthesize arrow = _arrow;
@synthesize arrowControl = _arrowControl;
@synthesize theFrame = _theFrame;
@synthesize tableView = _tableView;
@synthesize msgs = _msgs;
@synthesize msgGetter = _msgGetter;

static const CGRect arrowRect = {{290, 100}, {25,20}};
static const CGRect arrowControlRect = {{290, 0}, {25,200}};

-(id) initWithFrame:(CGRect)frame AndStartColor:(float)startColor AndEndColor:(float)endColor AndOwner:(id)owner
{
	if (self = [super initWithFrame:frame])	{
		_startColor = startColor;
		_endColor= endColor;
		self.owner= owner;
		self.clipsToBounds = YES;
		UIControl* arrowControl = [[UIControl alloc] init];
		self.arrowControl = arrowControl;
		self.arrowControl.frame = arrowControlRect;
		self.arrowControl.frame = CGRectMake(self.arrowControl.frame.origin.x, self.arrowControl.frame.origin.y, self.arrowControl.frame.size.width, self.frame.size.height);
		self.arrowControl.backgroundColor = [UIColor clearColor];
		[arrowControl release];
		UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow.png"]];
		self.arrow = arrow;
		self.arrow.frame = arrowRect;
		[arrow release];
		[self addSubview:self.arrow];
		[self addSubview:self.arrowControl];
		[self.arrowControl addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
		self.theFrame = self.frame;

		self.alpha = 0.6;
		
		GetMsg* msgGetter = [[GetMsg alloc] initWithDelegate:self];
		self.msgGetter = msgGetter;
		[msgGetter release];
		
		NSString*twusername = [LocalStorageManager objectForKey:TWITTER_USER];
		if (twusername!=nil)	{
			[self.msgGetter addKey:@"twscreenname" AndVal:twusername];
		}
		
		[self.msgGetter addKey:@"lang" AndVal:[[Constants sharedInstance] language]];
		
		// for posting scores with game centere player id
		if ([[Constants sharedInstance] gameCenterEnabled]) 
			[self.msgGetter  addKey:@"gcid" AndVal:[[GKLocalPlayer localPlayer] playerID]];

		
		/* set up the table*/
		UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,0, self.frame.size.width-40, self.frame.size.height) style:UITableViewStylePlain];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.tableView = tableView;
		[tableView release];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		[self.tableView setRowHeight:40];
		[self addSubview:self.tableView];
	//	[self initInterface];
		
		[self.msgGetter sendReq];

	}
	return self;
}

-(void) dealloc
{
	NSLog(@"dealloc MsgBoard");
	self.tableView = nil;
	self.arrow = nil;
	self.arrowControl = nil;
	[super dealloc];
}

-(void) dismiss
{
	[UIView beginAnimations:@"dismiss0" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self setFrame:CGRectOffset(self.frame, 10, 0)];
//	[[self.owner youtubeBut] setFrame:CGRectOffset([[self.owner youtubeBut] frame], -320,0)];
//	[[self.owner mapBut] setFrame:CGRectOffset([[self.owner mapBut] frame], -320,0)];
//	[[self.owner fbBut] setFrame:CGRectOffset([[self.owner fbBut] frame], -320,0)];

	[UIView commitAnimations];	
}	
- (void) show
{
	[UIView beginAnimations:@"show0" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[self setFrame:CGRectOffset(self.frame, -10, 0)];
//	[[self.owner youtubeBut] setFrame:CGRectOffset([[self.owner youtubeBut] frame], 320,0)];
//	[[self.owner mapBut] setFrame:CGRectOffset([[self.owner mapBut] frame], 320,0)];
//	[[self.owner fbBut] setFrame:CGRectOffset([[self.owner fbBut] frame], 320,0)];
	[UIView commitAnimations];	
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
	if ([animationID isEqualToString:@"dismiss0"])	{
		[UIView beginAnimations:@"dismiss1" context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectOffset(self.frame, -300, 0)];
		[UIView commitAnimations];	
		self.arrow.image = [UIImage imageNamed:@"rightarrow.png"];
		[self.arrowControl removeTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		[self.arrowControl addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
	}
	else if ([animationID isEqualToString:@"show0"]){
		[UIView beginAnimations:@"show1" context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[self setFrame:CGRectOffset(self.frame, 300, 0)];
		[UIView commitAnimations];	
		self.arrow.image = [UIImage imageNamed:@"leftarrow.png"];
		[self.arrowControl removeTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
		[self.arrowControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
	}

}
 - (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}
 
 -(void)drawInContext:(CGContextRef)context
{
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = 
	{	_startColor,_startColor,_startColor,0.5,  // Start color
		_endColor, _endColor, _endColor, 0.5  // End color
	};
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	CGContextDrawLinearGradient (context, myGradient, CGPointMake(self.bounds.origin.x, self.bounds.origin.y),
								 CGPointMake(self.bounds.origin.x+self.bounds.size.width, self.bounds.origin.y),
								 0);
	
	CGGradientRelease(myGradient);	
	CGColorSpaceRelease(myColorspace);
	
	// Draw the area
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 5.0);
	CGContextAddRect(context, self.bounds);
	// And close the subpath.
	CGContextClosePath(context);	
	// Now draw the star & hexagon with the current drawing mode.
	CGContextDrawPath(context, kCGPathStroke);
	
	
}
	 
- (void) clear
{
	self.msgs = nil;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark GetMsgDelegate	
- (void)finished:(NSMutableArray*) msgs;
{
	self.msgs = msgs;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Msg* msg = ((Msg*)[self.msgs objectAtIndex:indexPath.row]);
	if (msg.text)
		return 70;
	else
		return 40;
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.msgs count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
		for (UIView* view in cell.contentView.subviews)
			[view removeFromSuperview];
	}
	
	[((Msg*)[self.msgs objectAtIndex:indexPath.row]) initInterfaceWithWidth:(float)(320.0)];
	[cell.contentView addSubview: [self.msgs objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
