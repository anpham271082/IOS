#import "DGActivityIndicatorView.h"
@implementation CTHDGActivityIndicator
+(void)showIndicatorView:(UIControl*)control Color:(UIColor*)color{
    CGFloat ratio = 100/50;
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:color];
    activityIndicatorView.tag = 500;
    activityIndicatorView.size = 16*ratio;
    activityIndicatorView.frame = CGRectMake((control.frame.size.width-10*ratio)/2, (control.frame.size.height-10*ratio)/2, 10*ratio, 10*ratio);
    [control addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}
+(void)hideIndicatorView:(UIControl*)control{
    DGActivityIndicatorView *activityIndicatorView = (DGActivityIndicatorView*)[CTHHelper controlFromTag:500 withView:control kind:[DGActivityIndicatorView class]];
    if(activityIndicatorView){
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
    }
}
@end
