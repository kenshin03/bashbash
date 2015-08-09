#import <Foundation/Foundation.h>


@interface NSString(Extension)

+ (NSString*) YYYYMMDD:(NSDate*) date;
+ (NSString*) YYYYMMDDTime:(NSDate*) date;
+ (NSString*) timeSince:(NSDate*) date;
@end

@interface NSDate(Extension)
- (void) eliminateMilliseconds;
- (void) addNumber:(int) num;
- (void) eliminateMillisecondsAndAddNumber:(int) num;
@end