#import "CTHController.h"
#import "PrevViewControllerSegue.h"
@implementation PrevViewControllerSegue
-(void)perform{
    if([self.identifier isEqualToString:@"HomeController"]){
        /*UINavigationController *navigationController = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        navigationController.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           navigationController.view.userInteractionEnabled = YES;*/
                           [[CTHController sharedInstance] backFromRoot:YES];
                       //});
        return;
    }
    if([self.identifier isEqualToString:@"actionNoAnimated"])
        [[CTHController sharedInstance] backFromRoot:NO];
    else
        [[CTHController sharedInstance] backFromRoot:YES];
}
@end
