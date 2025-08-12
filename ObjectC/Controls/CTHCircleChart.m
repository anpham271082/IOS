#import "CTHCircleChart.h"
@implementation CTHCircleChart
- (void)awakeFromNib{
    self.startAnimation = 0;
    self.indexAnimation = 0;
    [super awakeFromNib];
}
-(void)drawAnimation{
    [self canPerformAction:@selector(drawAnimation) withSender:nil];
    if (self.indexAnimation<self.percent) {
        [self performSelector:@selector(drawAnimation) withObject:nil afterDelay:self.duration];
    }
    self.indexAnimation = self.indexAnimation+1;
    if(self.indexAnimation%5==0){
        self.startAnimation = self.startAnimation + 1;
    }
    if (self.indexAnimation>=self.percent){
        self.indexAnimation = self.percent;
        [self canPerformAction:@selector(drawAnimation) withSender:nil];
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [self drawLoading];
}
-(void)drawLoading{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0);
    UIImage *displayImageView = [UIImage imageNamed:@"ic_loading"];
    [displayImageView drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    if (self.indexAnimation>0){
        CGContextSetRGBStrokeColor(ctx, 32/255.f, 197/255.f, 81/255.f, 1.0f);
        CGContextSetLineWidth(ctx, 1);
        
        CGFloat radius = (self.frame.size.width-10)/2;
        CGFloat startAngle = - M_PI/2+self.startAnimation*2*M_PI/100.f;
        CGFloat endAngle =  - M_PI/2 +self.indexAnimation*2*M_PI/100.f;
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, startAngle, endAngle, 0);
        CGContextStrokePath(ctx);
    }
    if(self.indexAnimation>=100)
        self.indexAnimation = 0;
    if(self.startAnimation>=100)
        self.startAnimation = 0;
}
@end
