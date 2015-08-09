//
//  Heart.h
//  bishibashi
//
//  Created by Eric on 12/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Heart : UIView {
	int _val;
	UIImage*	_image;
}
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int val;
@end
