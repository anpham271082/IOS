@implementation CTHLanguage
+(NSString *)language:(NSString*)key{
    return [CTHLanguage language:key Text:@""];
}
+(NSString *)language:(NSString*)key Text:(NSString*)text{
    NSString *strLibraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [strLibraryDirectory stringByAppendingString:@"/language.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString * strJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [CTHJson dictionaryWithJSONString:strJson];
    key = key.lowercaseString;
    if([dic valueForKey:key]){
        text = [dic valueForKey:key];
    }
    dic = nil;
		strJson = nil;
    data = nil;
    return text;
}
@end
