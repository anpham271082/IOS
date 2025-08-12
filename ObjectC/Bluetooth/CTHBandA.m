
#import "CTHHelper.h"
#import "CTHBaseBand.h"
#import "CTHBandA.h"
@interface CTHBandA ()
@end
@implementation CTHBandA
+(void)getGoalA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_GOAL_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x08,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setNameA:(NSString*)strName withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_SET_NAME_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x3D,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    for (int i = 0; i<(strName.length>=14?14:strName.length); i++) {
        bytes[i+1] = [strName characterAtIndex:i];
    }
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)resetA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_RESET_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x2E,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setTimeModeA:(BOOL)is24h withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_TIME_MODE_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x37,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    if(is24h)
        bytes[1] = 1;
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setCurrentTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    NSDateComponents *components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_CURRENT_TIME_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x01,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    bytes[1] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components year]%100]] integerValue];
    bytes[2] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components month]]] integerValue];
    bytes[3] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components day]]] integerValue];
    bytes[4] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components hour]]] integerValue];
    bytes[5] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components minute]]] integerValue];
    bytes[6] = [[CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%ld",(long)[components second]]] integerValue];
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setStepsA:(BOOL)gender withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    NSInteger cc;
    NSInteger bb;
    NSInteger stepGoal;
    /*if (gender)
        stepGoal = [ConfigModel sharedInstance].step_boy;
    else
        stepGoal = [ConfigModel sharedInstance].step_girl;*/
    NSInteger aa = stepGoal / 65536;
    if (aa > 0) {
        bb = (stepGoal - ((((aa * 16) * 16) * 16) * 16)) / 256;
        cc = stepGoal - (((aa * 16) * 16) * 16) * 16 - (bb * 16) * 16;
    } else {
        bb = stepGoal / 256;
        cc = stepGoal - (bb * 16) * 16;
    }
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_STEPS_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x0B,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    bytes[1] =  aa;
    bytes[2] =  bb;
    bytes[3] =  cc;
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setPersonalInforA:(NSInteger)age Gender:(BOOL)gender Height:(float)height Weight:(float)weight withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_PERSONAL_INFOR_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x02,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    if (gender){
        bytes[1] = 1;
        bytes[5] = (int)floorf(0.415f*(height*100.f));
    }else{
        bytes[1] = 0;
        bytes[5] = (int)floorf(0.413f*(height*100.f)) ;
    }
    bytes[2] = age;
    bytes[3] = (int)floorf(height*100.f);
    bytes[4] = (int)floorf(weight);
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getActivityDetailA:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ACTIVITY_DETAIL_A withComplete:callComplete withError:callError];
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    uint8_t bytes[] = {0x43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    bytes[1] = day;
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getTotalActivityA:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_TOTAL_ACTIVITY_A withComplete:callComplete withError:callError];
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    uint8_t bytes[] = {0x07,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    bytes[1] = day;
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)startRealTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_START_REAL_TIME_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x09,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x09};
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)stopRealTimeA:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_STOP_REAL_TIME_A withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x0A,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x0A};
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
@end
