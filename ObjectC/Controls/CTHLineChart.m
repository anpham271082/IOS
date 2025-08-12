#import "CTHHelper.h"
#import "CTHPlatform.h"
#import "CTHLineChart.h"
#import "CTHLanguage.h"
@implementation CTHLineChart
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    if(!self.labelArray){
        self.labelArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.valueArray = [[NSMutableArray alloc] initWithCapacity:0];
        CGFloat width = self.bounds.size.width;
        CGFloat distance = width/(9.5f);
        for (NSInteger i = 0; i<8; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.clipsToBounds = YES;
            if([CTHPlatform is_iPad]){
                label.layer.cornerRadius = (distance-56)/2;
            }else{
                label.layer.cornerRadius = (distance-12)/2;
            }
            //self.cornerRadius = (distance-12)/2;
            label.backgroundColor = [UIColor colorWithRed:245/255.f green:255/255.f blue:0/255.f alpha:1];
            [self.labelArray addObject:label];
            
        }
        [self reset];
    }
}
-(void)reset{
    [self.valueArray removeAllObjects];
    for (NSInteger i=0; i<8; i++) {
        [self.valueArray addObject:@"41"];
    }
}
- (void)drawRect:(CGRect)rect{
    if(self.chartStyle==0){
        [self drawDaily];
        [self drawValueDaily];
    }else{
        [self drawWeekly];
        [self drawValueWeekly];
    }
}
-(void)changeStyle:(NSInteger)style{
    self.chartStyle = style;
    [self setNeedsDisplay];
}
-(void)drawDaily{
    self.fontStyle = 2;
    //Draw time
    NSArray *timeArray = [NSArray arrayWithObjects:@"12A", @"3", @"6", @"9", @"12P", @"3", @"6", @"9", nil];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat distance = width/([timeArray count]+1.5f);
    CGFloat x = 5 + distance;
    CGFloat y = height-30;
    for (NSInteger i = 0; i<[timeArray count]; i++) {
        [CTHHelper drawText:CGPointMake(x, y+10) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:distance Height:20 Alignment:NSTextAlignmentCenter Text:[timeArray objectAtIndex:i] Color:[UIColor whiteColor]];
        /*if([[timeArray objectAtIndex:i] isEqualToString:@"12P"]){
            [CTHHelper drawText:CGPointMake(x, 5) FontStyle:self.fontStyle FontSize:11*CTHPlatform.getRatio Width:distance Height:40 Alignment:NSTextAlignmentCenter Text:@"MAX\n120" Color:[UIColor whiteColor]];
        }*/
        x = x + distance;
    }
    //Draw heartRate
    NSArray *heartRateArray = [NSArray arrayWithObjects:@"40", @"60", @"80", @"100", @"120", @"140", @"160", @"180", @"200", nil];
    distance = height/[heartRateArray count] - 5;
    for (NSInteger i = 0; i<[heartRateArray count]; i++) {
        if(i==0){
            [CTHHelper drawText:CGPointMake(0, y + 10) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:30 Height:20 Alignment:NSTextAlignmentCenter Text:[heartRateArray objectAtIndex:i] Color:[UIColor whiteColor]];
        }else{
            [CTHHelper drawText:CGPointMake(0, y) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:30 Height:20 Alignment:NSTextAlignmentCenter Text:[heartRateArray objectAtIndex:i] Color:[UIColor whiteColor]];
        }
        y = y - distance;
    }
    //Draw line
    y = height-25;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0, y);
    CGContextAddLineToPoint(context, width, y);
    
    CGContextMoveToPoint(context, 40, height);
    CGContextAddLineToPoint(context, 40, 30);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}
