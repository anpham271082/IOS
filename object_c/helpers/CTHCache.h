#import <UIKit/UIKit.h>
@interface CTHCache : NSObject
//NSUserDefault
+(void)clearWithKeyNSUserDefault:(NSString*)strKey;
+(void)setKeyWithBoolNSUserDefault:(NSString*)strKey Value:(BOOL)boolValue;
+(void)setKeyWithIntNSUserDefault:(NSString*)strKey Value:(NSInteger)intValue;
+(void)setKeyWithFloatNSUserDefault:(NSString*)strKey Value:(CGFloat)floatValue;
+(void)setKeyWithDoubleNSUserDefault:(NSString*)strKey Value:(double)doubleValue;
+(void)setKeyWithStringNSUserDefault:(NSString*)strKey Value:(NSString*)strValue;
+(void)setKeyWithDictionaryNSUserDefault:(NSString*)strKey Value:(NSMutableDictionary*)dicValue;
+(BOOL)getKeyWithBoolNSUserDefault:(NSString*)strKey;
+(NSInteger)getKeyWithIntNSUserDefault:(NSString*)strKey;
+(CGFloat)getKeyWithFloatNSUserDefault:(NSString*)strKey;
+(double)getKeyWithDoubleNSUserDefault:(NSString*)strKey;
+(NSString*)getKeyWithStringNSUserDefault:(NSString*)strKey;
+(NSMutableDictionary*)getKeyWithDictionaryNSUserDefault:(NSString*)strKey;
//PDKeychainBindings
+(void)clearWithKeyPDKeychainBinding:(NSString*)strKey;
+(void)setKeyWithBoolPDKeychainBinding:(NSString*)strKey Value:(BOOL)boolValue;
+(void)setKeyWithIntPDKeychainBinding:(NSString*)strKey Value:(NSInteger)intValue;
+(void)setKeyWithFloatPDKeychainBinding:(NSString*)strKey Value:(CGFloat)floatValue;
+(void)setKeyWithDoublePDKeychainBinding:(NSString*)strKey Value:(double)doubleValue;
+(void)setKeyWithStringPDKeychainBinding:(NSString*)strKey Value:(NSString*)strValue;
+(void)setKeyWithDictionaryPDKeychainBinding:(NSString*)strKey Value:(NSMutableDictionary*)dicValue;
+(BOOL)getKeyWithBoolPDKeychainBinding:(NSString*)strKey;
+(NSInteger)getKeyWithIntPDKeychainBinding:(NSString*)strKey;
+(CGFloat)getKeyWithFloatPDKeychainBinding:(NSString*)strKey;
+(double)getKeyWithDoublePDKeychainBinding:(NSString*)strKey;
+(NSString*)getKeyWithStringPDKeychainBinding:(NSString*)strKey;
+(NSMutableDictionary*)getKeyWithDictionaryPDKeychainBinding:(NSString*)strKey;
+(void)destroyLackingDataProtection;
+(void)destroyNetworkCache;
@end
