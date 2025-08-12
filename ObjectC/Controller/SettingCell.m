#import "SettingCell.h"
@implementation SettingCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setSetting:(NSString*)text{
    self.textLabel.text = text;
}
-(IBAction)actionSetting:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSetting:)]) {
        [self.delegate actionSetting:self];
    }
}
@end
