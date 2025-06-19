#import "CTHHelper.h"
#import "CTHBaseBand.h"
#import "CTHBandC.h"
@implementation CTHBaseBand
-(void)sum:(uint8_t[])bytes{
    NSInteger s = 0;
    for (NSInteger i=0; i<15; i++){
        s += bytes[i];
    }
    bytes[15] = s;
}
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initBluetooth];
    });
    return sharedInstance;
}
-(void)initBluetooth{
    self.intStatePowered = STATE_POWERED_OFF;
    self.response = [[NSMutableDictionary alloc] init];
    self.deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self getCBCentralManager];
}
-(CBCentralManager*)getCBCentralManager{
    if (!self.cbCentralManager) {
        if(SYSTEM_VERSION_LESS_THAN(@"11.1")){
            self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
        }else{
            self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
        }
    }
    return self.cbCentralManager;
}
-(void)disconnect:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
    self.intStatus = BAND_DISCONNECT;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    BOOL flag = FALSE;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayGetBandDevices) object:nil];
    if(self.cbCentralManager){
        [self.cbCentralManager stopScan];
        if(self.cbPeripheral){
            if (self.cbPeripheral.state==CBPeripheralStateConnected){
                flag = TRUE;
                [self.cbCentralManager cancelPeripheralConnection:self.cbPeripheral];
            }
        }
    }
    if(!flag){
        if(self.callbackComplete)
            self.callbackComplete(nil);
    }
}
-(void)getStatePowered:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.intStatus = BAND_DATA_POWERED;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    if (self.cbCentralManager){
        if ([self.cbCentralManager state] == CBManagerStatePoweredOn) {
            self.intStatePowered = STATE_POWERED_ON;
        }else if ([self.cbCentralManager state] == CBManagerStatePoweredOff){
            self.intStatePowered = STATE_POWERED_OFF;
        }
        if(self.callbackComplete)
            self.callbackComplete(nil);
    }
    [self getCBCentralManager];
}
-(void)getBandDevices:(void(^)(NSMutableDictionary* response))callComplete withDone:(void(^)(NSMutableDictionary* response))callDone withError:(void(^)(void))callError{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
    self.intStatus = BAND_DATA_GET_DEVICES;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    self.callbackDone = callDone;
    [self.deviceArray removeAllObjects];
    [self.response setObject:self.deviceArray forKey:@"devices"];
    if(self.callbackComplete)
        self.callbackComplete(self.response);
    if([self getCBCentralManager]){
        [self.cbCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       [self delayGetBandDevices];
                   });
}
-(void)delayGetBandDevices{
    if(self.intStatus == BAND_DATA_GET_DEVICES){
        if(self.cbCentralManager){
            [self.cbCentralManager stopScan];
        }
        [self.response setObject:self.deviceArray forKey:@"devices"];
        if(self.callbackDone)
            self.callbackDone(self.response);
    }
}
-(void)stopScanBand{
    if(self.cbCentralManager){
        [self.cbCentralManager stopScan];
        if(self.callbackDone)
            self.callbackDone(self.response);
    }
}
-(BOOL)checkUDID:(NSUUID*)identifier{
    for (NSInteger i=0; i<[self.deviceArray count]; i++) {
        CBPeripheral *peripheral = [self.deviceArray objectAtIndex:i][@"peripheral"];
        if ([peripheral.identifier isEqual:identifier])
            return TRUE;
    }
    return FALSE;
}
-(BOOL)checkConnectBand{
    if(self.cbCentralManager){
        if(self.cbPeripheral){
             if (self.cbPeripheral.state==CBPeripheralStateConnected)
                 return TRUE;
        }
    }
    return FALSE;
}
-(CBPeripheral*)retrievePeripheral:(NSString *)uuidString{
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuidString];
    NSArray *peripheralArray = [self.cbCentralManager retrievePeripheralsWithIdentifiers:@[nsUUID]];
    if([peripheralArray count] > 0){
        CBPeripheral *peripheral = [peripheralArray objectAtIndex:0];
        return peripheral;
    }
    return nil;
}

