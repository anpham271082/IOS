@implementation CTHSwitch
-(void)layoutSubviews{
    [super layoutSubviews];
    if([self.styleSwitch isEqualToString:@"1"]){
        self.backgroundColor = [UIColor clearColor];
        [self style1Init];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithRed:167/255.f green:222/255.f blue:40/255.f alpha:1].CGColor;
        self.layer.cornerRadius = self.frame.size.height/2;
        [self style2Init];
    }
}
-(void)style1Init{
    if(!self.bgView){
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(3, self.frame.size.height/4, self.frame.size.width-6, self.frame.size.height/2)];
        [self addSubview:self.bgView];
        self.bgView.layer.masksToBounds = NO;
        self.bgView.layer.cornerRadius = self.bgView.frame.size.height/2;
        self.bgView.layer.borderWidth = 1;
    }
    if(!self.switchThumbButton){
        NSInteger height = self.frame.size.height/2+self.frame.size.height/4;
        self.switchThumbButton = [[UIButton alloc] initWithFrame:CGRectMake(3, (self.frame.size.height-height)/2, height, height)];
        [self addSubview:self.switchThumbButton];
        self.switchThumbButton.layer.masksToBounds = NO;
        self.switchThumbButton.layer.cornerRadius = self.switchThumbButton.frame.size.height/2;
        self.switchThumbButton.layer.borderWidth = 1;
    }
    if(!self.actionButton){
        self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.actionButton];
        [self.actionButton addTarget:self action:@selector(switchThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.isOn == YES) {
        self.bgView.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#65bf81"];
        self.bgView.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#6ec589"].CGColor;
        
        self.switchThumbButton.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#159c37"];
        self.switchThumbButton.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#62bd7e"].CGColor;
        
        self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.switchThumbButton.frame.size.width-3, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
    }
    else {
        self.bgView.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#c6c5c5"];
        self.bgView.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#d2d2d2"].CGColor;
        
        self.switchThumbButton.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#f1f1f1"];
        self.switchThumbButton.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#d2d2d2"].CGColor;
        
        self.switchThumbButton.frame = CGRectMake(3, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
    }
}
-(void)style2Init{
    if(!self.offImageView){
        self.offImageView = [[UIImageView alloc] init];
        self.offImageView.image = [UIImage imageNamed:@"bg_switch_off"];
        self.offImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.offImageView];
    }
    self.offImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(!self.onImageView){
        self.onImageView = [[UIImageView alloc] init];
        self.onImageView.image = [UIImage imageNamed:@"bg_switch_on"];
        self.onImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.onImageView];
    }
    self.onImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(!self.switchThumbButton){
        self.switchThumbButton = [[UIButton alloc] init];
        [self addSubview:self.switchThumbButton];
    }
    if(!self.actionButton){
        self.actionButton = [[UIButton alloc] init];
        [self addSubview:self.actionButton];
        [self.actionButton addTarget:self action:@selector(switchThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.actionButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (self.isOn == YES) {
        self.offImageView.hidden = YES;
        self.onImageView.hidden = NO;
        [self.switchThumbButton setBackgroundImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
        self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height+2, 2, self.frame.size.height-4, self.frame.size.height-4);
    }else{
        self.offImageView.hidden = NO;
        self.onImageView.hidden = YES;
        [self.switchThumbButton setBackgroundImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
        self.switchThumbButton.frame = CGRectMake(2, 2, self.frame.size.height-4, self.frame.size.height-4);
    }
}
-(void)changeThumbStateONwithAnimation1{
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.userInteractionEnabled = NO;
                         self.bgView.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#65bf81"];
                         self.bgView.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#6ec589"].CGColor;
                         
                         self.switchThumbButton.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#159c37"];
                         self.switchThumbButton.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#62bd7e"].CGColor;
                         
                         self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.switchThumbButton.frame.size.width, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isOn = YES;
                         if (self.delegateCTHSwitch && [self.delegateCTHSwitch respondsToSelector:@selector(switchStateChanged:)]) {
                             [self.delegateCTHSwitch switchStateChanged:self];
                         }
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.switchThumbButton.frame.size.width-3, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}
-(void)changeThumbStateOFFwithAnimation1{
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.userInteractionEnabled = NO;
                         self.bgView.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#c6c5c5"];
                         self.bgView.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#d2d2d2"].CGColor;
                         
                         self.switchThumbButton.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#f1f1f1"];
                         self.switchThumbButton.layer.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#d2d2d2"].CGColor;
                         
                         self.switchThumbButton.frame = CGRectMake(0, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.isOn = NO;
                         if (self.delegateCTHSwitch && [self.delegateCTHSwitch respondsToSelector:@selector(switchStateChanged:)]) {
                             [self.delegateCTHSwitch switchStateChanged:self];
                         }
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              self.switchThumbButton.frame = CGRectMake(3, (self.frame.size.height-self.switchThumbButton.frame.size.height)/2, self.switchThumbButton.frame.size.width, self.switchThumbButton.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}
-(void)changeThumbStateONwithAnimation2{
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.userInteractionEnabled = NO;
                         self.offImageView.hidden = YES;
                         self.onImageView.hidden = NO;
                         [self.switchThumbButton setBackgroundImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
                         self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height+4, 2, self.frame.size.height-4, self.frame.size.height-4);
                     }
                     completion:^(BOOL finished){
                         self.isOn = YES;
                         if (self.delegateCTHSwitch && [self.delegateCTHSwitch respondsToSelector:@selector(switchStateChanged:)]) {
                             [self.delegateCTHSwitch switchStateChanged:self];
                         }
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              self.switchThumbButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height+2, 2, self.frame.size.height-4, self.frame.size.height-4);
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}
-(void)changeThumbStateOFFwithAnimation2{
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.userInteractionEnabled = NO;
                         self.offImageView.hidden = NO;
                         self.onImageView.hidden = YES;
                         [self.switchThumbButton setBackgroundImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
                         self.switchThumbButton.frame = CGRectMake(-4, 2, self.frame.size.height-4, self.frame.size.height-4);
                     }
                     completion:^(BOOL finished){
                         self.isOn = NO;
                         if (self.delegateCTHSwitch && [self.delegateCTHSwitch respondsToSelector:@selector(switchStateChanged:)]) {
                             [self.delegateCTHSwitch switchStateChanged:self];
                         }
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              self.switchThumbButton.frame = CGRectMake(2, 2, self.frame.size.height-4, self.frame.size.height-4);
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}
- (void)setOn:(BOOL)on animated:(BOOL)animated{
    self.isOn = on;
    if([self.styleSwitch isEqualToString:@"1"]){
        if (self.isOn == YES) {
            [self changeThumbStateONwithAnimation1];
        }
        else {
            [self changeThumbStateOFFwithAnimation1];
        }
    }else{
        if (self.isOn == YES) {
            [self changeThumbStateONwithAnimation2];
        }
        else {
            [self changeThumbStateOFFwithAnimation2];
        }
    }
}
- (void)switchThumbTapped: (id)sender{
    if([self.styleSwitch isEqualToString:@"1"]){
        if (self.isOn == YES) {
            [self changeThumbStateOFFwithAnimation1];
            self.isOn = NO;
        }
        else {
            [self changeThumbStateONwithAnimation1];
            self.isOn = YES;
        }
    }else{
        if (self.isOn == YES) {
            [self changeThumbStateOFFwithAnimation2];
            self.isOn = NO;
        }
        else {
            [self changeThumbStateONwithAnimation2];
            self.isOn = YES;
        }
    }
    if (self.delegateCTHSwitch && [self.delegateCTHSwitch respondsToSelector:@selector(switchTapped:)]) {
        [self.delegateCTHSwitch switchTapped:self];
    }
}
@end
