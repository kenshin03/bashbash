    //
//  AroundTheWorldViewController.m
//  bishibashi
//
//  Created by Eric on 30/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "AroundTheWorldViewController.h"


@implementation AroundTheWorldViewController
@synthesize webView = _webView;
@synthesize game = _game;
@synthesize aiView = _aiView;
/*
@synthesize geoBoxesGetter = _geoBoxesGetter;
@synthesize pins = _pins;
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize userLocation = _userLocation;
@synthesize showUserLocation = _showUserLocation;
@synthesize geoBoxes = _geoBoxes;



- (void) dealloc
{
	NSLog(@"dealloc AroundTheWorldViewController");
	self.mapView = nil;
	self.pins = nil;
	self.userLocation=nil;
	self.locationManager = nil;
	self.userLocation = nil;
	self.geoBoxes = nil;
	self.geoBoxesGetter = nil;
	
	[super dealloc];
}


- (void) initInterface
{		
	for (GeoBox* geoBox in self.geoBoxes)	{		
			self.centerX += geoBox.gps_x;
			self.centerY += geoBox.gps_y;
			
			PinAnnotation *pin = [[PinAnnotation alloc] initWithCoordinate:(CLLocationCoordinate2D){geoBox.gps_x, geoBox.gps_y}];
			pin.title = [NSString stringWithFormat:@"%d", geoBox.count];
			[self.pins addObject:pin];
			[pin release];
		
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
	CGRect mapRect = CGRectMake(0, 0, 320, 480); 
	
	if (!self.mapView)	{
		MKMapView * tmpMapView = [[MKMapView alloc] initWithFrame:mapRect];
		tmpMapView.delegate = self;
		self.mapView = tmpMapView;
		[tmpMapView release];
		[self clearMap];
		[self.view addSubview:self.mapView];		
	}								  
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
//	[self.mapView selectAnnotation:[self.pins lastObject] animated:YES];
}


-(void) viewWillAppear:(BOOL)animated
{
	GetGeoBoxes* geoBoxesGetter = [[GetGeoBoxes alloc] initWithDelegate:self];
	self.geoBoxesGetter = geoBoxesGetter;
	[geoBoxesGetter release];
	
	[self.geoBoxesGetter addKey:@"resolution" AndVal:@"2"];
	[self.geoBoxesGetter addKey:@"duration" AndVal:@"14400"];
	[self.geoBoxesGetter sendReq];
	
	[self initMapView];

	NSMutableArray* pins = [[NSMutableArray alloc]initWithCapacity:100];
	self.pins = pins;
	self.centerX = 0.0;
	self.centerY = 0.0;
	[pins release];
	
	[super viewWillAppear:animated];
}

- (void) finished:(NSMutableArray*) geoBoxes
{
	self.geoBoxes = geoBoxes;
	[self initInterface];
}	

*/

- (id) initWithGame:(int)game
{
	self.game = game;
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,480-44)];
	self.webView = webView;
	[webView release];
	[self.view addSubview:self.webView];

	return self;
}

- (id) init
{
	self.game = -10;
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,480-44)];
	self.webView = webView;
	[webView release];
	[self.view addSubview:self.webView];
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	self.title=NSLocalizedString(@"Around The World", nil);
	[self.navigationController setNavigationBarHidden:NO animated:animated];

	NSString *url;
	if (self.game!=-10)
		url = [NSString stringWithFormat:@"http://red-soldier.appspot.com/map?duration=14400&zoomlevel=1&game=%d", self.game];
	else 
		url = @"http://red-soldier.appspot.com/map?duration=14400&zoomlevel=1";
	
	UIActivityIndicatorView* aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.aiView = aiView;
	[aiView release];
	self.aiView.hidesWhenStopped = YES;
	[self.aiView startAnimating];
	[self.view addSubview:self.aiView];
	self.aiView.frame = CGRectMake(130, 200, 60, 60);
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self.webView setDelegate:self];
	[self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.aiView stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.aiView startAnimating];
}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) dealloc{
	self.webView = nil;
	self.aiView = nil;
}


@end
