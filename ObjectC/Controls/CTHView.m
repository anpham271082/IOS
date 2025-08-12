@implementation CTHView
-(void)layoutSubviews{
    [super layoutSubviews];
    [self reDrawing];
}
-(void)reDrawing{
    if(self.drawBorder==YES){
        self.clipsToBounds = YES;
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
        if(self.cornerRadius<0){
            if(self.cornerRadius==-2)
                self.layer.cornerRadius = self.frame.size.height/2;
            else
                self.layer.cornerRadius = self.frame.size.width/2;
        }
    }
    if(self.drawGradient==YES){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)self.gradientFromColor.CGColor, (id)self.gradientToColor.CGColor];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    if(self.drawOutlet==YES){
        if (!CGColorEqualToColor(self.outletColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.shadowColor = self.outletColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(self.shadowOffsetX, self.shadowOffsetY);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 10.0f;
        self.layer.masksToBounds = NO;
    }
    if(self.drawShadow==YES){
        if (!CGColorEqualToColor(self.shadowColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.shadowColor = self.shadowColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(self.shadowOffsetX, self.shadowOffsetY);
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowRadius = 2.0f;
        self.layer.masksToBounds = NO;
    }
    if(self.drawRadialGradient==YES){
        if(!self.radialGradientView){
            self.radialGradientView = [[CTHRadialGradientView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            self.radialGradientView.radialGradientFromColor = self.radialGradientFromColor;
            self.radialGradientView.radialGradientToColor = self.radialGradientToColor;
            [self addSubview:self.radialGradientView];
            [self updateMaskCorner];
        }
    }
}
-(void)updateRadialGradient{
    if(self.radialGradientView){
        self.radialGradientView.radialGradientFromColor = self.radialGradientFromColor;
        self.radialGradientView.radialGradientToColor = self.radialGradientToColor;
        [self.radialGradientView setNeedsDisplay];
    }
}
-(void)updateMaskCorner{
    self.layer.mask = nil;
    if(self.cornerMask == 1){
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopLeft cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.layer.mask = maskLayer;
    }else if(self.cornerMask == 4){
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerBottomLeft cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.layer.mask = maskLayer;
    }else if(self.cornerMask == 5){
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.layer.mask = maskLayer;
    }else if(self.cornerMask == 6){
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.layer.mask = maskLayer;
    }else if(self.cornerMask == 7){
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii: (CGSize){8.0, 8.0}].CGPath;
        self.layer.mask = maskLayer;
    }
}
@end
