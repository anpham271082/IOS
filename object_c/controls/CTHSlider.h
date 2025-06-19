#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CTHSlider : UIView
@property(strong, nonatomic)IBInspectable UIColor *disableColor;
@property(strong, nonatomic)IBInspectable UIColor *enableColor;
@property(assign)IBInspectable NSInteger numDisableOval;
@property(assign)IBInspectable NSInteger numEnableOval;
-(void)prevAnimation;
-(void)nextAnimation;
@end

