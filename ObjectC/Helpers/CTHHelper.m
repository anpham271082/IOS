#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
@implementation CTHHelper
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)playVideoInView:(UIView*)view{
    if (!player){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:VIDEO_MOV ofType:@"mov"];
        player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
        layer = [AVPlayerLayer layer];
        layer.player = player;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        [self performSelector:@selector(waitPlayvideo:) withObject:view afterDelay:0.01];
    }
}
-(void)waitPlayvideo:(UIView*)view{
    if(view){
        [layer setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [layer removeFromSuperlayer];
        [view.layer addSublayer:layer];
        [player play];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
        
        //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        NSError *setCategoryError = nil;
        if (![audioSession setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&setCategoryError]) {
        }
    }
}
-(void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
-(void)closeVideo{
    if(player){
        [player pause];
        [layer removeFromSuperlayer];
        layer = nil;
        player = nil;
    }
}
+(void)removeAllRootViews:(UINavigationController*)navigationController{
    for (UIView *subview in navigationController.view.subviews) {
        if(subview.tag == TAG_VIEW_LOADING){
            [subview removeFromSuperview];
        }
        if(subview.tag == TAG_VIEW_CAMERA){
            [subview removeFromSuperview];
        }
        if(subview.tag == TAG_VIEW_BUILD_AVATAR){
            [subview removeFromSuperview];
        }
        if(subview.tag == TAG_VIEW_DIALOG){
            [subview removeFromSuperview];
        }
    }
}
+(void)removeAllSubviews:(UIView *)view{
    if (!view)
        return;
    while ([[view subviews] count]) {
        [[[view subviews] objectAtIndex:0] removeFromSuperview];
    }
}
+(void)drawTriangle:(UIView *)view{
    for (CALayer *layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    view.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(view.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(0, view.frame.size.height)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1.0].CGColor;
    [view.layer addSublayer:shapeLayer];
}
+(void)animationFade:(UIView*)view FadeIn:(BOOL)fade{
    if(fade){
        view.alpha = 0;
        [self animation:^{
            view.alpha = 1;
        } completion:^{
            view.backgroundColor = [UIColor clearColor];
        }];
    }else{
        view.alpha = 1;
        [CTHHelper animation:^{
           view.alpha = 0;
        }];
    }
}
+(CGRect)resizeLabel:(UILabel *)label{
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    CGSize constraint = CGSizeMake(label.frame.size.width , 3000.0);
    CGSize size;
    if([label.attributedText length]==0)
        return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    NSRange range = NSMakeRange(0, [label.attributedText length]);
    NSDictionary *attributes = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);
}
+(CGFloat)resizeWidthLabel:(UILabel*)label{
    //label.numberOfLines = 1;
    CGSize textSize = [label.text sizeWithAttributes:@{NSFontAttributeName :label.font}];
    return textSize.width+2;
}
+(NSString*)encodeStringToBase64:(NSString*)fromString{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    base64String = [plainData base64EncodedStringWithOptions:kNilOptions];
    return base64String;
}
+(UIImage *)fixrotation:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+(NSString *)identifierForAdvertising{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+(BOOL)checkEmail:(NSString*)strEmail Regex:(NSString*)regex{
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![regExPredicate evaluateWithObject:strEmail]){
        strEmail = nil;
        return FALSE;
    }
    strEmail = nil;
    return TRUE;
}
+(BOOL)checkNumeric:(NSString*)strText{
    for(NSInteger i = 0; i < [strText length]; i++) {
        char c = [strText characterAtIndex:i];
        if ((c >= '0' && c <= '9')) {
            return YES;
        }
    }
    return NO;
}
+(NSString*)strongPassword:(NSString *)strPass MaxLength:(NSInteger)maxLength{
    NSInteger resultLevel = 0;
    if ([strPass length] >= maxLength){
        NSInteger i = 0;
        while (i<[strPass length]){
            NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            NSUInteger matches = [regex numberOfMatchesInString:character options:0 range:NSMakeRange(0, [character length])];
            if (matches > 0){
                if ([character isEqualToString:[character uppercaseString]]) {
                    resultLevel++;
                    break;
                }
            }
            i++;
        }
        i = 0;
        while (i < [strPass length]){
            NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            NSUInteger matches = [regex numberOfMatchesInString:character options:0 range:NSMakeRange(0, [character length])];
            if (matches > 0){
                if ([character isEqualToString:[character lowercaseString]]) {
                    resultLevel++;
                    break;
                }
            }
            i++;
        }
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
        if([strPass rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location != NSNotFound){
            resultLevel++;
        }
        if ([strPass rangeOfCharacterFromSet:set].location != NSNotFound){
            resultLevel++;
        }
    }
    else{
        resultLevel = 1;
    }
    return [NSString stringWithFormat:@"1;%@", [[NSNumber numberWithInteger:resultLevel] stringValue]];
}
+(NSString*)getNumberFormatter:(NSNumber*)value NumberStyle:(NSNumberFormatterStyle)numberStyle{
    NSNumberFormatter *formatterCurrency = [[NSNumberFormatter alloc] init];
    formatterCurrency.numberStyle = numberStyle;
    [formatterCurrency setMaximumFractionDigits:DECIMAL_DIGIT];
    if(CFNumberIsFloatType((CFNumberRef)value))
        return [NSString stringWithFormat:@"%@",[formatterCurrency stringFromNumber:@([value floatValue])]];
    else
        return [NSString stringWithFormat:@"%@",[formatterCurrency stringFromNumber:@([value integerValue])]];
}
+(NSString *)hexToDecimal:(NSString*)str{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    unsigned int outVal;
    [scanner scanHexInt:&outVal];
    return [NSString stringWithFormat:@"%d", outVal];
}
+(NSArray *)hexInArray:(NSData*)data{
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    NSUInteger nbBytes = [data length];
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < nbBytes; i++){
        NSString *hex = [NSString stringWithFormat:@"%02x", bytes[i]];
        [array addObject:hex];
    }
    return array;
}
-(NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}
+(UIColor *)colorFromHexString:(UIColor *)defaultColor HexString:(NSString *)hexString{
    if (!hexString || [hexString isEqualToString:@""]) {
        return defaultColor;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
+(BOOL)checkDate:(NSString *)strDate{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"] ;
    NSDate *date = [dateFormatter dateFromString:strDate];
    if(date)
        return TRUE;
    return FALSE;
}
+(NSInteger)getAge:(NSString *)strDate MaxAge:(NSInteger)maxAge MinAge:(NSInteger)minAge{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocaleIdentifier]];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [df dateFromString:strDate];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [dateComponentsNow year] - [dateComponentsBirth year];
    if(year==maxAge){
        if([dateComponentsNow month]>=[dateComponentsBirth month]){
            if([dateComponentsNow month]>[dateComponentsBirth month]){
                year = year + 1;
            }else if([dateComponentsNow day] >= [dateComponentsBirth day]){
                year = year + 1;
            }
        }
    }else if(year==minAge){
        if([dateComponentsBirth month]>[dateComponentsNow month]){
            year = year - 1;
        }else if([dateComponentsBirth day] > [dateComponentsNow day]){
            year = year - 1;
        }
    }
    return year;
}
+(NSString*)sha256:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++){
        [ret appendFormat:@"%02x",result[i]];
    }
    input = nil;
    return ret;
}
+(BOOL)checkUpperCase:(NSString *)strPass{
    NSInteger i = 0;
    while (i<[strPass length]){
        NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[A-Z]" options:0 error:NULL];
        NSUInteger matches = [regex numberOfMatchesInString:character options:0 range:NSMakeRange(0, [character length])];
        if (matches > 0){
            if ([character isEqualToString:[character uppercaseString]])
                return true;
        }
        i++;
    }
    return false;
}
+(BOOL)checkLowerCase:(NSString *)strPass{
    NSInteger i = 0;
    while (i<[strPass length]){
        NSString* character = [strPass substringWithRange:NSMakeRange(i, 1)];
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[a-z]" options:0 error:NULL];
        NSUInteger matches = [regex numberOfMatchesInString:character options:0 range:NSMakeRange(0, [character length])];
        if (matches > 0){
            if ([character isEqualToString:[character lowercaseString]])
                return true;
        }
        i++;
    }
    return false;
}
+(BOOL)checkSpecialChars:(NSString *)strPass{
    NSString *specialCharacterString = @"!~@#$%^&*-+();:={}[]<>?\\/";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString];
    if ([strPass.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        return YES;
    }
    return NO;
}
+(void)log:(NSString *)strText{
}
+(void)animationTextFieldDidBeginEditing:(CTHLabel*)label{
    [self animation:^{
        label.frame = CGRectMake(0, 0, label.frame.size.width, 20);
        label.fontStyleLabel = 1;
        [label setFontSize:12];
        [label changeFont];
        label.textColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:CTHUserDefined.GREEN_COLOR];
    }];
}
+(void)animationTextFieldDidEndEditing:(CTHLabel*)label TextField:(UITextField*)textField{
    [self animation:^{
        label.frame = textField.frame;
        label.fontStyleLabel = 2;
        [label setFontSize:17];
        [label changeFont];
        label.textColor = [CTHHelper colorFromHexString:[UIColor blackColor] HexString:CTHUserDefined.GRAY_COLOR];
    }];
}
+(BOOL)checkDayInMonth:(NSString*)year Month:(NSString*)month Day:(NSInteger)day{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [df dateFromString: [NSString stringWithFormat:@"%@-%@-01", year, month]];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days;
#if defined(__IPHONE_8_0) || defined(__MAC_10_10)
    days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate];