-(NSString*)getUUIDString{
    return self.cbPeripheral.identifier.UUIDString;
}
-(void)setkCBAdvDataServiceUUID:(NSString*)serviceUUID{
    self.kCBAdvDataServiceUUID = [serviceUUID copy];
}
-(CBPeripheral*)getPeripheral{
    return self.cbPeripheral;
}
-(void)connectBand:(CBPeripheral*)peripheral ServiceUUID:(NSString*)serviceUUID withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.service_UUID = serviceUUID;
    self.intStatus = BAND_CONNECTING;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    if(self.cbCentralManager){
        self.cbPeripheral = peripheral;
        if (self.cbPeripheral.state!=CBPeripheralStateConnected){
            [self.cbCentralManager connectPeripheral:peripheral options:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
            [self performSelector:@selector(waitDisconnect) withObject:nil afterDelay:8];
        }else
            [self connectToTargetService];
    }else{
        self.intStatus = BAND_DISCONNECT;
        if(self.callbackError)
            self.callbackError();
    }
}
-(void)waitDisconnect{
    if(self.callbackError)
        self.callbackError();
}
//CBCentralManager
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if ([central state] == CBCentralManagerStatePoweredOn) {
        self.intStatePowered = STATE_POWERED_ON;
        if(self.intStatus == BAND_DATA_GET_DEVICES){
            [self.cbCentralManager scanForPeripheralsWithServices:nil options:nil];
        }
    }else if ([central state] == CBCentralManagerStatePoweredOff){
        self.intStatePowered = STATE_POWERED_OFF;
        self.cbCentralManager = nil;
        if(!SYSTEM_VERSION_LESS_THAN(@"11.1")) {
            BOOL flag = NO;
            for (UIWindow* window in [UIApplication sharedApplication].windows) {
                NSArray* subviews = window.subviews;
                if ([subviews count] > 0)
                    if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]]){
                        flag = YES;
                        break;
                    }
            }
            if(flag==NO){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Turn On Bluetooth to Allow \"Champ Band\" to Connect to Accessories\nIf you're using iOS version 11.1 and above, please turn on your bluetooth from Control Center" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        if(self.callbackError)
            self.callbackError();
    }
    if(self.intStatus == BAND_DATA_POWERED){
        if(self.callbackComplete)
            self.callbackComplete(nil);
    }
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(self.intStatus == BAND_DATA_GET_DEVICES){
        if(self.cbCentralManager){
            NSDictionary *result = @{@"peripheral": peripheral, @"advertisementData": advertisementData, @"RSSI": RSSI};
            NSArray * allKeys = [advertisementData allKeys];
            if([allKeys containsObject:@"kCBAdvDataServiceUUIDs"]&&[allKeys containsObject:@"kCBAdvDataLocalName"]){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                for (NSString* key in result){
                    [dic setValue:[result valueForKey:key] forKey:key];
                }
                if (![self.deviceArray containsObject:result]) {
                    if([[advertisementData valueForKey:@"kCBAdvDataServiceUUIDs"] count]>0){
                        NSString *_kCBAdvDataServiceUUID =  [NSString stringWithFormat:@"%@", [[advertisementData valueForKey:@"kCBAdvDataServiceUUIDs"] objectAtIndex:0]];
                        if([_kCBAdvDataServiceUUID isEqualToString:@"FFF0"] || [_kCBAdvDataServiceUUID isEqualToString:@"FFE0"]){
                            if (![self checkUDID:peripheral.identifier])
                                [self.deviceArray addObject:dic];
                        }
                    }
                }else{
                    for (NSInteger i=0; i<[self.deviceArray count]; i++) {
                        CBPeripheral *per = [self.deviceArray objectAtIndex:i][@"peripheral"];
                        if ([per.identifier isEqual:peripheral.identifier]){
                            [self.deviceArray replaceObjectAtIndex:i withObject:dic];
                            break;
                        }
                    }
                }
            }
        }else{
            [self.deviceArray removeAllObjects];
        }
        [self.response setObject:self.deviceArray forKey:@"devices"];
        if(self.callbackComplete)
            self.callbackComplete(self.response);
    }
}
    
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
    self.cbPeripheral = peripheral;
    [self connectToTargetService];
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
    if(self.callbackComplete)
        self.callbackComplete(self.response);
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
}
-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
}
-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
}
//CBPeripheral
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for(CBService *service in peripheral.services){
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]] || [service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]){
            if([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]])
               self.service_UUID = @"FFF0";
            else if([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
                self.service_UUID = @"FFE0";
            self.service = service;
            [self establishConnectionChannel];
            break;
        }
    }
}
-(void)connectToTargetService{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisconnect) object:nil];
    self.serviceUUID = [CBUUID UUIDWithString:self.service_UUID];
    self.cbPeripheral.delegate = self;
    [self.cbPeripheral discoverServices:@[self.serviceUUID]];
}
-(void)establishConnectionChannel{
    if([self.service_UUID isEqualToString:@"FFF0"]){
        self.txUUID = [CBUUID UUIDWithString:@"FFF6"];
        self.rxUUID = [CBUUID UUIDWithString:@"FFF7"];
    }else if([self.service_UUID isEqualToString:@"FFE0"]){
        self.txUUID = [CBUUID UUIDWithString:@"FFE6"];
        self.rxUUID = [CBUUID UUIDWithString:@"FFE7"];
    }
    [self.cbPeripheral discoverCharacteristics:@[self.txUUID, self.rxUUID] forService:self.service];
}
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if(self.intStatus==BAND_DATA_ZERO_NAME){
        if([self.service_UUID isEqualToString:@"FFF0"]){
            [self notification:ISSC_SERVICE_UUID characteristicUUID:ISSC_CHAR_RX_UUID p:self.cbPeripheral on:YES];
        }else{
            [self notification:ISSC_SERVICE_UUID_NEW characteristicUUID:ISSC_CHAR_RX_UUID_NEW p:self.cbPeripheral on:YES];
        }
    }else if(self.intStatus == BAND_CONNECTING){
        for(CBCharacteristic *characteristic in service.characteristics){
            if([self.service_UUID isEqualToString:@"FFF0"]){
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF6"]])
                    self.txCharacteristic = characteristic;
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]])
                    self.rxCharacteristic = characteristic;
            }else if([self.service_UUID isEqualToString:@"FFE0"]){
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE6"]])
                    self.txCharacteristic = characteristic;
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE7"]])
                    self.rxCharacteristic = characteristic;
            }
        }
        self.intStatus = BAND_CONNECTED;
        if(self.callbackComplete)
            self.callbackComplete(nil);
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}
-(void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error{
    NSData *data = characteristic.value;
    if(data && data.length >= 16){
        NSArray *hexArray = [CTHHelper hexInArray:data];
        if([self wristBandA:hexArray Characteristic:characteristic])
            return;
        if([self wristBandC:hexArray Characteristic:characteristic])
            return;
        if(self.callbackError)
            self.callbackError();
    }else{
        if(self.intStatus==BAND_GET_ACTIVITY_HISTORY_C||self.intStatus==BAND_GET_HEART_RATE_HISTORY_C||self.intStatus==BAND_INSTALL_FIRMWARE_C){
            NSArray *hexArray = [CTHHelper hexInArray:data];
            if([self wristBandC:hexArray Characteristic:characteristic])
                return;
        }
    }
    /*if(self.intStatus == BAND_DATA_ZERO_NAME){
        unsigned char buf[4096] = {0};
        [characteristic.value getBytes:buf];
        if (buf[0]==0x42) {
            [self changeZeroName:buf];
        }//else
            //[self closeDisconnectAll];
    }*/
    
    //[self didUpdateValueForCharacteristic:data];
}
-(BOOL)wristBandA:(NSArray*)hexArray Characteristic:(CBCharacteristic*)characteristic{
    switch (self.intStatus) {
        case BAND_GET_GOAL_A:
            if([hexArray[0] isEqual: @"08"]){
                NSString *goal = [CTHHelper hexToDecimal:[NSString stringWithFormat:@"0x%@", hexArray[5]]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:goal forKey:@"goal"];
                [self.response setObject:dic forKey:@"goal"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_SET_NAME_A:
            if([hexArray[0] isEqual: @"3d"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_RESET_A:
            if([hexArray[0] isEqual: @"2e"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_TIME_MODE_A:
            if([hexArray[0] isEqual: @"37"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_CURRENT_TIME_A:
            if([hexArray[0] isEqual: @"01"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_STEPS_A:
            if([hexArray[0] isEqual: @"0b"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_PERSONAL_INFOR_A:
            if([hexArray[0] isEqual: @"02"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_ACTIVITY_DETAIL_A:
            if([hexArray[0] isEqual: @"43"]){
                NSString *activityMode = [hexArray[6] isEqualToString:@"00"] ? @"normal mode" : @"sleep mode";
                if([activityMode isEqualToString:@"normal mode"]){
                    NSString *kilocalorie = [NSString stringWithFormat:@"%ld",256 * (255 & [[CTHHelper hexToDecimal:hexArray[8]] integerValue])
                                         + (255 & [[CTHHelper hexToDecimal:hexArray[7]] integerValue])];
                    NSString *steps = [NSString stringWithFormat:@"%ld",256 * (255 & [[CTHHelper hexToDecimal:hexArray[10]] integerValue])
                                       + (255 & [[CTHHelper hexToDecimal:hexArray[9]] integerValue])];
                    NSString *distance = [NSString stringWithFormat:@"%ld",256 * (255 & [[CTHHelper hexToDecimal:hexArray[12]] integerValue])
                                          + (255 & [[CTHHelper hexToDecimal:hexArray[11]] integerValue])];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    if ([kilocalorie floatValue]>0)
                        [dic setValue:@"15" forKey:@"time"];
                    else
                        [dic setValue:@"0" forKey:@"time"];
                    [dic setValue:kilocalorie forKey:@"kilocalorie"];
                    [dic setValue:steps forKey:@"steps"];
                    [dic setValue:distance forKey:@"distance"];
                    [self.dataArray addObject:dic];
                }
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayActivityDetailA) object:nil];
                [self performSelector:@selector(delayActivityDetailA) withObject:nil afterDelay:1.5];
                return TRUE;
            }
            break;
        case BAND_TOTAL_ACTIVITY_A:
            if([hexArray[0] isEqual: @"07"]){
                NSString *strKilocalorie = @"0";
                NSString *strSteps = @"0";
                NSString *strDistance = @"0";
                NSString *time = @"0";
                if (self.dataArray.count ==0) {
                    strSteps = [NSString stringWithFormat:@"%ld",256 * 256 * (255 & [[CTHHelper hexToDecimal:hexArray[6]] integerValue])+ 256 * (255 & [[CTHHelper hexToDecimal:hexArray[7]] integerValue])+ (255 & [[CTHHelper hexToDecimal:hexArray[8]] integerValue])];
                    CGFloat kilocalorie = 256 * 256 * (255 & [[CTHHelper hexToDecimal:hexArray[12]] integerValue])+ 256 * (255 & [[CTHHelper hexToDecimal:hexArray[13]] integerValue])+ (255 & [[CTHHelper hexToDecimal:hexArray[14]] integerValue]);
                    strKilocalorie = [NSString stringWithFormat:@"%f", kilocalorie/100];
                }else{
                    CGFloat distance = (256 * 256* (255 & [[CTHHelper hexToDecimal:hexArray[6]] integerValue]) + 256* (255 & [[CTHHelper hexToDecimal:hexArray[7]] integerValue])+ (255 & [[CTHHelper hexToDecimal:hexArray[8]] integerValue]))*10;
                    strDistance = [NSString stringWithFormat:@"%f",distance/1000];
                    time = [NSString stringWithFormat:@"%ld",256* (255 & [[CTHHelper hexToDecimal:hexArray[9]] integerValue])+ (255 & [[CTHHelper hexToDecimal:hexArray[10]] integerValue])];
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:strKilocalorie forKey:@"kilocalorie"];
                [dic setValue:strSteps forKey:@"steps"];
                [dic setValue:strDistance forKey:@"distance"];
                [self.dataArray addObject:dic];
                if ([self.dataArray count]==2) {
                    CGFloat kilocalorie = 0;
                    CGFloat distance = 0;
                    NSInteger steps = 0;
                    for (NSMutableDictionary *dic in self.dataArray) {
                        kilocalorie = kilocalorie + [[dic valueForKey:@"kilocalorie"] floatValue];
                        distance = distance + [[dic valueForKey:@"distance"] floatValue];
                        steps = steps + [[dic valueForKey:@"steps"] integerValue];
                    }
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:[NSString stringWithFormat:@"%f", kilocalorie] forKey:@"kilocalorie"];
                    [dic setValue:[NSString stringWithFormat:@"%ld", steps] forKey:@"steps"];
                    [dic setValue:[NSString stringWithFormat:@"%f", distance] forKey:@"distance"];
                    [self.response setObject:dic forKey:@"total_activity"];
                    if(self.callbackComplete)
                        self.callbackComplete(self.response);
                }
                return TRUE;
            }else{
                if([hexArray[0] isEqual: @"09"])
                    return TRUE;
            }
            break;
        case BAND_START_REAL_TIME_A:
            if([hexArray[0] isEqual: @"09"]){
                CGFloat kilocalorie = (long)(256 * 256 * (255 & [[CTHHelper hexToDecimal:hexArray[7]] integerValue]))
                + (256 * (255 & [[CTHHelper hexToDecimal:hexArray[8]] integerValue]))
                + (255 & [[CTHHelper hexToDecimal:hexArray[9]] integerValue]);
                NSString *strKilocalorie = [NSString stringWithFormat:@"%f", kilocalorie/100];
                NSString *steps = [NSString stringWithFormat:@"%ld",(long)(256 * (255 & [[CTHHelper hexToDecimal:hexArray[1]] integerValue])
                                                                        + (256 * (255 & [[CTHHelper hexToDecimal:hexArray[2]] integerValue])) + ((255 & [[CTHHelper hexToDecimal:hexArray[3]] integerValue])))];
                CGFloat distance = (long)(256 * 256 * (255 & [[CTHHelper hexToDecimal:hexArray[10]] integerValue]))
                + (256 * (255 & [[CTHHelper hexToDecimal:hexArray[11]] integerValue]))
                + (255 & [[CTHHelper hexToDecimal:hexArray[12]] integerValue]);
                
                NSString *strDistance = [NSString stringWithFormat:@"%f", distance/1000];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:strKilocalorie forKey:@"kilocalorie"];
                [dic setValue:steps forKey:@"steps"];
                [dic setValue:strDistance forKey:@"distance"];
                [self.response setObject:dic forKey:@"start_real_time"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_STOP_REAL_TIME_A:
            if([hexArray[0] isEqual: @"0a"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
    }
    return FALSE;
}
-(void)delayActivityDetailA{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayActivityDetail) object:nil];
    CGFloat kilocalorie = 0;
    CGFloat distance = 0;
    NSInteger steps = 0;
    for (NSMutableDictionary *dic in self.dataArray) {
        kilocalorie = kilocalorie + [[dic valueForKey:@"kilocalorie"] floatValue];
        distance = distance + [[dic valueForKey:@"distance"] floatValue];
        steps = steps + [[dic valueForKey:@"steps"] integerValue];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%f", kilocalorie] forKey:@"kilocalorie"];
    [dic setValue:[NSString stringWithFormat:@"%ld", steps] forKey:@"steps"];
    [dic setValue:[NSString stringWithFormat:@"%f", distance] forKey:@"distance"];
    [self.response setObject:dic forKey:@"activity_detail"];
    if(self.callbackComplete)
        self.callbackComplete(self.response);
}
-(BOOL)wristBandC:(NSArray*)hexArray Characteristic:(CBCharacteristic*)characteristic{
    switch (self.intStatus) {
        case BAND_ENABLE_PASSWORD_C:
            if([hexArray[0] isEqual: @"31"]){
                if(self.callbackComplete){
                    self.callbackComplete(nil);
                    return TRUE;
                }
            }
            break;
        case BAND_GENERATE_NONCE_C:
            if([hexArray[0] isEqual: @"14"]){
                //Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * nonce = [self NSDataToHex:characteristic.value];
                nonce = [nonce stringByReplacingOccurrencesOfString:@" " withString:@""];
                nonce = [[nonce substringFromIndex:2] substringToIndex:32];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:nonce forKey:@"nonce"];
                [self.response setObject:dic forKey:@"nonce"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_ID_DEVICE_C:
            if([hexArray[0] isEqual: @"15"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * strIdDevice = [NSString stringWithFormat:@"%x%x%x%x%x%x%x%x", byte[1], byte[2], byte[3], byte[4], byte[5], byte[6], byte[7], byte[8]];
                /*NSString * strIdDevice = [self NSDataToHex:characteristic.value];
                strIdDevice = [strIdDevice stringByReplacingOccurrencesOfString:@" " withString:@""];
                strIdDevice = [[strIdDevice substringFromIndex:2] substringToIndex:8];*/
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:strIdDevice forKey:@"id_device"];
                [self.response setObject:dic forKey:@"id_device"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_DEVICE_TIME_C:
            if([hexArray[0] isEqual: @"41"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * str = [NSString stringWithFormat:@"%d", byte[8]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:str forKey:@"device_time"];
                [self.response setObject:dic forKey:@"device_time"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_ECDSA_VERIFICATION_C:
            if([hexArray[0] isEqual: @"80"]){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:@"80" forKey:@"band_ecdsa_verification"];
                [self.response setObject:dic forKey:@"band_ecdsa_verification"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_ECDSA_VERIFICATION_C_FORMULA:
            if([hexArray[0] isEqual: @"80"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * str = [NSString stringWithFormat:@"%x", byte[4]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:str forKey:@"band_ecdsa_verification_formula"];
                [self.response setObject:dic forKey:@"band_ecdsa_verification_formula"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_PASSWORD_VERIFICATION_C:
            if([hexArray[0] isEqual: @"30"]){
                if([hexArray[1] isEqual: @"01"]){
                    if(self.callbackComplete){
                        self.callbackComplete(self.response);
                        return TRUE;
                    }
                }
            }
            break;
        case BAND_FIRMWARE_VERSION_C:
            if([hexArray[0] isEqual: @"27"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * strFirmware = [NSString stringWithFormat:@"%x%x%x_%x_20%02x%02x%02x",byte[1],byte[2],byte[3],byte[4],byte[5],byte[6],byte[7]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:strFirmware forKey:@"firmware"];
                [self.response setObject:dic forKey:@"firmware"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_MAC_ADDRESS_C:
            if([hexArray[0] isEqual: @"22"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString * strMacAddress = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",byte[1],byte[2],byte[3],byte[4],byte[5],byte[6]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:strMacAddress forKey:@"mac_address"];
                [self.response setObject:dic forKey:@"mac_address"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_SET_DEVICE_NAME_C:
            if([hexArray[0] isEqual: @"3d"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_CURRENT_TIME_C:
            if([hexArray[0] isEqual: @"01"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_GET_GOAL_C:
            if([hexArray[0] isEqual: @"4b"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSInteger goal = (byte[11]*256+byte[2])*0.1;
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:[NSString stringWithFormat:@"%ld", goal] forKey:@"goal"];
                [self.response setObject:dic forKey:@"goal"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_SET_PERSONAL_INFOR_C:
            if([hexArray[0] isEqual: @"02"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_GET_PERSONAL_INFOR_C:
            if([hexArray[0] isEqual: @"42"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSInteger gender = byte[1];
                NSInteger age = byte[2];
                NSInteger height = byte[3];
                NSInteger weight = byte[4];
                NSInteger stride = byte[5];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:[NSString stringWithFormat:@"%ld", gender] forKey:@"gender"];
                [dic setValue:[NSString stringWithFormat:@"%ld", age] forKey:@"age"];
                [dic setValue:[NSString stringWithFormat:@"%ld", height] forKey:@"height"];
                [dic setValue:[NSString stringWithFormat:@"%ld", weight] forKey:@"weight"];
                [dic setValue:[NSString stringWithFormat:@"%ld", stride] forKey:@"stride"];
                [self.response setObject:dic forKey:@"personal_infor"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_TOTAL_DATA_C:
            if([hexArray[0] isEqual: @"51"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                if(byte[1]==0x99 ){
                    if(self.callbackComplete){
                        self.callbackComplete(self.response);
                        return TRUE;
                    }
                }
                NSInteger tempLength = 22;
                for (NSInteger i = 0 ; i< (characteristic.value.length/tempLength); i++) {
                    NSString * strDate = [NSString stringWithFormat:@"20%02x-%02x-%02x",byte[2+i*tempLength],byte[3+i*tempLength],byte[4+i*tempLength]];
                    NSString * strStep = [NSString stringWithFormat:@"%d",byte[5+i*tempLength]+byte[6+i*tempLength]*256+byte[7+i*tempLength]*256*256+byte[8+i*tempLength]*256*256*256];
                    NSString * strTime = [NSString stringWithFormat:@"%d",byte[9+i*tempLength]+byte[10+i*tempLength]*256+byte[11+i*tempLength]*256*256+byte[12+i*tempLength]*256*256*256];
                    
                    int time = strTime.intValue;
                    
                    NSInteger h = time/3600;
                    NSInteger m = time%3600/60;
                    NSInteger hour = [CTHHelper getHourFromMinute:h*60 + m];
                    
                    NSString * strDistance = [NSString stringWithFormat:@"%.2f",(byte[13+i*tempLength]+byte[14+i*tempLength]*256+byte[15+i*tempLength]*256*256+byte[16+i*tempLength]*256*256*256)*0.01];
                    NSString * strKilocalorie= [NSString stringWithFormat:@"%.2f",(byte[17+i*tempLength]+byte[18+i*tempLength]*256+byte[19+i*tempLength]*256*256+byte[20+i*tempLength]*256*256*256)*0.01];
                    NSString * strGoal = [NSString stringWithFormat:@"%d%%",byte[21+i*tempLength]];
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:strDate,@"band_date",strStep,@"step",[NSString stringWithFormat:@"%ld", hour],@"time",strDistance,@"distance",strKilocalorie,@"kilocalorie",strGoal,@"goal",nil];
                    [self.dataArray addObject:dic];
                }
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayTotalDataC) object:nil];
                [self performSelector:@selector(delayTotalDataC) withObject:nil afterDelay:1.5];
                return TRUE;
            }
            break;
        case BAND_START_REAL_TIME_C:
            if([hexArray[0] isEqual: @"09"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString *steps = [NSString stringWithFormat:@"%d",byte[4]*256*256*256+byte[3]*256*256+byte[2]*256+byte[1]];
                NSString *kilocalorie = [NSString stringWithFormat:@"%.2f",(byte[8]*256*256*256+byte[7]*256*256+byte[6]*256+byte[5])*0.01];
                NSString *distance = [NSString stringWithFormat:@"%.2f",(byte[12]*256*256*256+byte[11]*256*256+byte[10]*256+byte[9])*0.01];
                NSString *heart_rate = [NSString stringWithFormat:@"%d",byte[17]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:steps forKey:@"steps"];
                [dic setValue:kilocalorie forKey:@"kilocalorie"];
                [dic setValue:distance forKey:@"distance"];
                [dic setValue:heart_rate forKey:@"heart_rate"];
                [self.response setObject:dic forKey:@"real_time"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_STOP_REAL_TIME_C:
            if([hexArray[0] isEqual: @"09"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_GET_BASIC_PARAMATER_C:
            if([hexArray[0] isEqual: @"04"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                NSString *distance_unit = [NSString stringWithFormat:@"%d",byte[1]];
                NSString *time_mode = [NSString stringWithFormat:@"%d",byte[2]];
                NSString *taiwan = [NSString stringWithFormat:@"%d",byte[3]];
                NSString *left_right = [NSString stringWithFormat:@"%d",byte[4]];
                NSString *screen_light = [NSString stringWithFormat:@"%d",byte[6]];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:distance_unit forKey:@"distance_unit"];
                [dic setValue:time_mode forKey:@"time_mode"];
                [dic setValue:taiwan forKey:@"taiwan"];
                [dic setValue:left_right forKey:@"left_right"];
                [dic setValue:screen_light forKey:@"screen_light"];
                [self.response setObject:dic forKey:@"basic_paramater"];
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_SET_BASIC_PARAMATER_C:
            if([hexArray[0] isEqual: @"03"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
        case BAND_GET_ACTIVITY_HISTORY_C:
            if([hexArray[0] isEqual: @"52"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                if(byte[1]==0xff){
                    [self getActivityHistoryC];
                    if(self.callbackComplete){
                        self.callbackComplete(self.response);
                        return TRUE;
                    }
                }else{
                    for (NSInteger i = 0; i<(characteristic.value.length/25); i++) {
                        NSString * strDate = [NSString stringWithFormat:@"20%02x-%02x-%02x",byte[3+i*25],byte[4+i*25],byte[5+i*25]];
                        //NSString * strTime = [NSString stringWithFormat:@"%02x:%02x:%02x",byte[6+i*25],byte[7+i*25],byte[8+i*25]];
                        NSInteger h = [[NSString stringWithFormat:@"%02x",byte[6+i*25]] integerValue];
                        NSInteger m = [[NSString stringWithFormat:@"%02x",byte[7+i*25]] integerValue];
                        
                        NSInteger hour = [CTHHelper getHourFromMinute:h*60 + m];
                        
                        NSString * strStep = [NSString stringWithFormat:@"%d",byte[9+i*25]+byte[10+i*25]*256];
                        NSString * strKilocalorie = [NSString stringWithFormat:@"%.2f",(byte[11+i*25]+byte[12+i*25]*256)*0.01];
                        NSString * strDistance = [NSString stringWithFormat:@"%.2f",(byte[13+i*25]+byte[14+i*25]*256)*0.01];
                        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:strDate ,@"band_date",[NSString stringWithFormat:@"%ld", hour] ,@"time", strStep, @"step", strDistance, @"distance", strKilocalorie, @"kilocalorie", nil];
                        [self.dataArray addObject:dic];
                        if(i==((characteristic.value.length/25)-1)){
                            if(byte[i*25+1]==0xff){
                                [self getActivityHistoryC];
                                if(self.callbackComplete){
                                    self.callbackComplete(self.response);
                                    return TRUE;
                                }
                            }
                            else{
                                [CTHBandC getNextActivityHistoryC];
                                return TRUE;
                            }
                        }
                    }
                }
            }
            break;
        case BAND_GET_HEART_RATE_HISTORY_C:
            if([hexArray[0] isEqual: @"54"]){
                Byte *byte = (Byte *)[characteristic.value bytes];
                if(byte[1]==0xff){
                    [self getHeartRateHistoryC];
                    if(self.callbackComplete){
                        self.callbackComplete(self.response);
                        return TRUE;
                    }
                }else{
                    for (int i =0; i< characteristic.value.length/24; i++) {
                        NSString * strDate = [NSString stringWithFormat:@"20%02x-%02x-%02x",byte[3+i*24],byte[4+i*24],byte[5+i*24]];
                        NSString * strTime = [NSString stringWithFormat:@"%02x:%02x",byte[6+i*24],byte[7+i*24]];
                        NSInteger h = [[NSString stringWithFormat:@"%02x",byte[6+i*24]] integerValue];
                        NSInteger m = [[NSString stringWithFormat:@"%02x",byte[7+i*24]] integerValue];
                        
                        NSInteger hour = [CTHHelper getHourFromMinute:h*60 + m];
                        NSString * strHeartRate = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",byte[9+i*24],byte[10+i*24],byte[11+i*24],byte[12+i*24],byte[13+i*24],byte[14+i*24],byte[15+i*24],byte[16+i*24],byte[17+i*24],byte[18+i*24],byte[19+i*24],byte[20+i*24],byte[21+i*24],byte[22+i*24],byte[23+i*24]];
                        NSArray *heartRateArray = [strHeartRate componentsSeparatedByString:@","];
                        NSInteger sum_heart_rate =0;
                        NSInteger count_heart_rate = 0;
                        
                        NSInteger min_heart_rate = 0;
                        NSInteger max_heart_rate = 0;
                        NSInteger init_value = 0;
                        for (NSInteger i=0; i<heartRateArray.count; i++) {
                            if([[heartRateArray objectAtIndex:i] integerValue]>0){
                                sum_heart_rate = sum_heart_rate + [[heartRateArray objectAtIndex:i] integerValue];
                                count_heart_rate = count_heart_rate + 1;
                                
                                if(init_value==0){
                                    init_value = 1;
                                    min_heart_rate = [[heartRateArray objectAtIndex:i] integerValue];
                                    max_heart_rate = [[heartRateArray objectAtIndex:i] integerValue];
                                }else{
                                    if([[heartRateArray objectAtIndex:i] integerValue]<min_heart_rate)
                                        min_heart_rate = [[heartRateArray objectAtIndex:i] integerValue];
                                    if([[heartRateArray objectAtIndex:i] integerValue]>max_heart_rate)
                                        max_heart_rate = [[heartRateArray objectAtIndex:i] integerValue];
                                }
                                
                            }
                        }
                        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:strDate, @"band_date", [NSString stringWithFormat:@"%ld", hour], @"time", [NSString stringWithFormat:@"%ld", sum_heart_rate], @"sum_heart_rate", [NSString stringWithFormat:@"%ld", count_heart_rate], @"count_heart_rate", [NSString stringWithFormat:@"%ld", min_heart_rate], @"min_heart_rate", [NSString stringWithFormat:@"%ld", max_heart_rate], @"max_heart_rate", nil];
                        [self.dataArray addObject:dic];
                    }
                    /*if(characteristic.value.length%24!=0){
                        [self getHeartRateHistoryC];
                        if(self.callbackComplete){
                            self.callbackComplete(self.response);
                            return TRUE;
                        }
                    }*/
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayGetHeartRateHistoryC) object:nil];
                    [self performSelector:@selector(delayGetHeartRateHistoryC) withObject:nil afterDelay:1];
                }
            }
            break;
        case BAND_INSTALL_FIRMWARE_C:
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:characteristic forKey:@"characteristic"];
            [self.response setObject:dic forKey:@"characteristic"];
            if(self.callbackComplete){
                self.callbackComplete(self.response);
                return TRUE;
            }
        }
            break;
        case BAND_MODE_C:
            self.intStatus = BAND_INSTALL_FIRMWARE_C;
            if(self.callbackComplete){
                self.callbackComplete(self.response);
                return TRUE;
            }
            break;
        case BAND_ACTIVE_HEART_RATE_C:
            if([hexArray[0] isEqual: @"19"]){
                if(self.callbackComplete){
                    self.callbackComplete(self.response);
                    return TRUE;
                }
            }
            break;
    }
    return FALSE;
}
-(NSString*) NSDataToHex:(NSData*)data
{
    const unsigned char *dbytes = [data bytes];
    NSMutableString *hexStr =
    [NSMutableString stringWithCapacity:[data length]*2];
    int i;
    for (i = 0; i < [data length]; i++) {
        [hexStr appendFormat:@"%02x ", dbytes[i]];
    }
    return [NSString stringWithString: hexStr];
}
- (NSString *)stringFromHexString:(NSString *)hexString {
    //hexString = @"4578616d706C6521";
    
    // The hex codes should all be two characters.
    if (([hexString length] % 2) != 0)
        return nil;
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSInteger i = 0; i < [hexString length]; i += 2) {
        NSString *hex = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSInteger decimalValue = 0;
        sscanf([hex cStringUsingEncoding:NSASCIIStringEncoding], "%x", &decimalValue);
        [string appendFormat:@"%c", (char)decimalValue];
    }
    return string;
}
-(void)delayGetHeartRateHistoryC{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayGetHeartRateHistoryC) object:nil];
    [self getHeartRateHistoryC];
    if(self.callbackComplete){
        self.callbackComplete(self.response);
    }
}
-(void)delayTotalDataC{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayTotalDataC) object:nil];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    while (self.dataArray.count>0) {
        BOOL flag = FALSE;
        NSInteger i = 0;
        for (; i<tmpArray.count; i++) {
            if([[[tmpArray objectAtIndex:i] valueForKey:@"band_date"] isEqualToString:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]]){
                flag = TRUE;
                break;
            }
        }
        if(flag==FALSE){
            NSInteger interval  = [CTHHelper getTimeStamp:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"], @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", [[self.dataArray objectAtIndex:0] valueForKey:@"time"], @"time", [[self.dataArray objectAtIndex:0] valueForKey:@"step"], @"step", [[self.dataArray objectAtIndex:0] valueForKey:@"distance"], @"distance", [[self.dataArray objectAtIndex:0] valueForKey:@"kilocalorie"], @"kilocalorie", nil];
            [tmpArray addObject:dic];
        }else{
            NSString *strDate = [[tmpArray objectAtIndex:i] valueForKey:@"band_date"];
            NSInteger interval  = [CTHHelper getTimeStamp:strDate];
            NSString *strTime = [[tmpArray objectAtIndex:i] valueForKey:@"time"];
            NSInteger step = [[[tmpArray objectAtIndex:i] valueForKey:@"step"] integerValue];
            step = step + [[[self.dataArray objectAtIndex:0] valueForKey:@"step"] integerValue];
            
            CGFloat distance = [[[tmpArray objectAtIndex:i] valueForKey:@"distance"] floatValue];
            distance = distance + [[[self.dataArray objectAtIndex:0] valueForKey:@"distance"] floatValue];
            
            CGFloat kilocalorie = [[[tmpArray objectAtIndex:i] valueForKey:@"kilocalorie"] floatValue];
            kilocalorie = kilocalorie + [[[self.dataArray objectAtIndex:0] valueForKey:@"kilocalorie"] floatValue];
            
            NSString * strStep = [NSString stringWithFormat:@"%ld", step];
            NSString * strDistance = [NSString stringWithFormat:@"%.2f", distance];
            NSString * strKilocalorie= [NSString stringWithFormat:@"%.2f", kilocalorie];
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys: strDate, @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", strTime, @"time", strStep, @"step", strDistance, @"distance", strKilocalorie, @"kilocalorie", nil];
            [tmpArray replaceObjectAtIndex:i withObject:dic];
        }
        [self.dataArray removeObjectAtIndex:0];
    }
    [self.response setObject:tmpArray forKey:@"total_data"];
    if(self.callbackComplete)
        self.callbackComplete(self.response);
}
-(void)getActivityHistoryC{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    while (self.dataArray.count>0) {
        BOOL flag = FALSE;
        NSInteger i = 0;
        for (; i<tmpArray.count; i++) {
            if([[[tmpArray objectAtIndex:i] valueForKey:@"band_date"] isEqualToString:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]]&&
               [[[tmpArray objectAtIndex:i] valueForKey:@"time"] isEqualToString:[[self.dataArray objectAtIndex:0] valueForKey:@"time"]]){
                flag = TRUE;
                break;
            }
        }
        if(flag==FALSE){
            NSInteger interval  = [CTHHelper getTimeStamp:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"], @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", [[self.dataArray objectAtIndex:0] valueForKey:@"time"], @"time", [[self.dataArray objectAtIndex:0] valueForKey:@"step"], @"step", [[self.dataArray objectAtIndex:0] valueForKey:@"distance"], @"distance", [[self.dataArray objectAtIndex:0] valueForKey:@"kilocalorie"], @"kilocalorie", nil];
            [tmpArray addObject:dic];
        }else{
            NSString *strDate = [[tmpArray objectAtIndex:i] valueForKey:@"band_date"];
            NSInteger interval  = [CTHHelper getTimeStamp:strDate];
            NSString *strTime = [[tmpArray objectAtIndex:i] valueForKey:@"time"];
            NSInteger step = [[[tmpArray objectAtIndex:i] valueForKey:@"step"] integerValue];
            step = step + [[[self.dataArray objectAtIndex:0] valueForKey:@"step"] integerValue];
            
            CGFloat distance = [[[tmpArray objectAtIndex:i] valueForKey:@"distance"] floatValue];
            distance = distance + [[[self.dataArray objectAtIndex:0] valueForKey:@"distance"] floatValue];
            
            CGFloat kilocalorie = [[[tmpArray objectAtIndex:i] valueForKey:@"kilocalorie"] floatValue];
            kilocalorie = kilocalorie + [[[self.dataArray objectAtIndex:0] valueForKey:@"kilocalorie"] floatValue];
            
            NSString * strStep = [NSString stringWithFormat:@"%ld", step];
            NSString * strDistance = [NSString stringWithFormat:@"%.2f", distance];
            NSString * strKilocalorie= [NSString stringWithFormat:@"%.2f", kilocalorie];
            
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys: strDate, @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", strTime, @"time", strStep, @"step", strDistance, @"distance", strKilocalorie, @"kilocalorie", nil];
            [tmpArray replaceObjectAtIndex:i withObject:dic];
        }
        [self.dataArray removeObjectAtIndex:0];
    }
    [self.response setObject:tmpArray forKey:@"activity_history"];
}
-(void)getHeartRateHistoryC{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    while (self.dataArray.count>0) {
        BOOL flag = FALSE;
        NSInteger i = 0;
        for (; i<tmpArray.count; i++) {
            if([[[tmpArray objectAtIndex:i] valueForKey:@"band_date"] isEqualToString:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]]&&
               [[[tmpArray objectAtIndex:i] valueForKey:@"time"] isEqualToString:[[self.dataArray objectAtIndex:0] valueForKey:@"time"]]){
                flag = TRUE;
                break;
            }
        }
        if(flag==FALSE){
            NSInteger interval  = [CTHHelper getTimeStamp:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"]];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self.dataArray objectAtIndex:0] valueForKey:@"band_date"], @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", [[self.dataArray objectAtIndex:0] valueForKey:@"time"], @"time", [[self.dataArray objectAtIndex:0] valueForKey:@"sum_heart_rate"], @"sum_heart_rate", [[self.dataArray objectAtIndex:0] valueForKey:@"count_heart_rate"], @"count_heart_rate", [[self.dataArray objectAtIndex:0] valueForKey:@"min_heart_rate"], @"min_heart_rate", [[self.dataArray objectAtIndex:0] valueForKey:@"max_heart_rate"], @"max_heart_rate", nil];
            [tmpArray addObject:dic];
        }else{
            NSString *strDate = [[tmpArray objectAtIndex:i] valueForKey:@"band_date"];
            NSInteger interval = [CTHHelper getTimeStamp:strDate];
            NSInteger sum_heart_rate = [[[tmpArray objectAtIndex:i] valueForKey:@"sum_heart_rate"] integerValue];
            sum_heart_rate = sum_heart_rate + [[[self.dataArray objectAtIndex:0] valueForKey:@"sum_heart_rate"] integerValue];
            
            NSInteger count_heart_rate = [[[tmpArray objectAtIndex:i] valueForKey:@"count_heart_rate"] integerValue];
            count_heart_rate = count_heart_rate + [[[self.dataArray objectAtIndex:0] valueForKey:@"count_heart_rate"] integerValue];
            
            NSString * strSum_heart_rate = [NSString stringWithFormat:@"%ld", sum_heart_rate];
            NSString * strCount_heart_rate = [NSString stringWithFormat:@"%ld", count_heart_rate];
            
            
            NSInteger min_heart_rate = [[[tmpArray objectAtIndex:i] valueForKey:@"min_heart_rate"] integerValue];
            NSInteger max_heart_rate = [[[tmpArray objectAtIndex:i] valueForKey:@"max_heart_rate"] integerValue];
            NSString * strMin_heart_rate = [NSString stringWithFormat:@"%ld", min_heart_rate];
            NSString * strMax_heart_rate = [NSString stringWithFormat:@"%ld", max_heart_rate];
            
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: strDate, @"band_date", [NSString stringWithFormat:@"%ld", interval], @"date", [[tmpArray objectAtIndex:i] valueForKey:@"time"], @"time", strSum_heart_rate, @"sum_heart_rate", strCount_heart_rate, @"count_heart_rate", strMin_heart_rate, @"min_heart_rate", strMax_heart_rate, @"max_heart_rate",  nil];
            [tmpArray replaceObjectAtIndex:i withObject:dic];
        }
        [self.dataArray removeObjectAtIndex:0];
    }
    for(NSMutableDictionary *dic in tmpArray){
        NSInteger sum_heart_rate = [[dic valueForKey:@"sum_heart_rate"] integerValue];
        NSInteger count_heart_rate = [[dic valueForKey:@"count_heart_rate"] integerValue];
        NSInteger heart_rate = sum_heart_rate/count_heart_rate;
        [dic setValue:[NSString stringWithFormat:@"%ld", heart_rate] forKey:@"heart_rate"];
    }
    [self.response setObject:tmpArray forKey:@"heart_rate_history"];
}
-(NSMutableArray*)getDeviceArray{
    return self.deviceArray;
}
-(NSMutableArray*)getDataArray{
    return self.dataArray;
}
-(void)setCompleteError:(NSInteger)status withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.intStatus = status;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
}
-(void)execute:(uint8_t[])bytes Type:(CBCharacteristicWriteType)characteristicType{
    if (self.cbPeripheral.state!=CBPeripheralStateConnected){
        self.intStatus = BAND_DISCONNECT;
        if(self.callbackError)
        self.callbackError();
        return;
    }
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:bytes length:16];
    [self.cbPeripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
    [self.cbPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:characteristicType];
}
-(void)execute_extend:(uint8_t[])bytes Length:(NSInteger)length Type:(CBCharacteristicWriteType)characteristicType{
    if (self.cbPeripheral.state!=CBPeripheralStateConnected){
        self.intStatus = BAND_DISCONNECT;
        if(self.callbackError)
            self.callbackError();
        return;
    }
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:bytes length:length]; //124, 124
    [self.cbPeripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
    [self.cbPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:characteristicType];
}
-(void)execute_install:(NSMutableData*)data Type:(CBCharacteristicWriteType)characteristicType{
    if (self.cbPeripheral.state!=CBPeripheralStateConnected){
        self.intStatus = BAND_DISCONNECT;
        if(self.callbackError)
            self.callbackError();
        return;
    }
    [self.cbPeripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
    [self.cbPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:characteristicType];
}

@end
