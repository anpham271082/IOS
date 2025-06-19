#import <UIKit/UIKit.h>
#import "ProcessKeyboardController.h"
@interface ViewController : ProcessKeyboardController
@property (strong, nonatomic) CTHConnection *connection;
@property (weak, nonatomic) IBOutlet CTHView *headerView;
@property (weak, nonatomic) IBOutlet CTHView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *snapshotImageView;
@property (copy, nonatomic) void (^ callbackSnapShotComplete)(void);
-(void)snapShot:(void(^)(void))callComplete;
-(void)didLayoutSubviews;
@end