#else
    days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:myDate];
#endif
    if(day<=days.length)
        return true;
    return false;
}
+(BOOL)dictionary:(NSMutableDictionary*)dic Key:(NSString*)key{
    const id nul = [NSNull null];
    const id object = [dic objectForKey: key];
    if (object == nul)
        return false;
    if([dic objectForKey: key])
        return true;
    return false;
}
+(UIControl*)controlFromNib:(NSString*)nibName RestorationIdentifier:(NSString*)restorationIdentifier{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:[CTHPlatform storyBoardNameOfDevice:nibName] owner:nil options:nil];
    for (UIControl *control in nibViews) {
        if ([control.restorationIdentifier isEqualToString:restorationIdentifier]) {
            return control;
        }
    }
    return nil;
}
+(UIControl*)controlFromTag:(NSInteger)tag withView:(UIView*)view kind:(Class)aClass{
    for (UIControl *subview in view.subviews) {
        if(subview.tag == tag && [subview isKindOfClass:aClass])
            return subview;
    }
    return nil;
}
+(NSString*)getDateFromInterval:(double)created_at{
    NSTimeInterval interval  = created_at;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval] ;
    [dateFormatter setDateFormat:@"yyyy/MM/dd"] ;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    NSString *year = [NSString stringWithFormat:@"%ld", dateComponents.year];
    year = [year substringFromIndex:2];
    switch (dateComponents.month) {
        case 1:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"jan" Text:@"JAN"], year];
            break;
        case 2:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"feb" Text:@"FEB"], year];
            break;
        case 3:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"mar" Text:@"MAR"], year];
            break;
        case 4:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"apr" Text:@"APR"], year];
            break;
        case 5:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"may5" Text:@"MAY"], year];
            break;
        case 6:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"jun" Text:@"JUN"], year];
            break;
        case 7:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"jul" Text:@"JUL"], year];
            break;
        case 8:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"aug" Text:@"AUG"], year];
            break;
        case 9:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"sep" Text:@"SEP"], year];
            break;
        case 10:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"oct" Text:@"OCT"], year];
            break;
        case 11:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"nov" Text:@"NOV"], year];
            break;
        case 12:
            year = [NSString stringWithFormat:@" %ld %@ '%@ ", dateComponents.day, [CTHLanguage language:@"dec" Text:@"DEC"], year];
            break;
        default:
            break;
    }
    return year;
}
+(NSString*)getDateFromIntervalDDMMYY:(double)created_at{
    NSTimeInterval interval  = created_at;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval] ;
    [dateFormatter setDateFormat:@"yy/MM/dd"] ;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    NSString *year = [NSString stringWithFormat:@"%ld", dateComponents.year];
    year = [year substringFromIndex:2];
		NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%@",(long)dateComponents.day, (long)dateComponents.month, year];
    return strDate;
}
+(NSString*)getDateFromIntervalDay:(NSString*)created_at{
    NSArray *dateArray = [created_at componentsSeparatedByString:@"-"];
		NSString *strDate = [NSString stringWithFormat:@"%02ld", (long)[[dateArray objectAtIndex:2] integerValue]];
    return strDate;
}
+(NSString*)getDateFromIntervalMonth:(NSString*)created_at{
    NSArray *dateArray = [created_at componentsSeparatedByString:@"-"];
		NSString *strDate = [NSString stringWithFormat:@"%@ %ld", [CTHLanguage language:@"month" Text:@"Month"], (long)[[dateArray objectAtIndex:1] integerValue]];
    return strDate;
}
+(void)animation:(void(^)(void))blockAction{
    [UIView animateWithDuration:TIME_ANIMATION animations:^{
        blockAction();
    }];
}
+(void)animation:(void(^)(void))blockAction plusTime:(CGFloat)time{
    [UIView animateWithDuration:TIME_ANIMATION+time animations:^{
        blockAction();
    }];
}
+(void)animation:(void(^)(void))blockAction plusTime:(CGFloat)time completion:(void(^)(void))blockCompletion{
    [UIView animateWithDuration:TIME_ANIMATION+time animations:^{
        blockAction();
    } completion:^(BOOL finished) {
        blockCompletion();
    }];
}
+(void)animation:(void(^)(void))blockAction completion:(void(^)(void))blockCompletion{
    [UIView animateWithDuration:TIME_ANIMATION animations:^{
        blockAction();
    } completion:^(BOOL finished) {
        blockCompletion();
    }];
}
+(void)animationWithVelocity:(void(^)(void))blockAction completion:(void(^)(void))blockCompletion{
    [UIView animateWithDuration:TIME_ANIMATION+0.2 delay:TIME_ANIMATION usingSpringWithDamping:TIME_ANIMATION+0.2 initialSpringVelocity:TIME_ANIMATION-0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        blockAction();
    } completion:^(BOOL finished){
        blockCompletion();
    }];
}
+(void)drawText:(CGPoint)point FontStyle:(NSInteger)fontStyle FontSize:(CGFloat)fontSize Width:(CGFloat)width Height:(CGFloat)height Alignment:(NSTextAlignment)alignment Text:(NSString*)strText Color:(UIColor*)color{
    UIFont *myFont= [UIFont fontWithName:[CTHFont fontName:fontStyle] size:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = alignment;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:myFont forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    CGRect rectText = CGRectMake(point.x, point.y, width, height);
    [strText  drawInRect:rectText withAttributes:attributes];
}
+(NSInteger)getHourFromMinute:(NSInteger)minute{
    if(minute>=90 && minute<=270)
        return 3;
    else if(minute>=270 && minute<=450)
        return 6;
    else if(minute>=450 && minute<=630)
        return 9;
    else if(minute>=630 && minute<=810)
        return 12;
    else if(minute>=810 && minute<=990)
        return 15;
    else if(minute>=990 && minute<=1170)
        return 18;
    else if(minute>=1170 && minute<=1350)
        return 21;
    else
        return 24;
}
+(NSInteger)getTimeStamp:(NSString*)strDate{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"] ;
    NSDate *date = [dateFormatter dateFromString:strDate];
    return [date timeIntervalSince1970];
}
+(BOOL)FBSDKApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions{
    return true;//[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}
+(void)addSubview:(UIView*)parent withChildView:(UIView*)child withRect:(CGRect)rect{
    child.frame = rect;
    [parent addSubview:child];
}
+(double)DegreesToRadians:(double)angle{
    return (angle)/180.0 * M_PI;
}
@end
