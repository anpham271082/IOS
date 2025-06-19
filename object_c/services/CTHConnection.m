#import "CTHBaseApi.h"
@implementation CTHConnection
-(id)init {
    if (self = [super init]) {
        self.localTable = @"";
        self.localParam = @"";
    }
    return self;
}
-(void)connection{
    if(self.isShowLoading){
        [[CTHDialog sharedInstance] showLoading];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrlRequest] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:strMethod];
    /*NSString *strAuth = [NSString stringWithFormat:@"%@:%@", USERNAME, PASSWORD];
    NSData *authData = [strAuth dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];*/
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
   
    if(dicHeader!=nil){
        for (NSString* key in dicHeader){
            [request setValue:[dicHeader valueForKey:key] forHTTPHeaderField:key];
        }
    }
    if (dicBody!=nil) {
        NSString * json_data = [CTHJson stringFromObject:dicBody];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[json_data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[json_data dataUsingEncoding:NSUTF8StringEncoding]];
        json_data = nil;
    }
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 40;
    defaultConfigObject.timeoutIntervalForResource = 65;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    dataTask = [defaultSession dataTaskWithRequest:request];
    [dataTask resume];
    if(dicHeader!=nil){
        for (NSString* key in dicHeader){
            [request setValue:@"" forHTTPHeaderField:key];
        }
    }
    dicHeader = nil;
    dicBody = nil;
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
    if(!responseData){
        responseData = [[NSMutableData alloc] init];
    }
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    if(!responseData){
        responseData = [[NSMutableData alloc] init];
    }
    [responseData appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error == nil && responseData){
        if(dataTask){
            if([strUrlRequest containsString:@"accounts.verifyEmail"]){
                self.callbackComplete(self.response, STATUS_NO_SUCCESS);
                if (self.isShowLoading) {
                    self.isShowLoading = NO;
                    [[CTHDialog sharedInstance] hideLoading];
                }
                return;
            }
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *response = [CTHJson dictionaryWithJSONString:responseString];
            NSMutableDictionary *dic;
            
            if(response){
                dic = [[NSMutableDictionary alloc] init];
                for (NSString* key in response){
                    [dic setValue:[response valueForKey:key] forKey:key];
                }
            }
            if(dic){
                if([[dic valueForKey:@"status"] integerValue] == -200){
                    self.callbackError();
                    if (self.isShowLoading) {
                        self.isShowLoading = NO;
                        [[CTHDialog sharedInstance] hideLoading];
                    }
                    return;
                }
            
               // NSString *decode = [dic valueForKey:@"data"];
               // [dic setValue:[CTHJson dictionaryWithJSONString:decode] forKey:@"data"];
                [self parseString:[CTHJson stringFromObject:dic]];
            }else{
                [self failConnection];
            }
            responseString = nil;
            dic = nil;
        }
    }else{
        if(dataTask){
            if(error.code==-1009||error.code==-1001||error.code==-1003){
                [[CTHDialog sharedInstance] showDialogOk:nil Title:[CTHLanguage language:@"internet error" Text:@"INTERNET ERROR"] Message:[CTHLanguage language:@"oops! we were not able to connect to the internet" Text:@"Oops! We were not able to connect to MILO Server or something's wrong with the Internet…"] TextOk:[CTHLanguage language:@"ok" Text:@"OK"]];
                [self failConnection];
            }
        }
    }
}
@end
