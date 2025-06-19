#import <UIKit/UIKit.h>
@interface CTHLineChart : UIView
@property(assign)IBInspectable NSInteger fontStyle;
@property(assign)IBInspectable NSInteger chartStyle;
@property(strong, nonatomic)NSMutableArray *labelArray;
@property(strong, nonatomic)NSMutableArray *valueArray;
@property(assign) NSInteger cornerRadius;
-(void)reset;
-(void)drawDaily;
-(void)drawWeekly;
-(void)changeStyle:(NSInteger)style;
@end
