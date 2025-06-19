#import "ProcessKeyboardController.h"

@implementation ProcessKeyboardController
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)addHandleSingleTap{
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:tapper];
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
    if ([self respondsToSelector:@selector(actionHandleSingleTap)]){
        [self actionHandleSingleTap];
    }
    if ([self respondsToSelector:@selector(hideGenderView)]){
        [self hideGenderView];
    }
}
-(void)viewWillAppear: (BOOL)animated{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear: (BOOL)animated{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.heightKeyboard = kbSize.height;
    if ([self respondsToSelector:@selector(keyboardWasShown)]){
        [self keyboardWasShown];
    }
    if ([self respondsToSelector:@selector(hideGenderView)]){
        [self hideGenderView];
    }
    self.topHeightBottomControl = self.bottomControl.frame.origin.y + self.bottomControl.frame.size.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentScrollView setContentSize:CGSizeMake(0, self.contentScrollView.tag + self.topHeightBottomControl+20+self.heightKeyboard+10)];
    });
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    self.heightKeyboard = 0;
    self.topHeightBottomControl = self.bottomControl.frame.origin.y + self.bottomControl.frame.size.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentScrollView setContentSize:CGSizeMake(0, self.contentScrollView.tag + self.topHeightBottomControl)];
    });
    if ([self respondsToSelector:@selector(keyboardWillHide)]){
        [self keyboardWillHide];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self respondsToSelector:@selector(CTHTextFieldDidBeginEditing:)]) {
        [self CTHTextFieldDidBeginEditing:(CTHTextField*)textField];
    }
    activeField = textField;
    activeView = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self respondsToSelector:@selector(CTHTextFieldDidEndEditing:)]) {
        [self CTHTextFieldDidEndEditing:(CTHTextField*)textField];
    }
    activeField = nil;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    activeField = nil;
    activeView = textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    activeView = nil;
}
-(BOOL)textViewShouldReturn:(UITextView *)textView {
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField isKindOfClass:[CTHTextField class]]){
        CTHTextField *cthTextField = (CTHTextField*)textField;
        if([cthTextField.key isEqualToString:@"pincode"]||[cthTextField.key isEqualToString:@"date"]||[cthTextField.key isEqualToString:@"pin"]){
            if (cthTextField.text.length >= cthTextField.maxLength){
                NSString *substring = [cthTextField.text substringToIndex:cthTextField.text.length-1];
                cthTextField.text = [substring stringByAppendingString:string];
                if ([self respondsToSelector:@selector(textFieldDidChange:)]) {
                    [self textFieldDidChange:cthTextField];
                }
                return NO;
            }
        }
        if ([self respondsToSelector:@selector(textFieldDidChange:)]) {
            [self textFieldDidChange:cthTextField];
        }
        if(cthTextField.isMaxLength){
            if (cthTextField.text.length >= cthTextField.maxLength && range.length == 0){
                return NO;
            }
        }
    }
    return YES;
}
@end
