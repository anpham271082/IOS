#import "PopulationController.h"
#import "PopulationCell.h"
#import "PopulationModel.h"
@interface PopulationController ()<PopulationCellDelegate>{
@private
    NSMutableArray *array;
}
@end
@implementation PopulationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableFooter];
    [self.tableView reloadData];
    [self updatePositionTableFooter];
    [self loadData];
}
-(void)viewDidDisappear:(BOOL)animated{
}
-(void)loadData{
    if(!array){
        array = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [array removeAllObjects];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[CTHHelper sha256:CTHUserDefined.SECRET_KEY], @"X-CSRF-Token", @"iOS", @"Platform", nil];
    if (!self.connection)
        self.connection = [[CTHConnection alloc] init];
    [self.connection connectToServer:GET_METHOD UrlRequest:@"https://datausa.io/api/data?drilldowns=Nation&measures=Population" Header:header Body:nil ShowLoading:YES LocalDatabase:NO WithLocalDatabase:^(NSMutableDictionary *response, NSInteger status) {
    } WithComplete:^(NSMutableDictionary *response, NSInteger status) {
        for (NSMutableDictionary *dic in [response valueForKey:@"data"]) {
            PopulationModel *populationModel = [[PopulationModel alloc] init];
            populationModel = [populationModel initWithDictionary:dic];
            [self->array addObject:populationModel];
        }
        if([self->array count]>0)
            [self.tableView reloadData];
    } WithError:^{
    }];
}
-(void)reloadTable{
    [self performSelector:@selector(waitLoadData) withObject:nil afterDelay:0.01];
}
-(void)waitLoadData{
    [self doneLoadingTableViewData];
    [self.tableView reloadData];
    [self updatePositionTableFooter];
}
-(void)reloadTableFooter{
    [self performSelector:@selector(waitLoadData) withObject:nil afterDelay:0.01];
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
    PopulationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopulationCell"];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setPopulation:[array objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(CTHPlatform.is_iPad)
        return 60*CTHPlatform.getRatio;
    else
        return 70*CTHPlatform.getRatio;
}
-(void)actionPopulation:(PopulationCell *)cell{
    NSLog([NSString stringWithFormat:@"cell.tag: %d", cell.tag]);
}

@end
