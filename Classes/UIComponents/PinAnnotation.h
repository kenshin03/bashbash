//
//  PinAnnotation.h
//
//  Created by Eric on 11/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PinAnnotation : NSObject<MKAnnotation,NSCopying> {
	CLLocationCoordinate2D _coordinate;
	NSString* _title;
	NSString* _subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;
@end
