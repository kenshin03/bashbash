//
//  NationalFlagView.h
//  bishibashi
//
//  Created by Eric on 15/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NationalFlagView : NSObject {
	NSArray* _countries;
	NSMutableArray* _flagImages;
}
@property (nonatomic, retain) NSArray* countries;
@property (nonatomic, retain) NSMutableArray* flagImages;
@end
