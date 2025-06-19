#import "ViewController.h"
#import "CTHCache.h"
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [CTHCache destroyLackingDataProtection];
    self.topHeightBottomControl = 0;
    self.heightKeyboard = 0;
    if(self.contentScrollView)
        [self performSelector:@selector(waitScrollView) withObject:nil afterDelay:0.1];
}
-(void)waitScrollView{
    self.topHeightBottomControl = self.bottomControl.frame.origin.y + self.bottomControl.frame.size.height;
    [self.contentScrollView setContentSize:CGSizeMake(0, self.contentScrollView.tag+self.topHeightBottomControl)];
}
-(void)viewDidLayoutSubviews{
    if(self.contentScrollView && self.heightKeyboard==0){
        self.topHeightBottomControl = self.bottomControl.frame.origin.y + self.bottomControl.frame.size.height;
        [self.contentScrollView setContentSize:CGSizeMake(0, self.contentScrollView.tag+self.topHeightBottomControl)];
    }
    if ([self respondsToSelector:@selector(didLayoutSubviews)]){
        [self didLayoutSubviews];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitDisplayUnityInView) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitScrollView) object:nil];
    if(self.connection){
        [self.connection cancel];
        self.connection = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImage*_Nullable)snapShotImage{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, UIScreen.mainScreen.scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)snapShot:(void(^)(void))callComplete{
    self.callbackSnapShotComplete = callComplete;
    UIImage *img = [self snapShotImage];
    if(img){
        self.snapshotImageView.image = [self snapShotImage];
        if(self.callbackSnapShotComplete)
            self.callbackSnapShotComplete();
    }
}
@end
