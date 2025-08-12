#import "RefreshTableHeaderController.h"
@implementation RefreshTableHeaderController
-(void)viewDidLoad{
     [self.view updateConstraints];
     [self.view updateConstraintsIfNeeded];
     [self.view setNeedsLayout];
     [self.view layoutIfNeeded];
     if (self.tableView && self.tableView.tag!=1000){
          if (self.egoRefreshTableHeaderView == nil) {
               self.egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, CTHPlatform.getWidth, self.tableView.bounds.size.height)];
               self.egoRefreshTableHeaderView.delegate = self;
              [self.egoRefreshTableHeaderView setRefreshLang:[CTHLanguage language:@"release to refresh..." Text:@"Release to refresh..."]];
              [self.egoRefreshTableHeaderView setLoadingLang:[CTHLanguage language:@"loading..." Text:@"Loading..."]];
              [self.egoRefreshTableHeaderView setPullDownLang:[CTHLanguage language:@"pull down to refresh..." Text:@"Pull down to refresh..."]];
              
               [self.tableView addSubview:self.egoRefreshTableHeaderView];
               if(self.tableView.tag==-1){
                    UIView *view = (UIView*)[CTHHelper controlFromTag:0 withView:self.egoRefreshTableHeaderView kind:[UIView class]];
                    if(view != nil){
                         self.egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
                         view.backgroundColor = [UIColor clearColor];
                    }
               }
          }
          [self.egoRefreshTableHeaderView refreshLastUpdatedDate];
     }
}
-(void)initTableFooter{
     if (self.tableView && self.tableView.tag!=1000){
          if (self.loadMoreTableFooterView == nil){
               self.loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height,  CTHPlatform.getWidth, self.tableView.bounds.size.height)];
               self.loadMoreTableFooterView.delegate = self;
              [self.loadMoreTableFooterView setRefreshLang:[CTHLanguage language:@"release to load more..." Text:@"Release to load more..."]];
              [self.loadMoreTableFooterView setLoadingLang:[CTHLanguage language:@"loading more..." Text:@"Loading more..."]];
              [self.loadMoreTableFooterView setPullDownLang:[CTHLanguage language:@"pull up to load more..." Text:@"Pull up to load more..."]];
               [self.tableView addSubview:self.loadMoreTableFooterView];
          }
     }
}
-(void)updatePositionTableFooter{
     [self.tableView layoutIfNeeded];
     self.loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
     if(self.tableView.contentSize.height<=self.tableView.frame.size.height)
          self.loadMoreTableFooterView.hidden = YES;
     else
          self.loadMoreTableFooterView.hidden = NO;
}
-(NSInteger)getStatusTable{
     return [self.egoRefreshTableHeaderView getStatus];
}
-(void)reloadTableViewDataSource{
     self.reloading = YES;
}
-(void)loadMoreingTableViewDataSource{
     self.isLoadMoreing = YES;
}
-(void)doneLoadingTableViewData{
     self.reloading = NO;
     self.isLoadMoreing = NO;
     [self.egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
     if(self.loadMoreTableFooterView)
          [self.loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
     [self.tableView reloadData];
}
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if(self.loadMoreTableFooterView){
          self.loadMoreTableFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
          [self.loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
     }
     [self.egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
     if ([self respondsToSelector:@selector(scrollViewDidScroll)]){
          [self scrollViewDidScroll];
     }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     [self.egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
     [self.loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
     [self reloadTableViewDataSource];
     if ([self respondsToSelector:@selector(reloadTable)]){
          [self reloadTable];
     }
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
     return self.reloading;
}
#pragma mark LoadMoreTableFooterDelegate Methods
- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view{
     [self loadMoreingTableViewDataSource];
     if ([self respondsToSelector:@selector(reloadTableFooter)]){
          [self reloadTableFooter];
     }
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view{
     return self.isLoadMoreing;
}
@end

