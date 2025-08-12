#import <UIKit/UIKit.h>
enum EVENT_BUTTON{
    TOUCH_UP,
    TOUCH_DOWN
};
IB_DESIGNABLE
@interface CTHButton: UIButton
@property IBInspectable BOOL pushGTM;
@property(copy)IBInspectable NSString *openScreenGTM;
@property(copy)IBInspectable NSString *categoryGTM;
@property(copy)IBInspectable NSString *actionGTM;
@property(copy)IBInspectable NSString *labelGTM;

@property(copy)   IBInspectable NSString *langButton;
@property(assign) IBInspectable NSInteger fontStyleButton;
@property(assign) IBInspectable NSInteger cornerRadius;
@property(copy)   IBInspectable NSString *styleButton;
@property IBInspectable BOOL lineHeightMultiple;
@property(assign) NSInteger fontSizeButton;
@property(assign) NSInteger touchButton;
@property(strong, nonatomic) NSObject *object;
/*@property(strong, nonatomic) LessonModel *lessonModel;
@property(strong, nonatomic) KidChallengeModel *kidChallengeModel;
@property(strong, nonatomic) BandChallengeModel *bandChallengeModel;*/
@property (assign) NSInteger xPosition;

-(NSInteger)getFontSize;
-(void)setEnableButton:(BOOL)value;
-(void)changeText;
@end
