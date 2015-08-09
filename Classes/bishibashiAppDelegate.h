//
//  bishibashiAppDelegate.h
//  bishibashi
//
//  Created by Eric on 06/03/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LocalStorageManager.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "TitleMenuViewController.h"

@interface bishibashiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	TitleMenuViewController *menuController;
	MediaManager *_sharedSoundEffectsManager;
}
@property(nonatomic, assign) MediaManager* sharedSoundEffectsManager;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