-(void)drawValueDaily{
    [CTHHelper removeAllSubviews:self];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat distance = width/(9.5f);
    CGFloat x = distance;
    CGFloat y = height-30;
    
    NSInteger indexMin = -1;
    NSInteger valueMin = 41;
    
    NSInteger indexMax = -1;
    NSInteger valueMax = 41;
    
    for (NSInteger i = 0; i<8; i++) {
        if([[self.valueArray objectAtIndex:i] intValue] > valueMax){
            indexMax = i;
            valueMax = [[self.valueArray objectAtIndex:i] intValue];
        }
    }
    
    if(indexMax>-1){
        valueMin = valueMax;
        for (NSInteger i = 0; i<8; i++) {
            if([[self.valueArray objectAtIndex:i] intValue] < valueMin && [[self.valueArray objectAtIndex:i] intValue] != 41){
                indexMin = i;
                valueMin = [[self.valueArray objectAtIndex:i] intValue];
            }
        }
        if(indexMin==valueMax){
            indexMin = -1;
            valueMin = 41;
        }
    }
    
    CGFloat distanceHeight = height/9.f - 8;
    for (NSInteger i = 0; i<8; i++) {
        if([CTHPlatform is_iPad]){
            UILabel *label = (UILabel*)[self.labelArray objectAtIndex:i];
            label.frame = CGRectMake(x+31, y, distance-52, -(([[self.valueArray objectAtIndex:i] intValue] - 40)* distanceHeight)/20.f);
            [self addSubview:label];
            
            if(indexMax == i){
                NSString *strMax = [CTHLanguage language:@"max\n" Text:@"MAX\n"];
                strMax = [strMax stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+12, y-(([[self.valueArray objectAtIndex:i] intValue]-20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:9*CTHPlatform.getRatio Width:distance-14 Height:50 Alignment:NSTextAlignmentCenter Text:strMax Color:[UIColor whiteColor]];
            }
            if(indexMin == i){
                NSString *strMin = [CTHLanguage language:@"min\n" Text:@"MIN\n"];
                strMin = [strMin stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+12, y-(([[self.valueArray objectAtIndex:i] intValue]-20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize: 9*CTHPlatform.getRatio Width:distance-14 Height:50 Alignment:NSTextAlignmentCenter Text:strMin Color:[UIColor whiteColor]];
            }
        }else{
            UILabel *label = (UILabel*)[self.labelArray objectAtIndex:i];
            label.frame = CGRectMake(x+12, y, distance-14, -(([[self.valueArray objectAtIndex:i] intValue] - 40)* distanceHeight)/20.f);
            [self addSubview:label];
            
            if(indexMax == i){
                NSString *strMax = [CTHLanguage language:@"max\n" Text:@"MAX\n"];
                strMax = [strMax stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+12, y-(([[self.valueArray objectAtIndex:i] intValue]-20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:7*CTHPlatform.getRatio Width:distance-14 Height:50 Alignment:NSTextAlignmentCenter Text:strMax Color:[UIColor whiteColor]];
            }
            if(indexMin == i){
                NSString *strMin = [CTHLanguage language:@"min\n" Text:@"MIN\n"];
                strMin = [strMin stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+12, y-(([[self.valueArray objectAtIndex:i] intValue]-20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:7*CTHPlatform.getRatio Width:distance-14 Height:50 Alignment:NSTextAlignmentCenter Text:strMin Color:[UIColor whiteColor]];
            }
        }
        x = x + distance;
    }
}
//Weekly
-(void)drawWeekly{
    self.fontStyle = 2;
    //Draw time
    NSArray *dayArray = [NSArray arrayWithObjects:[CTHLanguage language:@"sun" Text:@"SUN"], [CTHLanguage language:@"mon" Text:@"MON"], [CTHLanguage language:@"tue" Text:@"TUE"], [CTHLanguage language:@"wed" Text:@"WED"], [CTHLanguage language:@"thu" Text:@"THU"], [CTHLanguage language:@"fri" Text:@"FRI"], [CTHLanguage language:@"sat" Text:@"SAT"], nil];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat distance = width/([dayArray count]+1.5f);
    CGFloat x = 5 + distance;
    CGFloat y = height-30;
    for (NSInteger i = 0; i<[dayArray count]; i++) {
        [CTHHelper drawText:CGPointMake(x, y+10) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:distance Height:20 Alignment:NSTextAlignmentCenter Text:[dayArray objectAtIndex:i] Color:[UIColor whiteColor]];
        x = x + distance;
    }
    //Draw heartRate
    NSArray *heartRateArray = [NSArray arrayWithObjects:@"40", @"60", @"80", @"100", @"120", @"140", @"160", @"180", @"200", nil];
    distance = height/[heartRateArray count] - 5;
    for (NSInteger i = 0; i<[heartRateArray count]; i++) {
        if(i==0){
            [CTHHelper drawText:CGPointMake(0, y + 10) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:30 Height:20 Alignment:NSTextAlignmentCenter Text:[heartRateArray objectAtIndex:i] Color:[UIColor whiteColor]];
        }else{
            [CTHHelper drawText:CGPointMake(0, y) FontStyle:self.fontStyle FontSize:10*CTHPlatform.getRatio Width:30 Height:20 Alignment:NSTextAlignmentCenter Text:[heartRateArray objectAtIndex:i] Color:[UIColor whiteColor]];
        }
        y = y - distance;
    }
    //Draw line
    y = height-25;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0, y);
    CGContextAddLineToPoint(context, width, y);
    
    CGContextMoveToPoint(context, 40, height);
    CGContextAddLineToPoint(context, 40, 30);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}
-(void)drawValueWeekly{
    [CTHHelper removeAllSubviews:self];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat distance = width/(8.5f);
    CGFloat x = distance;
    CGFloat y = height-30;
    
    NSInteger indexMin = -1;
    NSInteger valueMin = 41;
    
    NSInteger indexMax = -1;
    NSInteger valueMax = 41;
    
    for (NSInteger i = 0; i<7; i++) {
        if([[self.valueArray objectAtIndex:i] intValue] > valueMax){
            indexMax = i;
            valueMax = [[self.valueArray objectAtIndex:i] intValue];
        }
    }
    
    if(indexMax>-1){
        valueMin = valueMax;
        for (NSInteger i = 0; i<8; i++) {
            if([[self.valueArray objectAtIndex:i] intValue] < valueMin && [[self.valueArray objectAtIndex:i] intValue] != 41){
                indexMin = i;
                valueMin = [[self.valueArray objectAtIndex:i] intValue];
            }
        }
        if(indexMin==valueMax){
            indexMin = -1;
            valueMin = 41;
        }
    }
    
    CGFloat distanceHeight = height/9.f - 8;
    for (NSInteger i = 0; i<7; i++) {
        if([CTHPlatform is_iPad]){
            UILabel *label = (UILabel*)[self.labelArray objectAtIndex:i];
            label.frame = CGRectMake(x+36, y, distance-62, -(([[self.valueArray objectAtIndex:i] intValue] - 40)* distanceHeight)/20.f);
            [self addSubview:label];
            
            if(indexMax == i){
                NSString *strMax = [CTHLanguage language:@"max\n" Text:@"MAX\n"];
                strMax = [strMax stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+14, y-(([[self.valueArray objectAtIndex:i] intValue] - 20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:9*CTHPlatform.getRatio Width:distance-10 Height:50 Alignment:NSTextAlignmentCenter Text:strMax Color:[UIColor whiteColor]];
            }
            if(indexMin == i){
                NSString *strMin = [CTHLanguage language:@"min\n" Text:@"MIN\n"];
                strMin = [strMin stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+14, y-(([[self.valueArray objectAtIndex:i] intValue] - 20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:0*CTHPlatform.getRatio Width:distance-10 Height:50 Alignment:NSTextAlignmentCenter Text:strMin Color:[UIColor whiteColor]];
            }
        }else{
            UILabel *label = (UILabel*)[self.labelArray objectAtIndex:i];
            label.frame = CGRectMake(x+14, y, distance-18, -(([[self.valueArray objectAtIndex:i] intValue] - 40)* distanceHeight)/20.f);
            [self addSubview:label];
            
            if(indexMax == i){
                NSString *strMax = [CTHLanguage language:@"max\n" Text:@"MAX\n"];
                strMax = [strMax stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+14, y-(([[self.valueArray objectAtIndex:i] intValue] - 20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:7*CTHPlatform.getRatio Width:distance-18 Height:50 Alignment:NSTextAlignmentCenter Text:strMax Color:[UIColor whiteColor]];
            }
            if(indexMin == i){
                NSString *strMin = [CTHLanguage language:@"min\n" Text:@"MIN\n"];
                strMin = [strMin stringByAppendingString:[NSString stringWithFormat:@"%@", [self.valueArray objectAtIndex:i]]];
                [CTHHelper drawText:CGPointMake(x+14, y-(([[self.valueArray objectAtIndex:i] intValue] - 20*CTHPlatform.getRatio)* distanceHeight)/20.f) FontStyle:self.fontStyle FontSize:7*CTHPlatform.getRatio Width:distance-18 Height:50 Alignment:NSTextAlignmentCenter Text:strMin Color:[UIColor whiteColor]];
            }
        }
        x = x + distance;
    }
}
@end
