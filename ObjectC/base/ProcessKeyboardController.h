#import "RefreshTableHeaderController.h"
#import "CTHTextField.h"
@interface ProcessKeyboardController : RefreshTableHeaderController{
    UITextField *activeField;
    UITextView *activeView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomControl;
@property (assign) NSInteger topHeightBottomControl;
@property (assign) NSInteger heightKeyboard;
-(void)addHandleSingleTap;

-(void)keyboardWasShown;

-(void)keyboardWillHide;

-(void)hideGenderView;

-(void)actionHandleSingleTap;

-(void)CTHTextFieldDidBeginEditing:(CTHTextField*)textField;

-(void)CTHTextFieldDidEndEditing:(CTHTextField*)textField;

-(void)textFieldDidChange:(CTHTextField*)textField;
@end
