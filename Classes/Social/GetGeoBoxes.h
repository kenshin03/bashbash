//
//  GetFBMsg.h
//  bishibashi
//
//  Created by Eric on 05/08/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Msg.h"

@protocol GetGeoBoxesDelegate
- (void):finished:(NSMutableArray*) geoBoxes;
@end

@interface GeoBox: NSObject{
	float	_gps_x;
	float	_gps_y;
	int	_count;
}	
@property (nonatomic, assign) float gps_x;
@property (nonatomic, assign) float gps_y;
@property (nonatomic, assign) int count;
@end



@interface GetGeoBoxes : NSObject {
	NSMutableData*	_tmpData;
	NSString* _urlStr;
	NSXMLParser* _theParser;
	NSMutableArray*	_geoBoxes;
	NSString*	_elemString;
	GeoBox*	_currentGeoBox;
	id	_delegate;
}
@property (nonatomic, retain) NSMutableData* tmpData;
@property (nonatomic, retain) NSString* urlStr;
@property (nonatomic, retain) NSXMLParser* theParser;
@property (nonatomic, retain) NSMutableArray* geoBoxes;
@property (nonatomic, retain) NSString* elemString;
@property (nonatomic, retain) GeoBox* currentGeoBox;
@property (nonatomic, assign) id delegate;
@end



@end
