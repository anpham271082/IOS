#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CTHCoreData : NSObject
+(void)addEntity:(NSManagedObjectContext *)context Entity:(NSString*)entity Dictionary:(NSDictionary*)dic Attributes:(NSString*)attributes Param:(NSString*)param;
+(NSMutableDictionary*)getEntity:(NSManagedObjectContext *)context Entity:(NSString*)entity Param:(NSString*)param;
@end
