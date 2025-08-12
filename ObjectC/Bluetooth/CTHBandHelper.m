#import "CTHBandHelper.h"
@implementation CTHBandHelper
+(NSMutableData*)hexFromNonce:(NSString*)strNonce{
    uint8_t *bytes = (uint8_t *)malloc(sizeof(uint8_t) * ([strNonce length] / 2));
    for(int i = 0; i < [strNonce length]; i += 2) {
        NSRange range = { i, 2 };
        NSString *subString = [strNonce substringWithRange:range];
        unsigned value;
        [[NSScanner scannerWithString:subString] scanHexInt:&value];
        bytes[i / 2] = (uint8_t)value;
    }
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:bytes length:[strNonce length] / 2];
    return data;
}
@end
