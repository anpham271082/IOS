#import <UIKit/UIKit.h>
@interface CTHJson : NSObject
+(NSString*)stringFromObject:(id)object;
+(id)dictionaryWithJSONString:(NSString *)strJson;
@end
