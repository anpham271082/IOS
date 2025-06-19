#import "CTHDepthScrollView.h"
@implementation CTHDepthScrollView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    angleRatio = 0.3;
    rotationX = -1;
    rotationY = 0;
    rotationZ = 0;
    translateX = 0.05;
    translateY = 0;
    
    self.pagingEnabled = TRUE;
    self.clipsToBounds = FALSE;
    self.showsHorizontalScrollIndicator = FALSE;
    self.showsVerticalScrollIndicator = FALSE;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat contentOffsetX = self.contentOffset.x;
    for(UIView *view in self.subviews){
        CATransform3D t1 = view.layer.transform;
        view.layer.transform = CATransform3DIdentity;
        CGFloat distanceFromCenterX = view.frame.origin.x - contentOffsetX;
        view.layer.transform = t1;
        distanceFromCenterX = distanceFromCenterX * 100 / self.frame.size.width;
        CGFloat angle = distanceFromCenterX * angleRatio;
        
        CGFloat offset = distanceFromCenterX;
        CGFloat _translateX = (self.frame.size.width * translateX) * offset / 100;
        CGFloat _translateY = (self.frame.size.width * translateY) * fabs(offset) / 100;
        CATransform3D t = CATransform3DMakeTranslation(_translateX, _translateY, 0);
        view.layer.transform = CATransform3DRotate(t, (angle * M_PI / 180), rotationX, rotationY, rotationZ);
        
        if((angle * M_PI / 180)>=0){
            view.alpha = 1-(angle * M_PI / 180);
        }else{
            view.alpha = (angle * M_PI / 180)+1;
        }
    }
}
-(NSInteger)currentPage{
    CGFloat pageWidth = self.frame.size.width;
    if(pageWidth<=0)
        return 0;
    CGFloat fractionalPage = MAX(self.contentOffset.x, 0) / pageWidth;
    return round(fractionalPage);
}
-(void)loadNextPage:(BOOL)animated{
    [self loadPageIndex:self.currentPage + 1 Animated:animated];
}
-(void)loadPreviousPage:(BOOL)animated{
    [self loadPageIndex:self.currentPage - 1 Animated:animated];
}
-(void)loadPageIndex:(NSInteger)index Animated:(BOOL)animated{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newFrame.size.width * index;
    newFrame.origin.y = 0;
    [self scrollRectToVisible:newFrame animated:animated];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CTHView *currentView;
    for(UIView *view in self.subviews){
        if((view.tag-200)!=self.currentPage){
            CTHView *darkView = (CTHView*)[CTHHelper controlFromTag:20 withView:view kind:[CTHView class]];
            //if(darkView != nil)
                //darkView.alpha = 0.4;
        }else{
            currentView = (CTHView*)[CTHHelper controlFromTag:20 withView:view kind:[CTHView class]];
        }
    }
    if(currentView!= nil){
        //currentView.alpha = 0;
    }
}
@end
