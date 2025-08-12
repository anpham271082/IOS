#import "SSZipArchive.h"
@interface CTHDownload(){
@private
    NSURLSessionDownloadTask *download;
    NSURLSession *defaultSession;
}
@end
@implementation CTHDownload
-(id)init {
    if (self = [super init]) {
        self.strMethod = @"GET";
        self.type = @"";
    }
    return self;
}
-(void)postDataToServer:(NSDictionary*)dic withProgress:(void(^) (CGFloat progress))callProgress withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.callbackProgress = callProgress;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    [self cancel];
    self.isRequesting = YES;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strUrlRequest] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:self.strMethod];
    NSString *strAuth = [NSString stringWithFormat:@"%@:%@", USERNAME, PASSWORD];
    NSData *authData = [strAuth dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
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
    if (dic!=nil) {
        NSString * json_data = [CTHJson stringFromObject:dic];
        json_data = [NSString stringWithFormat:@"json_data=%@", json_data];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[json_data length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[json_data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    download = [defaultSession downloadTaskWithRequest:request];
    [download resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    __block int64_t _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
    if(_totalBytesExpectedToWrite==-1)
        _totalBytesExpectedToWrite = self.total_bytes_expected_to_write;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callbackProgress((double)totalBytesWritten/(double)_totalBytesExpectedToWrite);
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *strLibraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *strDocumentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSError *error;
    if([self.type isEqualToString:@"asset_3d_url"]){
        NSURL *destinationURL = [NSURL fileURLWithPath:[strDocumentDirectory stringByAppendingPathComponent:@"ModelTexture.zip"]];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:nil];
        [SSZipArchive unzipFileAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"ModelTexture.zip"] toDestination:strDocumentDirectory];
        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/ModelTexture"] error:&error];
        for(NSString *file in files) {
            NSString *modelTexture = [strDocumentDirectory stringByAppendingPathComponent:@"/ModelTexture/"];
            NSString *path = [modelTexture stringByAppendingPathComponent:file];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
            [data writeToFile:[NSString stringWithFormat:@"%@/%@", strLibraryDirectory, file] options:NSDataWritingFileProtectionComplete error:&error];
        }
        [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"ModelTexture.zip"] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"ModelTexture"] error:NULL];
    }else if([self.type isEqualToString:@"ios_language"]){
        NSURL *destinationURL = [NSURL fileURLWithPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.zip"]];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.zip"]]){
            [SSZipArchive unzipFileAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.zip"] toDestination:strDocumentDirectory];
            [[NSFileManager defaultManager] moveItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language"] toPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.json"] error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:[strLibraryDirectory stringByAppendingPathComponent:@"/language.json"]  error:NULL];
            
            NSData* data = [NSData dataWithContentsOfFile:[strDocumentDirectory stringByAppendingPathComponent:@"/language.json"]];
            [data writeToFile:[strLibraryDirectory stringByAppendingPathComponent:@"/language.json"] options:NSDataWritingFileProtectionComplete error:&error];
            
            [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.zip"]  error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/language.json"]  error:NULL];
        }
    }else if([self.type isEqualToString:@"android_language"]){
        NSURL *destinationURL = [NSURL fileURLWithPath:[strDocumentDirectory stringByAppendingPathComponent:@"/lang.zip"]];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/lang.zip"]]){
            [SSZipArchive unzipFileAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/lang.zip"] toDestination:strDocumentDirectory];
            [[NSFileManager defaultManager] removeItemAtPath:[strLibraryDirectory stringByAppendingPathComponent:@"/lang-au-android.json"]  error:NULL];
            
            NSData* data = [NSData dataWithContentsOfFile:[strDocumentDirectory stringByAppendingPathComponent:@"/lang-au-android.json"]];
            [data writeToFile:[strLibraryDirectory stringByAppendingPathComponent:@"/lang-au-android.json"] options:NSDataWritingFileProtectionComplete error:&error];
            
            [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/lang.zip"]  error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:[strDocumentDirectory stringByAppendingPathComponent:@"/lang-au-android.json"]  error:NULL];
        }
    }
    self.callbackComplete(nil);
    [CTHCache destroyNetworkCache];
    [CTHCache destroyLackingDataProtection];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(error!=nil){
        if(error.code==-1009||error.code==-1001||error.code==-1003){
            if(download){
                self.isRequesting = NO;
                self.callbackError();
                [CTHCache destroyNetworkCache];
                [CTHCache destroyLackingDataProtection];
            }
        }
    }
}
-(void)cancel {
    if(download){
        [download cancel];
        [defaultSession finishTasksAndInvalidate];
        defaultSession = nil;
        download = nil;
    }
    self.isRequesting = NO;
}
@end
