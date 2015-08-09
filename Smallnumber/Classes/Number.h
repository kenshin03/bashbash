//
//  Number.h
//  bishibashi
//
//  Created by Eric on 24/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface Number : UIView {
	int _no;
	UIImage* _image;
	ButState _color;
	int _pos;
	UIInterfaceOrientation _orientation;
}
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int no;
@property (nonatomic, assign) int pos;
@property (nonatomic, assign)  ButState color;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
