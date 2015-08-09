//
//  arrow.h
//  bishibashi
//
//  Created by Eric on 14/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Arrow : UIImageView {
	id _owner;
	BOOL _longArrow;
	float _speed;
	float _angle;
	NSDate* _startTime;
	UIInterfaceOrientation _orientation;
}
@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, assign) id owner;
@property (nonatomic, assign) BOOL longArrow;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float angle;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
- (id)initWithOwner:(id)owner ForLong:(BOOL)longArrow AndAngle:(float)angle AndSpeed:(float)speed AndOrientation:(UIInterfaceOrientation)orientation;
- (void)setAngle:(float)angle	AndSpeed:(float)speed;
	
@end
