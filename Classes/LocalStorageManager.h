//
//  LocalStorageManager.h


#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GameRecord.h"



@interface LocalStorageManager : NSObject {
}

// User Default wrapper
+ (NSArray *) arrayForKey:(NSString*) key;
+ (BOOL) boolForKey:(NSString*) key;
+ (NSData*) dataForKey:(NSString*) key;
+ (NSDictionary*) dictionaryForKey:(NSString*) key;
+ (float) floatForKey:(NSString*) key;
+ (int) integerForKey:(NSString*) key;
+ (NSObject*) objectForKey:(NSString*) key;
+ (NSArray *) stringArrayForKey:(NSString*) key;
+ (NSString*) stringForKey:(NSString*) key;
+ (double) doubleForKey:(NSString*) key;

+ (void) setBool:(BOOL) aBool forKey:(NSString*) key;
+ (void) setFloat:(float) aFloat forKey:(NSString*) key;
+ (void) setInteger:(int) aInt forKey:(NSString*) key;
+ (void) setObject:(NSObject*) aObj forKey:(NSString*) key;
+ (void) setDouble:(double) aDouble forKey:(NSString*) key;

+ (void) setCustomObject:(NSObject*) aObj forKey:(NSString*) key;
+ (id) customObjectForKey:(NSString*) key;

//For Images
+ (UIImage*) getStoredImage:(NSString*) key;
+ (void) addImageToStorage:(UIImage *) image withKey:(NSString*) key;
@end
