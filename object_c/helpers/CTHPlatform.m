#include <sys/sysctl.h>
@implementation CTHPlatform
+(BOOL)is_iPad{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPad"].location != NSNotFound;
}
+(BOOL)is_Pad{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+(BOOL)is_Phone{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}
+(BOOL)is_iPad1{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPad1"].location != NSNotFound;
}
+(BOOL)is_iPad2{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPad2"].location != NSNotFound;
}
+(BOOL)is_iPad3{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPad3"].location != NSNotFound;
}
+(BOOL)is_iPhone4{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPhone3"].location != NSNotFound;
}
+(BOOL)is_iPhone4S{
    NSString *platform = [CTHPlatform platform];
    return [platform rangeOfString:@"iPhone4"].location != NSNotFound;
}
+(BOOL)isUseApp{
    NSString *platform = [CTHPlatform platform];
    if([platform rangeOfString:@"iPad1"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPad2"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPad3"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPad4"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPad5"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPhone3"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPhone4"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPhone5"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPhone6"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPod1"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPod2"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPod3"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPod4"].location != NSNotFound){
        return TRUE;
    }else if([platform rangeOfString:@"iPhone7"].location != NSNotFound){
        return TRUE;
    }
    return FALSE;
}
+(NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
+(NSString *)platformString{
    NSString *platform = [CTHPlatform platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}
+(CGFloat)getWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}
+(CGFloat)getHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}
+(CGFloat)getRatio{
    if([self is_iPad]){
        if (CTHPlatform.getWidth<=CTHPlatform.getHeight){
            return CTHPlatform.getWidth/768.0f;
        }else{
            return CTHPlatform.getHeight/768.0f;
        }
    }else{
        if (CTHPlatform.getWidth<=CTHPlatform.getHeight){
            return CTHPlatform.getWidth/320.0f;
        }else{
            return CTHPlatform.getHeight/320.0f;
        }
    }
}
+(NSString*)storyBoardNameOfDevice:(NSString*)storyBoardName{
    if([self is_iPad])
        storyBoardName = [storyBoardName stringByAppendingString:@"_iPad"];
    return storyBoardName;
}
@end
