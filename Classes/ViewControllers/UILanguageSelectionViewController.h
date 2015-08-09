//
//  GameFrameSelectonController.h
//  bishibashi
//
//  Created by Eric on 23/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILanguageSelectionViewController : UITableViewController {
	
	NSArray*	_availableLanguages;
	NSArray*	_availableLanguagesLN;
	id	_delegate;
}
@property (nonatomic, retain) NSArray* availableLanguages;
@property (nonatomic, retain) NSArray* availableLanguagesLN;
@property (nonatomic, assign) id delegate;
@end
