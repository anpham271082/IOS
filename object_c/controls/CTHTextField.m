@implementation CTHTextField
#pragma mark - Initializer
-(void)awakeFromNib{
    [super awakeFromNib];
    self.fontSizeTextField = (self.font.pointSize)*CTHPlatform.getRatio;
    self.font = [UIFont fontWithName:[CTHFont fontName:self.fontStyleTextField] size:self.fontSizeTextField];
    if(self.defaultColor!=nil){
        if ([self.defaultColor isEqualToString:@"black"]){
            self.textColor = [UIColor blackColor];
        }else if ([self.defaultColor isEqualToString:@"red"]){
            self.textColor = [UIColor redColor];
        }else if ([self.defaultColor isEqualToString:@"gray"]){
            self.textColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:CTHUserDefined.GRAY_COLOR];
        }else if ([self.defaultColor isEqualToString:@"green"]){
            self.textColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:CTHUserDefined.GREEN_COLOR];
        }
    }
    if(self.langPlaceHolder!=nil){
        if ([self.langPlaceHolder length]>0){
            self.placeholder = [CTHLanguage language:self.langPlaceHolder Text:self.placeholder];
        }
    }
    [self addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange{
    if (self.delegateCTHTextField && [self.delegateCTHTextField respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.delegateCTHTextField textFieldDidChange:self];
    }
}
-(NSString*)trimming{
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(NSInteger)getFontSize{
    return self.fontSizeTextField;
}
@end
