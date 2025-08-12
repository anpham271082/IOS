#import <UIKit/UIKit.h>
@class CTHSwitch;
@protocol CTHSwitchDelegate <NSObject>
-(void)switchStateChanged:(CTHSwitch*)object;
-(void)switchTapped:(CTHSwitch*)object;
@end
@interface CTHSwitch : UIView
@property (weak) IBOutlet id<CTHSwitchDelegate> delegateCTHSwitch;
@property (nonatomic) BOOL isOn;
@property (nonatomic, strong) UIImageView *offImageView;
@property (nonatomic, strong) UIImageView *onImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *switchThumbButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (copy) IBInspectable NSString *styleSwitch;
- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
