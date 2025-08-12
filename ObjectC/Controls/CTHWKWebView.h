#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class CTHWKWebView;
@protocol CTHWKWebViewDelegate <NSObject>
@optional
-(void)didFinishNavigation:(CTHWKWebView*)webView;
-(void)didFailNavigation:(CTHWKWebView*)webView;
@end
@interface CTHWKWebView : WKWebView<WKNavigationDelegate>
@property (weak) IBOutlet id delegate;
-(void)loadRequestFromLink:(NSString*)strURL;
-(void)setHTML:(NSString*)str CSSName:(NSString*)name ScrollEnabled:(BOOL)scrollEnabled;
-(void)clear;
@end
