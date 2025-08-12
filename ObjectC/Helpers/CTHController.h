#import <UIKit/UIKit.h>
@interface CTHController : NSObject
+(instancetype)sharedInstance;
-(UINavigationController*)getNavigationController;
-(void)initViewController;
-(NSObject*)getControllerWithName:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName;
-(NSObject*)getControllerWithNameFromRoot:(NSString*)controllerName;
-(NSObject*)getLastController:(UINavigationController*)navigationController;
-(NSObject*)getControllerFromStoryboard:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName;
-(NSObject*)push:(UINavigationController*)navigationController RestorationIdentifier:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName Animated:(BOOL)animated;
-(NSObject*)pushFromRoot:(NSString*)restorationIdentifier StoryboardName:(NSString*)storyboardName Animated:(BOOL)animated;
-(void)pop:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName Animated:(BOOL)animated;
-(void)popFromRoot:(NSString*)controllerName Animated:(BOOL)animated;
-(void)popWithController:(UIViewController*)controller Animated:(BOOL)animated;
-(void)pushWithController:(UIViewController*)controller Animated:(BOOL)animated;
-(void)popWithRestorationIdentifier:(UINavigationController*)navigationController ControllerName:(NSString*)controllerName RestorationIdentifier:(NSString*)restorationIdentifier Animated:(BOOL)animated;
-(void)backFromRoot:(BOOL)animated;
-(void)backFromNavigation:(UINavigationController *)navigationController Animated:(BOOL)animated;
-(void)root:(BOOL)animated;
-(UIView*)getViewFromXib:(NSString *)xibFile RestorationIdentifier:(NSString*)restorationIdentifier;
@end
