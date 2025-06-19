#import "SettingController.h"
#import "SettingCell.h"
@interface SettingController ()<SettingCellDelegate>{
@private
    NSMutableArray *array;
}
@end
@implementation SettingController
- (void)viewDidLoad {
    [super viewDidLoad];
    if(!array){
        array = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [array addObject:@"Login FaceBook"];
    [array addObject:@"Login Twitter"];
    [array addObject:@"Share AppTo Facebook"];
    [array addObject:@"Share AppTo Twitter"];
    [self.settingTableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setSetting:[array objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)actionSetting:(SettingCell *)cell{
    switch (cell.tag){
        case 0:
            [CTHSocial loginFaceBook:self];
            break;
        case 1:
            [CTHSocial loginTwitter:self];
            break;
        case 2:
            [CTHSocial shareAppToFacebook:self];
            break;
        case 3:
            [CTHSocial shareAppToTwitter:self];
            break;
    }
    NSLog([NSString stringWithFormat:@"cell.tag: %d", cell.tag]);
}
@end
