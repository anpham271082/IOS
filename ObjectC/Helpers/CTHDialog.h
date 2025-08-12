#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CTHDialog;
@protocol CTHDialogDelegate <NSObject>
-(void)alertView:(NSInteger)buttonIndex;
-(void)photoCompleted:(CTHDialog *)object;
-(void)actionAvatar:(CTHDialog *)object;
-(void)dialogOkCompleted:(CTHDialog *)object;
-(void)dialogYesCompleted:(CTHDialog *)object;
-(void)dialogNoCompleted:(CTHDialog *)object;
@end
@interface CTHDialog : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (assign) NSInteger intTag;
+(instancetype)sharedInstance;
@property (weak) id  delegate;
-(void)alert:(id)delegate Title:(NSString*)title Message:(NSString*)message ActionArray:(NSArray*)actionArray;
-(void)showDialogOk:(id)delegate Title:(NSString*)title Message:(NSString*)message TextOk:(NSString*)textOk;
-(void)showDialogYesNo:(id)delegate Title:(NSString*)title Message:(NSString*)message TextYes:(NSString*)textYes TextNo:(NSString*)textNo;
-(void)showBlackDialogOk:(id)delegate Message:(NSString*)message TextOk:(NSString*)textOk;
-(void)hideDialog;
-(void)showLoading;
-(void)showReconnecting;
-(void)showSynchronizing;
-(void)showLoadingAlways;
-(void)hideLoading;
-(void)waitShowLoading;
-(void)actionCamera:(id)delegate;
-(void)clearImages;
-(void)showIndicatorView:(UIControl*)control Color:(UIColor*)color;
-(void)hideIndicatorView:(UIControl*)control;
@end
