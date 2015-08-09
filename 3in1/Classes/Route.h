//
//  Route.h
//  bishibashi
//
//  Created by Eric on 30/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Route : UIView {
	UIImageView*	_startStation;
	UILabel*		_startStationNameLabel;
	NSMutableArray*	_stations;
	NSMutableArray*	_stationNameLabels;
	NSMutableArray*	_lines;
}
@property (nonatomic, retain) UIImageView* startStation;
@property (nonatomic, retain) UILabel* startStationNameLabel;
@property (nonatomic, retain) NSMutableArray* stations;
@property (nonatomic, retain) NSMutableArray* stationNameLabels;
@property (nonatomic, retain) NSMutableArray* lines;
@end
