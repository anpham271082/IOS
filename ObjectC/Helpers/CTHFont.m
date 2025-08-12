@implementation CTHFont
+(NSString*)fontName:(NSInteger)fontStyle{
    switch (fontStyle) {
        case 0:
            return @"FrutigerUltraBlack";
            break;
        case 1:
            return @"FrutigerBlack";
            break;
        case 2:
            return @"FrutigerBold-Bold";
            break;
        case 3:
            return @"FrutigerLight";
            break;
        case 4:
            return @"FrutigerRegular";
            break;
        default:
            break;
    }
    return @"FrutigerBlack";
}
@end
