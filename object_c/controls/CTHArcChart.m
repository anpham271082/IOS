#import "CTHHelper.h"
#import "CTHPlatform.h"
#import "CTHArcChart.h"
#import "CTHLanguage.h"
@implementation CTHArcChart
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2-6, 0, 2*M_PI, false);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:245/255.f green:255/255.f blue:0/255.f alpha:1].CGColor);
    CGContextSetLineWidth(context, 6);
    CGContextStrokePath(context);
    
    if([CTHPlatform is_iPad]){
        [CTHHelper drawText:CGPointMake(0, self.frame.size.height/2-30) FontStyle:2 FontSize:28*CTHPlatform.getRatio Width:self.frame.size.width Height:50 Alignment:NSTextAlignmentCenter Text:self.value Color:[UIColor whiteColor]];
        
        [CTHHelper drawText:CGPointMake(0, self.frame.size.height/2+20) FontStyle:2 FontSize:20*CTHPlatform.getRatio Width:self.frame.size.width Height:50 Alignment:NSTextAlignmentCenter Text:[CTHLanguage language:self.title.lowercaseString Text:self.title] Color:[UIColor whiteColor]];
    }else{
        [CTHHelper drawText:CGPointMake(0, self.frame.size.height/2-20) FontStyle:2 FontSize:22*CTHPlatform.getRatio Width:self.frame.size.width Height:40 Alignment:NSTextAlignmentCenter Text:self.value Color:[UIColor whiteColor]];
        
        [CTHHelper drawText:CGPointMake(0, self.frame.size.height/2+10) FontStyle:2 FontSize:13*CTHPlatform.getRatio Width:self.frame.size.width Height:40 Alignment:NSTextAlignmentCenter Text:[CTHLanguage language:self.title.lowercaseString Text:self.title] Color:[UIColor whiteColor]];
    }
}
@end
