#import <Foundation/Foundation.h>
@interface CTHBaseConnection : NSObject{
    NSMutableData *responseData;
    NSURLSessionDataTask * dataTask;
    NSURLSession *defaultSession;
    
    NSString *strMethod;
    NSString *strUrlRequest;
    NSDictionary *dicHeader;
    NSDictionary *dicBody;
    BOOL boolLocalDatabase;
    BOOL checkNull;
}
@property (strong, nonatomic) NSMutableDictionary *response;
@property (copy) NSString *localTable;
@property (copy) NSString *localParam;
@property (assign) BOOL isRequesting;
@property (assign) BOOL isShowLoading;
@property (copy, nonatomic) void (^ callbackLocalDatabase)(NSMutableDictionary *response, NSInteger status);
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response, NSInteger status);
@property (copy, nonatomic) void (^ callbackError)(void);

-(NSDictionary*)checkDictionaryIsNull;
-(NSArray *)replaceNullArray:(NSArray *)array;
-(NSDictionary *)replaceNull:(NSDictionary *)dict;

-(void)connectToServer:(NSString*)method UrlRequest:(NSString*)urlRequest Header:(NSDictionary*)header Body:(NSDictionary*)body ShowLoading:(BOOL)showLoading LocalDatabase:(BOOL)localDatabase WithLocalDatabase:(void(^) (NSMutableDictionary* response, NSInteger status))callLocalDatabase WithComplete:(void(^) (NSMutableDictionary* response, NSInteger status))callComplete WithError:(void(^)(void))callError;

-(void)cancel;
-(void)connection;
-(void)failConnection;
-(void)parseString:(NSString*)responseString;
@end
