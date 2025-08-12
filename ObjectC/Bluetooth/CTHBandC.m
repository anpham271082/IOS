#import "CTHHelper.h"
#import "CTHBaseBand.h"
#import "CTHBandC.h"
@interface CTHBandC ()
@end
@implementation CTHBandC
+(void)enablePasswordC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ENABLE_PASSWORD_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)generateNonceC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GENERATE_NONCE_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)idDeviceC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ID_DEVICE_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)deviceTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_DEVICE_TIME_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)ECDSAVerificationC:(NSString*)signature Type:(uint8_t)type withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    NSString *leftManufacturerSignature64;
    NSString *rightManufacturerSignature64;
    if(signature.length>140){
        leftManufacturerSignature64 = [signature substringToIndex:signature.length-70];
        leftManufacturerSignature64 = [[leftManufacturerSignature64 substringFromIndex:leftManufacturerSignature64.length-64] uppercaseString];
        if([leftManufacturerSignature64 hasPrefix:@"00"]){
            leftManufacturerSignature64 = [[[signature substringFromIndex:10] substringToIndex:64] uppercaseString];
        }
        rightManufacturerSignature64 = [[signature substringFromIndex:signature.length-64] uppercaseString];
    }else{
        leftManufacturerSignature64 = [signature substringToIndex:signature.length-68];
        leftManufacturerSignature64 = [[leftManufacturerSignature64 substringFromIndex:leftManufacturerSignature64.length-64] uppercaseString];
        rightManufacturerSignature64 = [[signature substringFromIndex:signature.length-64] uppercaseString];
    }
    NSString *hexString;
    if(type==1)
        hexString = [@"80010000" stringByAppendingString:leftManufacturerSignature64];
    else
        hexString = [@"80000000" stringByAppendingString:leftManufacturerSignature64];
    hexString = [hexString stringByAppendingString:rightManufacturerSignature64];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ECDSA_VERIFICATION_C withComplete:callComplete withError:callError];
    uint8_t *bytes = (uint8_t *)malloc(sizeof(uint8_t) * ([hexString length] / 2));
    for(int i = 0; i < [hexString length]; i += 2) {
        NSRange range = { i, 2 };
        NSString *subString = [hexString substringWithRange:range];
        unsigned value;
        [[NSScanner scannerWithString:subString] scanHexInt:&value];
        bytes[i / 2] = (uint8_t)value;
    }
    [[CTHBaseBand sharedInstance] execute_extend:bytes Length:[hexString length]/2 Type:CBCharacteristicWriteWithResponse];
}
+(void)ECDSAVerificationCFormula:(NSString*)formula Type:(uint8_t)type Length:(uint8_t)length Line:(uint8_t)line withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ECDSA_VERIFICATION_C_FORMULA withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x80,type,length,line,0,0,0,0,0,0,0,0,0,0 , 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0};
    for (NSInteger i = 0; i<formula.length; i++) {
        bytes[i+4] =  [formula characterAtIndex:i];
    }
    [[CTHBaseBand sharedInstance] execute_extend:bytes Length:124 Type:CBCharacteristicWriteWithResponse];
}
+(void)passwordVerificationC:(NSInteger)pin1 Pin2:(NSInteger)pin2 Pin3:(NSInteger)pin3 Pin4:(NSInteger)pin4 withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_PASSWORD_VERIFICATION_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x30,0x30+pin1,0x30+pin2,0x30+pin3,0x30+pin4,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)firmwareVersionC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_FIRMWARE_VERSION_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)macAddressC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_MAC_ADDRESS_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setNameC:(NSString*)strName withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_SET_DEVICE_NAME_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x3D,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    for (NSInteger i = 0; i<(strName.length>=14?14:strName.length); i++) {
        bytes[i+1] =  [strName characterAtIndex:i];
    }
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    NSDateComponents *components = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_CURRENT_TIME_C withComplete:callComplete withError:callError];
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
+(void)getGoalC:(NSInteger)day withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_GOAL_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x4B,day,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setPersonalInforC:(NSInteger)age Gender:(BOOL)gender Height:(float)height Weight:(float)weight withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_SET_PERSONAL_INFOR_C withComplete:callComplete withError:callError];
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
+(void)getPersonalInforC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_PERSONAL_INFOR_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)totalDataC:(NSInteger)mind withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    //99:delete all history data, 0:read all history data
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_TOTAL_DATA_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x51,mind,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)startRealTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_START_REAL_TIME_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x09,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)stopRealTimeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_STOP_REAL_TIME_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x09,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)setBasicParameterC:(BOOL)isKm Is24h:(BOOL)is24h withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    NSInteger distanceUnit = (isKm==YES)?0:1;
    NSInteger timeUnit = (is24h==YES)?0:1;
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_SET_BASIC_PARAMATER_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x03,distanceUnit|0x80,timeUnit|0x80,0x80,0x80,60|0x80,0x80,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getBasicParameterC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_BASIC_PARAMATER_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x04,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getActivityHistoryC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_ACTIVITY_HISTORY_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x52,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getNextActivityHistoryC{
    uint8_t bytes[] = {0x52,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)getHeartRateHistoryC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_GET_HEART_RATE_HISTORY_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x54,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)installFirmwareC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_INSTALL_FIRMWARE_C withComplete:callComplete withError:callError];
}
+(void)ModeC:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_MODE_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
+(void)activeHeartRate:(NSInteger)mode withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [[[CTHBaseBand sharedInstance] getDataArray] removeAllObjects];
    [[CTHBaseBand sharedInstance] setCompleteError:BAND_ACTIVE_HEART_RATE_C withComplete:callComplete withError:callError];
    uint8_t bytes[] = {0x19,mode,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    [[CTHBaseBand sharedInstance] sum:bytes];
    [[CTHBaseBand sharedInstance] execute:bytes Type:CBCharacteristicWriteWithResponse];
}
@end
