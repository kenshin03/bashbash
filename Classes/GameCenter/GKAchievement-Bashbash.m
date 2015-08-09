//
//  GKAchievement-Bashbash.m
//  bishibashi
//
//  Created by Eric on 08/09/2010.
//  Copyright 2010 Red Soldier Limited. All rights reserved.
//

#import "GKAchievement-Bashbash.h"


@implementation GKAchievement(GKAchievement_Bashbash)

- (BOOL)isEqual:(id)anObject
{
	if (([anObject isKindOfClass:[GKAchievement class]])&&([[self identifier] isEqualToString:[anObject identifier]]))
		return YES;
	else
		return NO;
}

@end
