//
//  SoundEffect.h
//  bishibashi
//
//  Created by Kenny Tang on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LocalStorageManager.h"

@interface SoundEffect : NSObject {
	SystemSoundID ssId;
}
-(id)initWithFileName:(NSString*)name andExt:(NSString*)ext;
-(void)playSound;
@end
