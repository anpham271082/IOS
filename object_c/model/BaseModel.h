#import <Foundation/Foundation.h>
@interface BaseModel : NSObject
+(instancetype)sharedInstance;
-(id)initWithDictionary:(NSMutableDictionary*)dic;
-(NSMutableDictionary*)getDictionary;
@end
