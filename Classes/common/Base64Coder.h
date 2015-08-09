#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (NSStringAdditions)

- (NSString *) urlEncoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end
