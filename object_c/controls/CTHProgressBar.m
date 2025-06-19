#import "CTHProgressBar.h"
@interface CTHProgressBar (){
@private
    CTHView *progressBar;
    CTHLabel *percentLabel;
}
@end
@implementation CTHProgressBar
-(void)layoutSubviews{
    [super layoutSubviews];
    [self drawBackground];
    [self drawProgress];
}
-(void)drawBackground{
    if(!progressBar){
        CTHView *background = [[CTHView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        background.backgroundColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#67282C"];
        background.cornerRadius = self.frame.size.height/2;
        background.borderWidth = 2;
        background.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#8A572E"];
        background.drawBorder = true;
        [self addSubview:background];
        
        
        progressBar = [[CTHView alloc] initWithFrame:CGRectMake(2, 2, 0, self.frame.size.height-4)];
        progressBar.clipsToBounds = YES;
        progressBar.cornerRadius = (self.frame.size.height-4)/2;
        progressBar.borderWidth = 1;
        progressBar.borderColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#E0A650"];
        progressBar.drawBorder = true;
        
        NSInteger width = CTHPlatform.getWidth/10;
        for (NSInteger i=0; i<10; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, self.frame.size.height-5)];
            imgView.image = [UIImage imageNamed:@"bg_animation_progress_bar"];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [progressBar addSubview:imgView];
        }
        
        percentLabel = [[CTHLabel alloc] initWithFrame:CGRectMake(progressBar.frame.size.width-55, 0, 50, self.frame.size.height-5)];
        percentLabel.font = [UIFont systemFontOfSize:7*CTHPlatform.getRatio];
        percentLabel.text = @"0";
        percentLabel.textColor = [CTHHelper colorFromHexString:[UIColor clearColor] HexString:@"#651B25"];
        percentLabel.textAlignment = NSTextAlignmentRight;
        //[CTHProgressBar addSubview:percentLabel];
        
        [self addSubview:progressBar];
    }
}
-(void)drawProgress{
    if(progressBar){
        if(self.progressValue<0)
            self.progressValue = 0;
        if(self.progressValue>self.maxProgressValue)
            self.progressValue = self.maxProgressValue;
        
        percentLabel.text = [CTHHelper getNumberFormatter:[NSNumber numberWithInteger:self.progressValue] NumberStyle:NSNumberFormatterDecimalStyle];
        CGFloat width = self.frame.size.width-4;
        CGFloat widthProgress = 0;
        widthProgress = self.progressValue*width/self.maxProgressValue;
        [CTHHelper animation:^{
            progressBar.frame = CGRectMake(progressBar.frame.origin.x, progressBar.frame.origin.y, widthProgress, progressBar.frame.size.height);
            percentLabel.frame = CGRectMake(progressBar.frame.size.width-55, 0, 50, self.frame.size.height-5);
        }];
    }
}
@end
