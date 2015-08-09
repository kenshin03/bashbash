//
//  VSResult.h
//  bishibashi
//
//  Created by Eric on 09/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSResult : UILabel {
	UIImageView*	_winImage;
//	UILabel*	_text;
	UIImage*	_image;
	BOOL	_isWin;
}
@property (nonatomic, retain) UIImageView* winImage;
@property (nonatomic, retain) UIImage* image;
//@property (nonatomic, retain) UILabel* text;
@property (nonatomic, assign) BOOL isWin;
-(void) setTime:(float) time;


@end
