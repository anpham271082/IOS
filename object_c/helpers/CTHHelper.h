#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
@interface CTHHelper : NSObject{
    AVPlayer *player;
    AVPlayerLayer *layer;
}
+(instancetype)sharedInstance;
-(void)playVideoInView:(UIView*)view;
-(void)closeVideo;
+(void)removeAllRootViews:(UINavigationController*)navigationController;
+(void)removeAllSubviews:(UIView *)view;
+(void)drawTriangle:(UIView *)view;
+(void)animationFade:(UIView*)view FadeIn:(BOOL)fade;
+(CGRect)resizeLabel:(UILabel *)label;
+(CGFloat)resizeWidthLabel:(UILabel*)lbl;
+(NSString*)encodeStringToBase64:(NSString*)fromString;
+(UIImage *)fixrotation:(UIImage *)image;
+(NSString *)identifierForAdvertising;
+(BOOL)checkEmail:(NSString*)strEmail Regex:(NSString*)regex;
+(NSString *)strongPassword:(NSString *)strPass MaxLength:(NSInteger)maxLength;
+(BOOL)checkNumeric:(NSString *)strText;
+(NSString*)getNumberFormatter:(NSNumber*)value NumberStyle:(NSNumberFormatterStyle)numberStyle;
+(NSString *)hexToDecimal:(NSString*)str;
+(NSArray *)hexInArray:(NSData*)data;
+(UIColor *)colorFromHexString:(UIColor *)defaultColor HexString:(NSString *)hexString;
+(BOOL)checkDate:(NSString *)strDate;
+(NSInteger)getAge:(NSString *)strDate MaxAge:(NSInteger)maxAge MinAge:(NSInteger)minAge;
+(void)log:(NSString *)strText;
+(NSString*)sha256:(NSString *)input;
+(BOOL)checkUpperCase:(NSString *)strPass;
+(BOOL)checkLowerCase:(NSString *)strPass;
+(BOOL)checkSpecialChars:(NSString *)strPass;
+(void)animationTextFieldDidBeginEditing:(UILabel*)label;
+(void)animationTextFieldDidEndEditing:(UILabel*)label TextField:(UITextField*)textField;
+(BOOL)checkDayInMonth:(NSString*)year Month:(NSString*)month Day:(NSInteger)day;
+(BOOL)dictionary:(NSMutableDictionary*)dic Key:(NSString*)key;
+(UIControl*)controlFromNib:(NSString*)nibName RestorationIdentifier:(NSString*)restorationIdentifier;
+(UIControl*)controlFromTag:(NSInteger)tag withView:(UIView*)view kind:(Class)aClass;
+(NSString*)getDateFromInterval:(double)created_at;
+(NSString*)getDateFromIntervalDDMMYY:(double)created_at;
+(NSString*)getDateFromIntervalDay:(NSString*)created_at;
+(NSString*)getDateFromIntervalMonth:(NSString*)created_at;
+(void)animation:(void(^)(void))blockAction;
+(void)animation:(void(^)(void))blockAction plusTime:(CGFloat)time;
+(void)animation:(void(^)(void))blockAction plusTime:(CGFloat)time completion:(void(^)(void))blockCompletion;
+(void)animation:(void(^)(void))blockAction completion:(void(^)(void))blockCompletion;
+(void)animationWithVelocity:(void(^)(void))blockAction completion:(void(^)(void))blockCompletion;
+(void)drawText:(CGPoint)point FontStyle:(NSInteger)fontStyle FontSize:(CGFloat)fontSize Width:(CGFloat)width Height:(CGFloat)height Alignment:(NSTextAlignment)alignment Text:(NSString*)strText Color:(UIColor*)color;
+(NSInteger)getHourFromMinute:(NSInteger)minute;
+(NSInteger)getTimeStamp:(NSString*)strDate;
+(BOOL)FBSDKApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
+(void)addSubview:(UIView*)parent withChildView:(UIView*)child withRect:(CGRect)rect;
+(double)DegreesToRadians:(double)angle;
@end
