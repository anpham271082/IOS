#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface CTHBaseBand : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);
@property (copy, nonatomic) void (^ callbackDone)(NSMutableDictionary *response);
@property (nonatomic,readwrite) NSInteger intStatus;
@property (assign) NSInteger intStatePowered;
@property (strong, nonatomic) CBCentralManager *cbCentralManager;
@property (strong, nonatomic) CBPeripheral *cbPeripheral;
@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBUUID *txUUID;
@property (strong, nonatomic) CBUUID *rxUUID;
@property (strong, nonatomic) CBService *service;
@property (strong, nonatomic) CBCharacteristic *txCharacteristic;
@property (strong, nonatomic) CBCharacteristic *rxCharacteristic;
@property (strong, nonatomic) NSMutableDictionary *response;
@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign) CGFloat goal;
@property (copy) NSString *service_UUID;
@property (copy) NSString *kCBAdvDataServiceUUID;

-(void)sum:(uint8_t[])bytes;
-(void)notification:(NSInteger)serviceUUID characteristicUUID:(NSInteger)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on;
-(void)didUpdateValueForCharacteristic:(NSData*)data;
-(void)changeZeroName:(unsigned char*)buf;

+(id)sharedInstance;
-(void)disconnect:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(void)getStatePowered:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;

-(void)getBandDevices:(void(^)(NSMutableDictionary* response))callComplete withDone:(void(^)(NSMutableDictionary* response))callDone withError:(void(^)(void))callError;

-(void)connectBand:(CBPeripheral*)peripheral ServiceUUID:(NSString*)serviceUUID withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(NSMutableArray*)getDeviceArray;
-(NSMutableArray*)getDataArray;
-(void)setCompleteError:(NSInteger)status withComplete:(void(^)(NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(void)execute:(uint8_t[])bytes Type:(CBCharacteristicWriteType)characteristicType;
-(void)execute_extend:(uint8_t[])bytes Length:(NSInteger)length Type:(CBCharacteristicWriteType)characteristicType;
-(void)execute_install:(NSMutableData*)data Type:(CBCharacteristicWriteType)characteristicType;
-(CBPeripheral*)getPeripheral;
-(NSString*)setkCBAdvDataServiceUUID:(NSString*)serviceUUID;
-(NSString*)getUUIDString;
-(BOOL)checkConnectBand;
-(void)stopScanBand;
-(CBPeripheral*)retrievePeripheral:(NSString *)uuidString;
@end
