#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CTHImageView : UIImageView
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property IBInspectable BOOL drawCornerRadius;
@property IBInspectable BOOL drawBorder;

-(void)reDrawing;

-(void)imageWithPath:(NSString*)strPath;

-(void)imageWithPath:(NSString*)strPath TintColor:(UIColor *)tintColor;

-(void)backgroundWithPath:(NSString*)strPath;
@end
