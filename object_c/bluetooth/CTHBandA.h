#import <UIKit/UIKit.h>
@interface CTHBandA : NSObject
+(void)getGoalA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setNameA:(NSString*)strName withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)resetA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setTimeModeA:(BOOL)is24h withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setCurrentTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setStepsA:(BOOL)gender withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setPersonalInforA:(NSInteger)age Gender:(BOOL)gender Height:(float)height Weight:(float)weight withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getActivityDetailA:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getTotalActivityA:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)startRealTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)stopRealTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
@end
