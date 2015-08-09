//
//  ImageSettingsViewController.h
//  bishibashi
//
//  Created by Eric on 13/06/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStorageManager.h"
#import "PhotoTakingViewController.h"
#import "Baby.h"
#import "LocalStorageManager.h"

@interface ImageSettingsViewController : UITableViewController {
	
	UIImageView*	_normalFace;
	UIImageView*	_cryingFace;
	UIImageView*	_openMouthFace;
	
	NSDictionary*	_inGameImages;
}
@property (nonatomic, retain) UIImageView* normalFace;
@property (nonatomic, retain) UIImageView* cryingFace;
@property (nonatomic, retain) UIImageView* openMouthFace;

@property (nonatomic, retain) NSDictionary* inGameImages;
@end
