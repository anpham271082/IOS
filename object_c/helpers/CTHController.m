@implementation CTHController
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(UINavigationController*)getNavigationController{
    return (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
}
-(void)initViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[CTHPlatform storyBoardNameOfDevice:@"NavigationController_ObjectC"] bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [mainStoryboard instantiateInitialViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = navigationController;
}
-(NSObject*)getControllerWithName:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName{
    for(UIViewController *ctrl in navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:controllerName]){
            return ctrl;
            break;
        }
    }
    return nil;
}
-(NSObject*)getControllerWithNameFromRoot:(NSString*)controllerName{
    return [[CTHController sharedInstance] getControllerWithName:[[CTHController sharedInstance] getNavigationController] ControllerName:controllerName];
}
-(NSObject*)getLastController:(UINavigationController*)navigationController{
    return [navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1];
}
-(NSObject*)getControllerFromStoryboard:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CTHPlatform storyBoardNameOfDevice:storyboardName] bundle:[NSBundle mainBundle]];
    NSObject *viewController = [storyboard instantiateViewControllerWithIdentifier:restorationIdentifier];
    return viewController;
}
-(NSObject*)push:(UINavigationController*)navigationController RestorationIdentifier:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName Animated:(BOOL)animated{
    UIViewController *viewController = (UIViewController*)[self getControllerFromStoryboard:restorationIdentifier StoryboardName:storyboardName];
    for(UIViewController *ctrl in navigationController.viewControllers) {
        if ([ctrl.restorationIdentifier isEqualToString:restorationIdentifier]){
            [navigationController popToViewController:ctrl animated:animated];
            return ctrl;
        }
    }
    [navigationController pushViewController:viewController animated:animated];
    [viewController.view updateConstraints];
    [viewController.view updateConstraintsIfNeeded];
    return viewController;
}
-(NSObject*)pushFromRoot:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName Animated:(BOOL)animated{
    return [self push:[[CTHController sharedInstance] getNavigationController] RestorationIdentifier:restorationIdentifier StoryboardName:storyboardName Animated:animated];
}
-(void)popWithController:(UIViewController*)controller Animated:(BOOL)animated{
    [[[CTHController sharedInstance] getNavigationController] popToViewController:controller animated:animated];
}
-(void)pushWithController:(UIViewController*)controller Animated:(BOOL)animated{
    [[[CTHController sharedInstance] getNavigationController] pushViewController:controller animated:animated];
}
-(void)pop:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName Animated:(BOOL)animated{
    for(UIViewController *ctrl in navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:controllerName]){
            [navigationController popToViewController:ctrl animated:animated];
            return;
        }
    }
}
-(void)popFromRoot:(NSString*)controllerName Animated:(BOOL)animated{
    [self pop:[[CTHController sharedInstance] getNavigationController] ControllerName:controllerName Animated:animated];
}

-(void)popWithRestorationIdentifier:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName RestorationIdentifier:(NSString*)restorationIdentifier Animated:(BOOL)animated{
    for(UIViewController *ctrl in navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:controllerName] && [ctrl.restorationIdentifier isEqualToString:restorationIdentifier]){
            [navigationController popToViewController:ctrl animated:animated];
            return;
        }
    }
}
-(void)backFromRoot:(BOOL)animated{
    NSInteger count = 1;
    for(UIViewController *ctrl in [[CTHController sharedInstance] getNavigationController].viewControllers){
        if(count==[[CTHController sharedInstance] getNavigationController].viewControllers.count-1){
            [[[CTHController sharedInstance] getNavigationController] popToViewController:ctrl animated:animated];
            return;
        }
        count = count+1;
    }
}
-(void)backFromNavigation:(UINavigationController *)navigationController Animated:(BOOL)animated{
    NSInteger count = 1;
    for(UIViewController *ctrl in navigationController.viewControllers){
        if(count==navigationController.viewControllers.count-1){
            [navigationController popToViewController:ctrl animated:animated];
            return;
        }
        count = count+1;
    }
}
-(void)root:(BOOL)animated{
    [[[CTHController sharedInstance] getNavigationController] popToRootViewControllerAnimated:animated];
}
-(UIView*)getViewFromXib:(NSString *)xibFile RestorationIdentifier:(NSString*)restorationIdentifier{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:xibFile owner:nil options:nil];
    UIView *view;
    for (NSInteger i=0; i<[nibViews count]; i++) {
        view = [nibViews objectAtIndex:i];
        if ([view.restorationIdentifier isEqualToString:restorationIdentifier]) {
            return view;
        }
    }
    return nil;
}
@end
