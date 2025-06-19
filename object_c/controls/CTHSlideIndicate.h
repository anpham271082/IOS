@interface CTHSlideIndicate : UIControl
@property(strong, nonatomic) CTHView *trackView;
@property(strong, nonatomic) UIImageView *trackImageView;
@property(strong, nonatomic) CTHLabel *valueLabel;
@property(assign) IBInspectable NSInteger maximum;
@property(assign) NSInteger distance;
@property(assign) CGPoint startTouchPosition;
@property(assign) BOOL startEnable;
@end
