//
//  WebImageView.h
//  FBModule
//
//  Created by Eric on 20/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalStorageManager.h"

@interface WebImageView : UIView {
	UIImageView*	_imageView;
	UIActivityIndicatorView*	_aiView;
	NSString*	_imageUrl;
	NSMutableData*	_imageData;
	UIImage*	_recvImage;
}
@property (nonatomic, retain) UIImage* recvImage;
@property (nonatomic, retain) NSMutableData* imageData;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIActivityIndicatorView* aiView;
@property (nonatomic, retain) NSString* imageUrl;

-(id) initWithFrame:(CGRect)frame AndImageUrl:(NSString*)imageUrl;

@end
