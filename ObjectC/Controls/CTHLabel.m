@implementation CTHLabel
#define appium 0
#pragma mark - Initializer
-(void)awakeFromNib{
    [super awakeFromNib];
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
    self.fontSizeLabel = (self.font.pointSize-2)*CTHPlatform.getRatio;
    self.font = [UIFont fontWithName:[CTHFont fontName:self.fontStyleLabel] size:self.fontSizeLabel];
    if(self.langLabel!=nil){
        if ([self.langLabel length]>0)
            self.text = [CTHLanguage language:self.langLabel Text:self.text];
    }
    if(self.drawBorder==YES){
        self.clipsToBounds = YES;
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
        if(self.cornerRadius<0)
            self.layer.cornerRadius = self.frame.size.width/2;
    }
    if(self.drawAttributedString==YES){
        [self initialAttributedString];
    }else if(self.lineHeightMultiple==YES){
        if(self.valueLineHeight>0){
            [self changeTextLineHeight:self.text LineHeight:self.valueLineHeight];
        }else{
            [self changeText:self.text];
        }
    }
}
- (void)setLabelDelegate:(id)labelDelegate{
    self.labelDelegate = labelDelegate;
}
-(void)changeText:(NSString*)str{
    self.text = str;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString  alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineHeightMultiple = 1.2;
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}
-(void)changeTextLineHeight:(NSString*)str LineHeight:(CGFloat)lineHeight{
    self.text = str;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString  alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineHeightMultiple = lineHeight;
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}
-(void)changeFont{
    self.font = [UIFont fontWithName:[CTHFont fontName:self.fontStyleLabel] size:self.fontSizeLabel];
}
-(void)initialAttributedString{
    NSArray *attributedArray = [[CTHLanguage language:self.attributedString Text:self.attributedString] componentsSeparatedByString:@"$"];
    NSArray *colorAttributedArray = [self.colorAttributedString componentsSeparatedByString:@"$"];
    NSArray *underlineAttributedArray = [[CTHLanguage language:self.underlineAttributedString Text:self.underlineAttributedString] componentsSeparatedByString:@"$"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSInteger i=0; i<[colorAttributedArray count]; i++) {
        if([attributedArray count]>i){
            NSRange range = [self.text rangeOfString:[attributedArray objectAtIndex:i] options:NSBackwardsSearch];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[CTHHelper colorFromHexString:self.textColor HexString:[colorAttributedArray objectAtIndex:i]] range:range];
            if(self.drawAttributedStringIncreaseSizeFont){
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[CTHFont fontName:self.fontStyleLabel] size:self.fontSizeLabel+2] range:range];
            }
        }
    }

    for (NSInteger i=0; i<[underlineAttributedArray count]; i++) {
        if([attributedArray count]>i){
            NSRange range = [self.text rangeOfString:[attributedArray objectAtIndex:i] options:NSBackwardsSearch];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        }
    }
    if(self.lineHeightMultiple==YES){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.lineHeightMultiple = 1.2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    }

    self.attributedText = attributedString;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
    [self addGestureRecognizer:tapGestureRecognizer];
}
-(void)initialAttributedStringRedeem{
    NSArray *attributedArray = [[CTHLanguage language:self.attributedString Text:self.attributedString] componentsSeparatedByString:@"$"];
    NSArray *colorAttributedArray = [self.colorAttributedString componentsSeparatedByString:@"$"];
    NSArray *fontAttributedArray = [self.fontAttributedString componentsSeparatedByString:@"$"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSInteger i=0; i<[colorAttributedArray count]; i++) {
        if([attributedArray count]>i){
            NSRange range = [self.text rangeOfString:[attributedArray objectAtIndex:i] options:NSBackwardsSearch];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[CTHHelper colorFromHexString:self.textColor HexString:[colorAttributedArray objectAtIndex:i]] range:range];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:[CTHFont fontName:[[fontAttributedArray objectAtIndex:i] intValue]] size:self.fontSizeLabel+2] range:range];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineHeightMultiple = 1.4;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    NSArray *attributedArray = [[CTHLanguage language:self.attributedString Text:self.attributedString] componentsSeparatedByString:@"$"];
    for (NSInteger i=0; i<[attributedArray count]; i++) {
        NSRange range = [self.text rangeOfString:[attributedArray objectAtIndex:i] options:NSBackwardsSearch];
        CGPoint tapLocation = [recognizer locationInView:self];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:layoutManager];
        if(self.lineHeightMultiple){
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = self.textAlignment;
            paragraphStyle.lineHeightMultiple = 1.2;
            [textStorage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStorage.string.length)];
        }
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.bounds.size.width, self.frame.size.height+self.font.pointSize*1.2)];
        textContainer.lineFragmentPadding  = 0;
        textContainer.maximumNumberOfLines = self.numberOfLines;
        textContainer.lineBreakMode        = self.lineBreakMode;
        [layoutManager addTextContainer:textContainer];
        
        NSUInteger characterIndex = [layoutManager characterIndexForPoint:tapLocation inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
        if(appium==1){
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleTap: Result:)]) {
                [self.delegate handleTap:self Result:[attributedArray objectAtIndex:i]];
            }
            return;
        }
        if((characterIndex>=range.location) && (characterIndex<=range.location+range.length)){
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleTap: Result:)]) {
                [self.delegate handleTap:self Result:[attributedArray objectAtIndex:i]];
            }
        }
    }
}
-(NSString*)trimming{
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(NSInteger)getFontSize{
    return self.fontSizeLabel;
}
-(void)setFontSize:(NSInteger)size{
    self.fontSizeLabel = (size-2)*CTHPlatform.getRatio;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
