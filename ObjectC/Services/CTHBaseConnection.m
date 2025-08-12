#import "CTHBaseConnection.h"
#import "CTHBaseApi.h"
@implementation CTHBaseConnection
-(void)cancel {
    if(dataTask){
        [dataTask cancel];
        [defaultSession finishTasksAndInvalidate];
        defaultSession = nil;
        dataTask = nil;
    }
    self.isRequesting = NO;
    if(responseData){
        [responseData setData:[NSData dataWithBytes:NULL length:0]];
        [responseData setLength:0];
        responseData = nil;
    }
    if(self.response){
        self.response = nil;
    }
}
-(void)connectToServer:(NSString*)method UrlRequest:(NSString*)urlRequest Header:(NSDictionary*)header Body:(NSDictionary*)body ShowLoading:(BOOL)showLoading LocalDatabase:(BOOL)localDatabase WithLocalDatabase:(void(^) (NSMutableDictionary* response, NSInteger status))callLocalDatabase WithComplete:(void(^) (NSMutableDictionary* response, NSInteger status))callComplete WithError:(void(^)(void))callError{
    strMethod = method;
    strUrlRequest = urlRequest;
    dicHeader = header;
    dicBody = body;
    boolLocalDatabase = localDatabase;
    self.callbackLocalDatabase = callLocalDatabase;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    self.isShowLoading = showLoading;
    self.localParam = [self.localParam stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
    self.localParam = [self.localParam stringByReplacingOccurrencesOfString:@"=" withString:@"__"];
    [self actionConnect];
}
-(void)actionConnect{
    [self cancel];
    self.isRequesting = YES;
    if (boolLocalDatabase == TRUE)
        [self localDatabase];
    else
        [self connection];
}
-(void)localDatabase{
    if(!self.response)
        self.response = [[NSMutableDictionary alloc] init];
    if (self.localTable.length>0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block NSString *strQuery;
            __block NSString *strEncodeResponse;
            if(self.localParam.length>0){
                strQuery = [NSString stringWithFormat:@"SELECT response FROM %@ WHERE param = '%@'",self.localTable, self.localParam];
            }else{
                strQuery = [NSString stringWithFormat:@"SELECT response FROM %@", self.localTable];
            }
            strEncodeResponse = [CTHSqlite getResponseData:strQuery DBName:@"milo.db"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.response = [CTHJson dictionaryWithJSONString:strEncodeResponse];
                if(self.isRequesting == YES && self.response!=nil){
                    self.isShowLoading = NO;
                    [[CTHDialog sharedInstance] hideLoading];
                    self.callbackLocalDatabase(self.response, STATUS_SUCCESS);
                }
                [self connection];
            });
        });
    }
}
-(void)failConnection{
    if(dataTask){
        self.isRequesting = YES;
        self.callbackError();
        [CTHCache destroyNetworkCache];
        [CTHCache destroyLackingDataProtection];
    }
    if (self.isShowLoading) {
        self.isShowLoading = NO;
        [[CTHDialog sharedInstance] hideLoading];
    }
}
-(void)parseString:(NSString*)responseString{
    NSLog(@"responseString %@", responseString);
    NSDictionary *dic = [CTHJson dictionaryWithJSONString:responseString];
    self.isRequesting = NO;
    if(!self.response)
        self.response = [[NSMutableDictionary alloc] init];
    self.response = [NSMutableDictionary dictionaryWithDictionary: dic];
    checkNull = false;
    [self checkDictionaryIsNull];
    /*if(checkNull == true){
     self.callbackError();
     if (self.isShowLoading) {
     self.isShowLoading = NO;
     [[CTHDialog sharedInstance] hideLoading];
     }
     return;
     }*/
    if (self.localTable.length>0) {
        NSString *strEncodeResponse =responseString;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(self.localParam.length>0){
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE param = '%@'", self.localTable, self.localParam];
                if (![CTHSqlite isExistQueryData:strQuery DBName:@"milo.db"]) {
                    [CTHSqlite insert:self.localTable Data:[NSDictionary dictionaryWithObjectsAndKeys:self.localParam, @"param", strEncodeResponse, @"response",nil] Fields:@"param,response" DBName:@"milo.db"];
                }else{
                    [CTHSqlite updateParam:self.localTable Data:[NSDictionary dictionaryWithObjectsAndKeys:self.localParam, @"param", strEncodeResponse, @"response",nil] DBName:@"milo.db"];
                }
                strQuery = nil;
            }else{
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@", self.localTable];
                if (![CTHSqlite isExistQueryData:strQuery DBName:@"milo.db"]) {
                    [CTHSqlite insert:self.localTable Data:[NSDictionary dictionaryWithObjectsAndKeys:strEncodeResponse, @"response",nil] Fields:@"response" DBName:@"milo.db"];
                }else{
                    [CTHSqlite update:self.localTable Data:[NSDictionary dictionaryWithObjectsAndKeys:strEncodeResponse, @"response", nil] DBName:@"milo.db"];
                }
            }
        });
    }
    
    if ([[self.response valueForKey:@"status"] integerValue] == STATUS_EXPIRED_TOKEN){
    
        return;
    }
    
    if (self.isShowLoading) {
        self.isShowLoading = NO;
        [[CTHDialog sharedInstance] hideLoading];
    }
    self.callbackComplete(self.response, STATUS_SUCCESS);
    
    /*if ([[self.response valueForKey:@"status"] integerValue] == STATUS_SUCCESS){
        if (self.isShowLoading) {
            self.isShowLoading = NO;
            [[CTHDialog sharedInstance] hideLoading];
        }
        self.callbackComplete(self.response, STATUS_SUCCESS);
    }else if ([[self.response valueForKey:@"status"] integerValue] == STATUS_NO_SUCCESS){
        self.callbackError();
    }else{
        self.callbackError();
        if (self.isShowLoading) {
            self.isShowLoading = NO;
            [[CTHDialog sharedInstance] hideLoading];
        }
    }*/
    [CTHCache destroyNetworkCache];
    [CTHCache destroyLackingDataProtection];
    responseString = nil;
    //self.response = nil;
    //dic = nil;
}
- (NSDictionary*)checkDictionaryIsNull {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self.response];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (NSString *key in [self.response allKeys]) {
        const id object = [self.response objectForKey: key];
        if (object == nul) {
            checkNull = true;
            [replaced setObject: blank forKey: key];
        } else if([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self replaceNull:object] forKey: key];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [self replaceNullArray:object] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}
- (NSArray *)replaceNullArray:(NSArray *)array {
    const id nul = [NSNull null];
    const NSString *blank = @"";
    NSMutableArray *replaced = [NSMutableArray arrayWithArray:array];
    for (NSInteger i=0; i < [array count]; i++) {
        const id object = [array objectAtIndex:i];
        if (object == nul) {
            checkNull = true;
            [replaced replaceObjectAtIndex:i withObject:blank];
        } else if([object isKindOfClass: [NSDictionary class]]) {
            [replaced replaceObjectAtIndex:i withObject:[self replaceNull:object]];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced replaceObjectAtIndex:i withObject:[self replaceNullArray:object]];
        }
    }
    return replaced;
}
- (NSDictionary *)replaceNull:(NSDictionary *)dict {
    const id nul = [NSNull null];
    const NSString *blank = @"";
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dict];
    for (NSString *key in [dict allKeys]) {
        const id object = [dict objectForKey: key];
        if (object == nul) {
            checkNull = true;
            [replaced setObject: blank forKey: key];
        } else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self replaceNull:object] forKey: key];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [self replaceNullArray:object] forKey: key];
        }
    }
    return replaced;
}
@end
