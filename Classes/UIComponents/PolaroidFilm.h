//
//  PolaroidFilm.h
//  bishibashi
//
//  Created by Eric on 29/10/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolaroidFilm : UIImageView {
	NSString*	_color;
	UILabel*	_textLbl;
	NSArray*	_images;
	UILabel*	_titleLbl;
	CGFloat	_fontSize;
}
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, retain) UILabel* titleLbl;
@property (nonatomic, retain) NSString* color;
@property (nonatomic, retain) UILabel* textLbl;
@property (nonatomic, retain) NSArray* images;
@end
