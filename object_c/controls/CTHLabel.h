#import <UIKit/UIKit.h>
@class CTHLabel;
@protocol CTHLabelDelegate <NSObject>
@optional
-(void)handleTap:(CTHLabel*)label Result:(NSString*)result;
@end
IB_DESIGNABLE
@interface CTHLabel : UILabel
@property (weak) IBOutlet id delegate;
@property(copy)IBInspectable NSString *langLabel;
@property(copy)IBInspectable NSString *defaultColor;
@property(assign)IBInspectable NSInteger fontStyleLabel;
@property(assign)IBInspectable NSInteger borderWidth;
@property(assign)IBInspectable CGFloat cornerRadius;
@property(strong, nonatomic)IBInspectable UIColor *borderColor;
@property(copy)IBInspectable NSString *attributedString;
@property(copy)IBInspectable NSString *colorAttributedString;
@property(copy)IBInspectable NSString *underlineAttributedString;
@property(copy)IBInspectable NSString *fontAttributedString;
@property IBInspectable BOOL drawBorder;
@property IBInspectable BOOL drawAttributedString;
@property IBInspectable BOOL drawAttributedStringIncreaseSizeFont;
@property IBInspectable BOOL lineHeightMultiple;
@property(assign) NSInteger fontSizeLabel;
@property(assign)IBInspectable CGFloat valueLineHeight;
@property(copy)IBInspectable NSString *valueString;
-(void)initialAttributedString;
-(void)initialAttributedStringRedeem;
-(void)changeFont;
-(NSString*)trimming;
-(NSInteger)getFontSize;
-(void)setFontSize:(NSInteger)size;
-(void)changeText:(NSString*)str;
-(void)changeTextLineHeight:(NSString*)str LineHeight:(CGFloat)lineHeight;
@end
