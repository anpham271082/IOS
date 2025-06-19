@implementation CTHButton
#pragma mark - Initializer
-(instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchDrag) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchDrag) forControlEvents:UIControlEventTouchCancel];
        [self addTarget:self action:@selector(touchDrag) forControlEvents:UIControlEventTouchDragOutside];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.touchButton = TOUCH_UP;
    self.fontSizeButton = (self.titleLabel.font.pointSize-2)*CTHPlatform.getRatio;
    if(self.langButton!=nil){
        if (self.langButton.length > 0)
            [self setTitle:[CTHLanguage language:self.langButton Text:self.titleLabel.text] forState:UIControlStateNormal];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.font = [UIFont fontWithName:[CTHFont fontName:self.fontStyleButton] size:self.fontSizeButton];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = self.bounds.size.height;
    frame.origin.y = self.titleEdgeInsets.top;
    self.titleLabel.frame = frame;
    
    if(self.cornerRadius==-1)
        self.layer.cornerRadius = self.frame.size.height/2;
    else
        self.layer.cornerRadius = 6;
    if(self.enabled)
        [self drawButton];
    if(self.lineHeightMultiple==YES)
        [self changeText];
}
-(void)changeText{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString  alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.titleLabel.textAlignment;
    paragraphStyle.lineHeightMultiple = 1.2;
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.titleLabel.text.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.titleLabel.text.length)];
    self.titleLabel.attributedText = attributedString;
}
-(NSInteger)getFontSize{
    return self.fontSizeButton;
}
-(void)drawShadow{
    self.layer.shadowColor = [[UIColor colorWithRed:132/255.f green:147/255.f blue:124/255.f alpha:1] CGColor];
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 10.0f;
    self.layer.masksToBounds = NO;
}
-(void)setEnableButton:(BOOL)value{
    self.enabled = value;
    if(self.enabled){
        [self drawButton];
    }else{
        self.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#bbb9b9"];
        self.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#b6b5b5"].CGColor;
        self.layer.shadowColor = [[UIColor clearColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 0;
        self.layer.masksToBounds = NO;
    }
}
-(void)drawNormal{
    self.layer.borderWidth = 1;
    switch (self.touchButton) {
        case TOUCH_UP:
            self.layer.borderColor = [UIColor colorWithRed:0 green:149/255.f blue:46/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:0 green:172/255.f blue:52/255.f alpha:0.9];
            break;
        case TOUCH_DOWN:
            self.layer.borderColor = [UIColor colorWithRed:0 green:138/255.f blue:13/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:0 green:145/255.f blue:43/255.f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)drawWhite{
    self.layer.borderWidth = 1;
    switch (self.touchButton) {
        case TOUCH_UP:
            self.layer.borderColor = [UIColor colorWithRed:21/255.f green:156/255.f blue:55/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.9];
            break;
        case TOUCH_DOWN:
            self.layer.borderColor = [UIColor colorWithRed:19/255.f green:143/255.f blue:50/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)drawWhiteGray{
    self.layer.borderWidth = 1;
    switch (self.touchButton) {
        case TOUCH_UP:
            self.layer.borderColor = [UIColor colorWithRed:180/255.f green:180/255.f blue:180/255.f alpha:0.8].CGColor;
            self.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.9];
            break;
        case TOUCH_DOWN:
            self.layer.borderColor = [UIColor colorWithRed:140/255.f green:140/255.f blue:140/255.f alpha:0.8].CGColor;
            self.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)drawOrange{
    self.layer.borderWidth = 1;
    switch (self.touchButton) {
        case TOUCH_UP:
            self.layer.borderColor = [UIColor colorWithRed:180/255.f green:180/255.f blue:180/255.f alpha:0.8].CGColor;
            self.backgroundColor = [UIColor colorWithRed:243/255.f green:165/255.f blue:54/255.f alpha:0.9];
            break;
        case TOUCH_DOWN:
            self.layer.borderColor = [UIColor colorWithRed:140/255.f green:140/255.f blue:140/255.f alpha:0.8].CGColor;
            self.backgroundColor = [UIColor colorWithRed:230/255.f green:151/255.f blue:40/255.f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)drawFaceBook{
    self.layer.borderWidth = 1;
    switch (self.touchButton) {
        case TOUCH_UP:
            self.layer.borderColor = [UIColor colorWithRed:49/255.f green:78/255.f blue:140/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:59/255.f green:89/255.f blue:152/255.f alpha:0.9];
            break;
        case TOUCH_DOWN:
            self.layer.borderColor = [UIColor colorWithRed:45/255.f green:71/255.f blue:129/255.f alpha:0.9].CGColor;
            self.backgroundColor = [UIColor colorWithRed:54/255.f green:82/255.f blue:141/255.f alpha:0.9];
            break;
        default:
            break;
    }
}
-(void)drawButton{
    if (self.styleButton.length>0)
        [self drawShadow];
    if ([self.styleButton isEqualToString:@"normal"])
        [self drawNormal];
    else if ([self.styleButton isEqualToString:@"white"])
        [self drawWhite];
    else if ([self.styleButton isEqualToString:@"white_gray"])
        [self drawWhiteGray];
    else if ([self.styleButton isEqualToString:@"orange"])
        [self drawOrange];
    else if ([self.styleButton isEqualToString:@"facebook"])
        [self drawFaceBook];
}
-(void)touchUp{
    [self.superview endEditing:YES];
    if(self.pushGTM){
        if([self.categoryGTM length] > 0 && [self.actionGTM length]>0 && [self.labelGTM length]>0){
            UIApplication *delegate = (UIApplication*)[[UIApplication sharedApplication] delegate];
            if(self.openScreenGTM!=nil){
                SEL selector = NSSelectorFromString(@"pushScreenTA:");
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [delegate performSelector:selector withObject:self.openScreenGTM];
            }
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.categoryGTM, @"category", self.actionGTM, @"action", self.labelGTM, @"label", nil];
            SEL selector = NSSelectorFromString(@"pushEventTA:");
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [delegate performSelector:selector withObject:data];
        }
    }
    self.touchButton = TOUCH_UP;
    [self drawButton];
}
-(void)touchDown{
    self.touchButton = TOUCH_DOWN;
    [self drawButton];
    [self endEditing:YES];
}
-(void)touchDrag{
    self.touchButton = TOUCH_UP;
    [self drawButton];
}
@end
