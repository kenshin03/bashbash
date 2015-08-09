//
//  CreditView.h
//  bishibashi
//
//  Created by Eric on 06/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreditView : UIView {
	UIActivityIndicatorView* _aiView;
	BOOL _isFromTransition;
	NSArray* _photos;
	id _owner;
	UIButton*	_infoBut;
	UIWebView*	_webView;
	UIInterfaceOrientation	_orientation;
}
@property (nonatomic, retain) UIActivityIndicatorView* aiView;
@property (nonatomic, assign) BOOL isFromTransition;
@property (nonatomic, assign) id owner;
@property (nonatomic, retain) UIButton* infoBut;
@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end
