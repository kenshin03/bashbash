//
//  AroundTheWorldViewController.h
//  bishibashi
//
//  Created by Eric on 30/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGeoBoxes.h"
#import <MapKit/MapKit.h>
#import "PinAnnotation.h"

@interface AroundTheWorldViewController : UIViewController<GetGeoBoxesDelegate, UIWebViewDelegate> {
	UIActivityIndicatorView*	_aiView;
	UIWebView*	_webView;
	int	_game;
	/*
	GetGeoBoxes*	_geoBoxesGetter;
	NSArray*	_geoBoxes;
	CLLocationManager					*_locationManager;
	MKMapView							*_mapView;
	
	NSMutableArray						*_pins;
	float								_centerX;
	float								_centerY;
	CLLocation							*_userLocation;
	BOOL								_showUserLocation;
	*/
}
@property (nonatomic, retain) UIActivityIndicatorView* aiView;
@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, assign) int game;
/*
@property (nonatomic, retain) GetGeoBoxes*	geoBoxesGetter;
@property (nonatomic, retain) NSArray*	geoBoxes;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *pins;

@property (nonatomic, assign) float centerX;
@property (nonatomic, assign) float centerY;
@property (nonatomic, retain) CLLocation* userLocation;
@property (nonatomic, assign) BOOL showUserLocation;
*/

@end
