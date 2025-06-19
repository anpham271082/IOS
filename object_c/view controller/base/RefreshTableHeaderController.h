#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
@interface RefreshTableHeaderController : UIViewController<EGORefreshTableHeaderDelegate, LoadMoreTableFooterDelegate>
@property (strong, nonatomic) EGORefreshTableHeaderView *egoRefreshTableHeaderView;
@property (strong, nonatomic) LoadMoreTableFooterView *loadMoreTableFooterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign) BOOL reloading;
@property (assign) BOOL isLoadMoreing;
-(NSInteger)getStatusTable;

-(void)initTableFooter;

-(void)updatePositionTableFooter;

-(void)reloadTable;

-(void)reloadTableFooter;

-(void)doneLoadingTableViewData;

-(void)scrollViewDidScroll;
@end
