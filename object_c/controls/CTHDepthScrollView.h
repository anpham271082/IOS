#import <UIKit/UIKit.h>
@interface CTHDepthScrollView : UIScrollView<UIScrollViewDelegate>{
    CGFloat angleRatio;
    CGFloat rotationX;
    CGFloat rotationY;
    CGFloat rotationZ;
    CGFloat translateX;
    CGFloat translateY;
}
-(NSInteger)currentPage;
@end
