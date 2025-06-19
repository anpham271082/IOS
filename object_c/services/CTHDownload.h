#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CTHDownload : NSObject<NSURLSessionDelegate>
@property (copy) NSString *strUrlRequest;
@property (copy) NSString *strMethod;
@property (copy) NSString *type;
@property (assign) BOOL isRequesting;
@property (assign) int64_t total_bytes_expected_to_write;
@property (copy, nonatomic) void (^ callbackProgress)(CGFloat progress);
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);
-(void)postDataToServer:(NSDictionary*)dic withProgress:(void(^) (CGFloat progress))callProgress withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(void)cancel;
@end
