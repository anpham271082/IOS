#import <UIKit/UIKit.h>
@class CTHTextField;
@protocol CTHTextFieldDelegate <NSObject>
-(void)textFieldDidChange:(CTHTextField*)textField;
@end
IB_DESIGNABLE
@interface CTHTextField : UITextField
@property (weak) IBOutlet id<CTHTextFieldDelegate> delegateCTHTextField;
@property(copy)IBInspectable NSString *langPlaceHolder;
@property(copy)IBInspectable NSString *defaultColor;
@property(copy)IBInspectable NSString *key;
@property(assign)IBInspectable NSInteger fontStyleTextField;
@property(assign)IBInspectable NSUInteger maxLength;
@property IBInspectable BOOL isMaxLength;
@property(assign) NSInteger fontSizeTextField;
-(NSString*)trimming;
-(NSInteger)getFontSize;
@end
