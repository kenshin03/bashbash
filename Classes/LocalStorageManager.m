//
//  LocalStorageManager.m
//

#import "LocalStorageManager.h"

@implementation LocalStorageManager


#pragma mark -
#pragma mark NSUserDefaults Wrapper
+ (NSArray *) arrayForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+ (BOOL) boolForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (NSData*) dataForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}

+ (NSDictionary*) dictionaryForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

+ (float) floatForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (int) integerForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (NSObject*) objectForKey:(NSString*) key
{
	NSObject* result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (result==nil && [key isEqualToString:COUNTRY])	{
		[LocalStorageManager setObject:@"Hong Kong" forKey:key];
		result = @"Hong Kong";
	}
	else if (result == nil && [key isEqualToString:GAMEFRAME])	{
		[LocalStorageManager setObject:@"black" forKey:key];
		result = @"black";
	}
	return result;
}

+ (NSArray *) stringArrayForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] stringArrayForKey:key];
}

+ (NSString*) stringForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (double) doubleForKey:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

+ (void) setBool:(BOOL) aBool forKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:key];
}

+ (void) setFloat:(float) aFloat forKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] setFloat: aFloat forKey:key];
}

+ (void) setInteger:(int) aInt forKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] setInteger:aInt forKey:key];
}

+ (void) setObject:(NSObject*) aObj forKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] setObject:aObj forKey:key];
}

+ (void) setDouble:(double) aDouble forKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] setDouble: aDouble forKey:key];
}

+ (void) setCustomObject:(NSObject*) aObj forKey:(NSString*) key
{
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:aObj];
	[[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:key];
}

+ (id) customObjectForKey:(NSString*) key
{
	NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSData * myEncodedObject = [userDefault objectForKey:key];
	id obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if([obj class] == [NSNull class])
	{
		return nil;
	}
	return obj;
}

+ (void) removeObjectForKey:(NSString*) key
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

