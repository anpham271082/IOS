#import "CTHImageView.h"
#import "CTHFont.h"
#import "CTHHelper.h"
#import "CTHSlideIndicate.h"
@implementation CTHSlideIndicate
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    if(!self.trackImageView){
        self.distance = 20;
        NSInteger width = 14;
        NSInteger height = 80;
        CTHView *view = [[CTHView alloc] initWithFrame:CGRectMake(-width/2+self.distance, self.frame.size.height - width, width, width)];
        view.cornerRadius = width/2;
        view.drawBorder = YES;
        view.backgroundColor = [UIColor colorWithRed:0 green:130/255.f blue:101/255.f alpha:1];
        [self addSubview:view];
        
        view = [[CTHView alloc] initWithFrame:CGRectMake(self.frame.size.width - width/2-self.distance, self.frame.size.height - width, width, width)];
        view.cornerRadius = width/2;
        view.drawBorder = YES;
        view.backgroundColor = [UIColor colorWithRed:0 green:130/255.f blue:101/255.f alpha:1];
        [self addSubview:view];
        
        view = [[CTHView alloc] initWithFrame:CGRectMake(7+self.distance, self.frame.size.height - 8, self.frame.size.width-14-2*self.distance, 3)];
        view.backgroundColor = [UIColor colorWithRed:0 green:130/255.f blue:101/255.f alpha:1];
        [self addSubview:view];
        
        width = 40;
        self.trackView = [[CTHView alloc] initWithFrame:CGRectMake(-width/2+self.distance, self.frame.size.height - height, width, height)];
        self.trackImageView = [[CTHImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.trackImageView.image = [UIImage imageNamed:@"ic_track"];
        [self.trackView addSubview:self.trackImageView];
        
        self.valueLabel = [[CTHLabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        self.valueLabel.text = @"0";
        self.valueLabel.fontSizeLabel = 16;
        self.valueLabel.font = [UIFont fontWithName:[CTHFont fontName:self.valueLabel.fontStyleLabel] size:self.valueLabel.fontSizeLabel];
        self.valueLabel.fontStyleLabel = 2;
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        [self.trackView addSubview:self.valueLabel];
        
        [self addSubview:self.trackView];
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self.trackView addGestureRecognizer:panGesture];
        [self addSubview:self.trackView];
    }
}
- (void)panGesture:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation = [recognizer translationInView:self.trackView];
    if((self.trackView.frame.origin.x + translation.x)>=(-self.trackView.frame.size.width/2+self.distance)&&(self.trackView.frame.origin.x + translation.x)<=(self.frame.size.width-self.trackView.frame.size.width)){
        self.trackView.frame = CGRectMake(self.trackView.frame.origin.x + translation.x, self.trackView.frame.origin.y, self.trackView.frame.size.width, self.trackView.frame.size.height);
        NSInteger width = self.frame.size.width - 2*self.distance;
        NSInteger x = self.trackView.frame.origin.x;
        if(self.trackView.frame.origin.x==0){
            self.valueLabel.text = @"0";
        }else if(self.trackView.frame.origin.x==width){
            self.valueLabel.text = [CTHHelper getNumberFormatter:[NSNumber numberWithInteger:self.maximum] NumberStyle:NSNumberFormatterDecimalStyle];
        }else{
            self.valueLabel.text = [CTHHelper getNumberFormatter:[NSNumber numberWithInteger:(x*self.maximum)/width] NumberStyle:NSNumberFormatterDecimalStyle];
        }
    }
    [recognizer setTranslation: CGPointZero inView:self.trackView];
}
@end
