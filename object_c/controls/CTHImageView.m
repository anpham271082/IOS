#import "DGActivityIndicatorView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation CTHImageView
-(void)layoutSubviews{
    [super layoutSubviews];
    self.clipsToBounds = YES;
    [self reDrawing];
}
-(void)reDrawing{
    if(self.drawBorder==YES){
        if(self.borderWidth>0){
            self.layer.borderWidth = self.borderWidth;
            self.layer.borderColor = self.borderColor.CGColor;
        }
    }
    if(self.drawCornerRadius)
        self.layer.cornerRadius = self.frame.size.width/2;
}
-(void)imageWithPath:(NSString*)strPath{
    strPath = [NSString stringWithFormat:@"%@",strPath];
    if(strPath!=NULL||![strPath isEqualToString:@"<null>"])
        [self imageWithPath:self Path:strPath];
}
-(void)imageWithPath:(NSString*)strPath TintColor:(UIColor *)tintColor{
    strPath = [NSString stringWithFormat:@"%@",strPath];
    if(strPath!=NULL||![strPath isEqualToString:@"<null>"])
        [self imageWithPath:self Path:strPath TintColor:tintColor];
}
-(void)backgroundWithPath:(NSString*)strPath{
    if(strPath!=NULL)
        [self imageWithPath:self Path:strPath];
}
-(void)imageWithPath:(NSObject*)object Path:(NSString*)strPath{
    strPath = [strPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *className = NSStringFromClass([object class]);
    className = [className stringByReplacingOccurrencesOfString:@"CTHImageView" withString:@"UIImageView"];
    className = [className stringByReplacingOccurrencesOfString:@"CustomButton" withString:@"UIButton"];
    NSArray *array = @[@"UIImageView", @"UIButton"];
    NSUInteger index = [array indexOfObject:className];
    switch (index) {
        case 0:{
            UIImageView *imageView = (UIImageView*)object;
            //[self addAnimation:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:strPath] placeholderImage:nil options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imageView.image = image;
            }];
        }
            break;
        case 1:{
            UIButton *button = (UIButton*)object;
            [button sd_setImageWithURL:[NSURL URLWithString:strPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_wait_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
            break;
    }
}
-(void)imageWithPath:(NSObject*)object Path:(NSString*)strPath TintColor:tintColor{
    strPath = [strPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *className = NSStringFromClass([object class]);
    className = [className stringByReplacingOccurrencesOfString:@"CTHImageView" withString:@"UIImageView"];
    className = [className stringByReplacingOccurrencesOfString:@"CustomButton" withString:@"UIButton"];
    NSArray *array = @[@"UIImageView", @"UIButton"];
    NSUInteger index = [array indexOfObject:className];
    switch (index) {
        case 0:{
            UIImageView *imageView = (UIImageView*)object;
            //[self addAnimation:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:strPath] placeholderImage:nil options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imageView.image = image;
                imageView.tintColor = tintColor;
            }];
        }
            break;
        case 1:{
            UIButton *button = (UIButton*)object;
            [button sd_setImageWithURL:[NSURL URLWithString:strPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_wait_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            
        }
            break;
    }
}
-(void)removeAnimation:(NSObject*)object{
    CTHImageView *imageView = (CTHImageView*)object;
    CTHView *contentView = (CTHView*)[CTHHelper controlFromTag:50 withView:imageView kind:[CTHView class]];
    if(contentView == nil)
        return;
    CTHView *animationView = (CTHView*)[CTHHelper controlFromTag:51 withView:contentView kind:[CTHView class]];
    DGActivityIndicatorView *activityIndicatorView = (DGActivityIndicatorView*)[CTHHelper controlFromTag:52 withView:animationView kind:[DGActivityIndicatorView class]];
    if(activityIndicatorView){
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
    }
    if(animationView){
        [contentView removeFromSuperview];
        contentView = nil;
    }
}
-(void)addAnimation:(NSObject*)object{
    CTHImageView *imageView = (CTHImageView*)object;
    CTHView *contentView = (CTHView*)[CTHHelper controlFromTag:50 withView:imageView kind:[CTHView class]];
    if(contentView == nil){
        if(imageView.frame.size.width>=50&&imageView.frame.size.height>=50){
            CTHView *contentView = [[CTHView alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
            CGFloat ratio = contentView.frame.size.height/50;
            contentView.tag = 50;
            contentView.backgroundColor = [UIColor whiteColor];
            CTHView *animationView = [[CTHView alloc] initWithFrame:CGRectMake(2, 2, contentView.frame.size.width-4 , contentView.frame.size.height-4)];
            animationView.backgroundColor = [UIColor whiteColor];
            animationView.tag = 51;
            DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
            activityIndicatorView.tag = 52;
            activityIndicatorView.size = 16*ratio;
            activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10*ratio)/2, 9*ratio, 10*ratio, 10*ratio);
            [animationView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            CTHLabel *loadingLabel = [[CTHLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-animationView.frame.size.height/2, animationView.frame.size.width , animationView.frame.size.height/4)];
            loadingLabel.tag = 53;
            loadingLabel.text = [CTHLanguage language:@"picture is loading" Text:@"Picture is loading..."];
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            loadingLabel.textColor = [UIColor blackColor];
            loadingLabel.font = [UIFont fontWithName:[CTHFont fontName:2] size:5*ratio];
            [animationView addSubview:loadingLabel];
            
            CTHLabel *pleaseWaitLabel = [[CTHLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-animationView.frame.size.height/4, animationView.frame.size.width , animationView.frame.size.height/4)];
            pleaseWaitLabel.tag = 54;
            pleaseWaitLabel.text = [CTHLanguage language:@"please wait" Text:@"Please wait"];
            pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
            pleaseWaitLabel.textColor = [UIColor blackColor];
            pleaseWaitLabel.font = [UIFont fontWithName:[CTHFont fontName:2] size:5*ratio];
            [animationView addSubview:pleaseWaitLabel];
            [contentView addSubview:animationView];
            [imageView addSubview:contentView];
        }else{
            CTHView *contentView = [[CTHView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width , imageView.frame.size.height)];
            CGFloat ratio = contentView.frame.size.height/30;
            contentView.tag = 50;
            contentView.backgroundColor = [UIColor whiteColor];
            CTHView *animationView = [[CTHView alloc] initWithFrame:CGRectMake(2, 2, contentView.frame.size.width-4 , contentView.frame.size.height-4)];
            animationView.backgroundColor = [UIColor whiteColor];
            animationView.tag = 51;
            DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
            activityIndicatorView.tag = 52;
            activityIndicatorView.size = 15*ratio;
            activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10*ratio)/2, (animationView.frame.size.height-10*ratio)/2, 10*ratio, 10*ratio);
            [animationView addSubview:activityIndicatorView];
            [activityIndicatorView startAnimating];
            
            [contentView addSubview:animationView];
            [imageView addSubview:contentView];
        }
    }
}
@end
