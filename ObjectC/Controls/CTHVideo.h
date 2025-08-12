#import <UIKit/UIKit.h>
@class CTHVideo;
@protocol CTHVideoDelegate <NSObject>
-(void)webViewDidFinishLoad:(CTHVideo *)video;
-(void)youTubePlayed:(CTHVideo *)video;
@end
@interface CTHVideo : UIView<WKNavigationDelegate, WKUIDelegate>
@property (weak) IBOutlet id<CTHVideoDelegate> delegate;
@property (assign) BOOL closeVideo;
-(void)initVideo;
-(void)play:(NSString*)youtubeId;
-(void)clear;
@end
