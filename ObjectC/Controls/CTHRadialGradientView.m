#import "CTHRadialGradientView.h"
@implementation CTHRadialGradientView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *colors = [NSArray arrayWithObjects:self.radialGradientFromColor.CGColor, self.radialGradientToColor.CGColor, nil];
    
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, (CFArrayRef) colors, nil);
    
    double circleWidth = self.frame.size.width;
    double circleHeight = self.frame.size.height;
    
    CGPoint theCenter = CGPointMake(circleWidth/2, circleHeight/2);
    
    double radius = circleHeight;
    
    if (circleHeight < circleWidth) {
        radius = circleWidth;
    }
    
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation;
    CGContextDrawRadialGradient(context, myGradient, theCenter, 0.0, theCenter, radius/1.3, options);
}
@end