// For GameRecord
+ (void) addGameRecordToStorage:(GameRecord*) gameRecord
{
	/* for Local Record (order by time) */
	NSDictionary* localrecord = [LocalStorageManager customObjectForKey:LOCALRECORD];
	NSMutableDictionary* newlocalrecord;
	if (localrecord)		{
		newlocalrecord = [NSMutableDictionary dictionaryWithDictionary:localrecord];
	}
	else	{
		newlocalrecord = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	
	NSArray* records = [newlocalrecord objectForKey:[NSNumber numberWithInt:gameRecord.game]];
	NSMutableArray* newrecords;
	if (records)	{
		newrecords = [NSMutableArray arrayWithArray:records];
	}
	else	{
		newrecords = [NSMutableArray arrayWithCapacity:20];
	}
	
	[newrecords insertObject:gameRecord atIndex:0];
	if ([newrecords count]>10)
		[newrecords removeLastObject];
	[newlocalrecord setObject:newrecords forKey:[NSNumber numberWithInt:gameRecord.game]];
	[LocalStorageManager setCustomObject:newlocalrecord forKey:LOCALRECORD];
	
	/* for Local Record (order by score) */
	NSDictionary* localhighestrecord = [LocalStorageManager customObjectForKey:LOCALHIGHESTRECORD];
	NSMutableDictionary* newlocalhighestrecord;
	if (localhighestrecord)		{
		newlocalhighestrecord = [NSMutableDictionary dictionaryWithDictionary:localhighestrecord];
	}
	else	{
		newlocalhighestrecord = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	
	records = [newlocalhighestrecord objectForKey:[NSNumber numberWithInt:gameRecord.game]];
	newrecords;
	if (records)	{
		newrecords = [NSMutableArray arrayWithArray:records];
	}
	else	{
		newrecords = [NSMutableArray arrayWithCapacity:20];
	}

	if ([newrecords count] < 10 || gameRecord.score > [[newrecords lastObject] score])	{
		[newrecords insertObject:gameRecord atIndex:0];
		[newrecords sortUsingSelector:@selector(inversecompare:)];
	}
	
	if ([newrecords count]>10)
		[newrecords removeLastObject];
	[newlocalhighestrecord setObject:newrecords forKey:[NSNumber numberWithInt:gameRecord.game]];
	[LocalStorageManager setCustomObject:newlocalhighestrecord forKey:LOCALHIGHESTRECORD];
	
}
	
+ (NSArray*) getGameRecords:(Game) game
{
	NSDictionary* localrecord = [LocalStorageManager customObjectForKey:LOCALRECORD];
	NSArray* records = [localrecord objectForKey:[NSNumber numberWithInt:game]];
	return records;
}

+ (NSArray*) getHighestGameRecords:(Game) game
{
	NSDictionary* localrecord = [LocalStorageManager customObjectForKey:LOCALHIGHESTRECORD];
	NSArray* records = [localrecord objectForKey:[NSNumber numberWithInt:game]];
	return records;
}


// For Images
+ (UIImage*) getStoredImage:(NSString*) key
{
	NSArray * imageList = [LocalStorageManager arrayForKey:STORED_IMAGE_LIST];
	if(imageList)
	{
		for(NSString * imageKey in imageList)
		{
			if([key isEqualToString:imageKey])
			{
				NSData * imageData = [LocalStorageManager dataForKey:key];
				return [[[UIImage alloc] initWithData:imageData] autorelease];
			}
		}
	}
	else
	{
		NSLog(@"No image list");
	}
	return nil;
}

+ (void) addImageToStorage:(UIImage *) image withKey:(NSString*) key
{
	if(image)
	{
		NSMutableArray * imageList = [NSMutableArray arrayWithArray:[LocalStorageManager arrayForKey:STORED_IMAGE_LIST]];
		NSData * imageData = UIImagePNGRepresentation(image);
		if(imageList && imageData)
		{
			[imageList addObject:key];
			[LocalStorageManager setObject:imageData forKey:key];
			[LocalStorageManager setObject:imageList forKey:STORED_IMAGE_LIST];
		}
		else if(imageData)
		{
			imageList = [NSMutableArray array];
			[imageList addObject:key];
			[LocalStorageManager setObject:imageData forKey:key];
			[LocalStorageManager setObject:imageList forKey:STORED_IMAGE_LIST];
		}
		else
		{
			NSLog(@"Cannot add Image : image = nil");
		}
	}
}
+(NSArray*) getStoredImages:(NSString*)key
{
	NSString* uuidstr0 = [NSString stringWithFormat:@"%@-%d", key, 0];
	NSString* uuidstr1 = [NSString stringWithFormat:@"%@-%d", key, 1];
	NSString* uuidstr2 = [NSString stringWithFormat:@"%@-%d", key, 2];

	NSArray* images = [NSArray arrayWithObjects:[LocalStorageManager getStoredImage:uuidstr0],[LocalStorageManager getStoredImage:uuidstr1],[LocalStorageManager getStoredImage:uuidstr2],nil];
	return images;
}
	
+(void) addImagesToStorage:(NSArray*) images
{
	CFUUIDRef   uuid; 
	uuid = CFUUIDCreate(NULL); 
	NSString* uuidstr = CFUUIDCreateString(NULL, uuid);
	NSString* uuidstr0 = [NSString stringWithFormat:@"%@-%d", uuidstr,0];
	NSString* uuidstr1 = [NSString stringWithFormat:@"%@-%d", uuidstr,1];
	NSString* uuidstr2 = [NSString stringWithFormat:@"%@-%d", uuidstr,2];
	CFRelease(uuid); 
	
	[LocalStorageManager addImageToStorage:[images objectAtIndex:0] withKey:uuidstr0];
	[LocalStorageManager addImageToStorage:[images objectAtIndex:1] withKey:uuidstr1];
	[LocalStorageManager addImageToStorage:[images objectAtIndex:2] withKey:uuidstr2];
	
	NSMutableArray* keyList = [NSMutableArray arrayWithArray:[LocalStorageManager stringArrayForKey:STORED_INGAME_IMAGE_LIST]];
	[keyList addObject:uuidstr];
	[LocalStorageManager setObject:keyList forKey:STORED_INGAME_IMAGE_LIST];
	keyList = [LocalStorageManager stringArrayForKey:STORED_INGAME_IMAGE_LIST];
}

+(NSDictionary*) getInGameImages
{
	NSArray* keyList = [LocalStorageManager stringArrayForKey:STORED_INGAME_IMAGE_LIST];
	NSDictionary* result = [NSMutableDictionary dictionaryWithCapacity:[keyList count]];
	for (NSString* key in keyList)	{
		NSArray* images = [LocalStorageManager getStoredImages:key];
		[result setObject:images forKey:key];
	}
	return result;
}

+(void) deleteInGameImage:(NSString*)key
{
	NSMutableArray* keyList = [NSMutableArray arrayWithArray:[LocalStorageManager stringArrayForKey:STORED_INGAME_IMAGE_LIST]];
	[keyList removeObject:key];
	[LocalStorageManager setObject:keyList forKey:STORED_INGAME_IMAGE_LIST];
	NSString* uuidstr0 = [NSString stringWithFormat:@"%@-%d", key, 0];
	NSString* uuidstr1 = [NSString stringWithFormat:@"%@-%d", key, 1];
	NSString* uuidstr2 = [NSString stringWithFormat:@"%@-%d", key, 2];
	[LocalStorageManager removeObjectForKey:uuidstr0];
	[LocalStorageManager removeObjectForKey:uuidstr1];
	[LocalStorageManager removeObjectForKey:uuidstr2];
}

+(NSArray*) getGameImagesInUse
{
	if ([LocalStorageManager boolForKey:USEINGAMEIMAGES])	{
		NSArray* keyList = [LocalStorageManager stringArrayForKey:STORED_INGAME_IMAGE_LIST];
		if ([LocalStorageManager stringForKey:INGAMEIMAGESKEY])
			return [LocalStorageManager getStoredImages:[LocalStorageManager stringForKey:INGAMEIMAGESKEY]];
		else if ([keyList count]>0)	{
			NSString* key = [keyList objectAtIndex:0];
			return [LocalStorageManager getStoredImages:key];
		}
	}
	return nil;
}	
@end
