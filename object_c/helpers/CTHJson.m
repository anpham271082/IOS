@implementation CTHJson
+(NSString*)stringFromObject:(id)object{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&err];
    NSString * strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}
+(id)dictionaryWithJSONString:(NSString *)strJson{
	NSData *jsonData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonDic;
}
@end
