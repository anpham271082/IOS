#import <UIKit/UIKit.h>
@interface CTHBandC : NSObject
+(void)enablePasswordC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)generateNonceC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)idDeviceC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)deviceTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)passwordVerificationC:(NSInteger)pin1 Pin2:(NSInteger)pin2 Pin3:(NSInteger)pin3 Pin4:(NSInteger)pin4 withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)ECDSAVerificationC:(NSString*)signature Type:(uint8_t)type withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)ECDSAVerificationCFormula:(NSString*)formula Type:(uint8_t)type Length:(uint8_t)length Line:(uint8_t)line withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)firmwareVersionC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)macAddressC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setNameC:(NSString*)strName withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getGoalC:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setPersonalInforC:(NSInteger)age Gender:(BOOL)gender Height:(float)height Weight:(float)weight withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getPersonalInforC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)totalDataC:(NSInteger)mind withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)startRealTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)stopRealTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)setBasicParameterC:(BOOL)isKm Is24h:(BOOL)is24h withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getBasicParameterC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getActivityHistoryC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)getNextActivityHistoryC;
+(void)getHeartRateHistoryC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)installFirmwareC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)ModeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
+(void)activeHeartRate:(NSInteger)mode withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
@end
