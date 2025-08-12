#import "CTHRadialGradientView.h"
#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CTHView : UIView
@property(strong, nonatomic) CTHRadialGradientView *radialGradientView;
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(strong, nonatomic)IBInspectable UIColor *gradientFromColor;
@property(strong, nonatomic)IBInspectable UIColor *gradientToColor;
@property(strong, nonatomic)IBInspectable UIColor *shadowColor;
@property(strong, nonatomic)IBInspectable UIColor *outletColor;
@property(strong, nonatomic)IBInspectable UIColor *radialGradientFromColor;
@property(strong, nonatomic)IBInspectable UIColor *radialGradientToColor;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property(assign)IBInspectable CGFloat shadowOffsetX;
@property(assign)IBInspectable CGFloat shadowOffsetY;
@property(assign)NSInteger cornerMask;
@property IBInspectable BOOL drawOutlet;
@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL drawGradient;
@property IBInspectable BOOL drawShadow;
@property IBInspectable BOOL drawRadialGradient;
-(void)reDrawing;
-(void)updateRadialGradient;
-(void)updateMaskCorner;
@end
