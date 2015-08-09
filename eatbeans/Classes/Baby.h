//
//  Baby.h
//  bishibashi
//
//  Created by Eric on 28/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "LocalStorageManager.h"

@interface Baby : UIImageView {
	ButState		_color;
	UIImageView*	_cloth;
	UIImageView*	_face;
	UIImageView*		_openmouthface;
	UIImageView*	_cryingface;
	
	UIInterfaceOrientation _orientation;	
	
}
@property(nonatomic, assign) ButState color;
@property(nonatomic, retain) UIImageView* cloth;
@property(nonatomic, retain) UIImageView* face;
@property(nonatomic, retain) UIImageView* openmouthface;
@property(nonatomic, retain) UIImageView* cryingface;

@property (nonatomic, assign) UIInterfaceOrientation orientation;

@end