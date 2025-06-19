#import <UIKit/UIKit.h>
@class SettingCell;
@protocol SettingCellDelegate <NSObject>
-(void)actionSetting:(SettingCell *)cell;
@end
@interface SettingCell : UITableViewCell
@property (weak) IBOutlet id<SettingCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet CTHLabel *settingLabel;
-(void)setSetting:(NSString*)text;
@end
