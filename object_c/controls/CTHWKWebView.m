@implementation CTHWKWebView
-(void)setHTML:(NSString*)str CSSName:(NSString*)name ScrollEnabled:(BOOL)scrollEnabled{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            scrollView.scrollEnabled = scrollEnabled;
        }
    }
    NSString *html =[NSString stringWithFormat:@"<html><meta name=\"viewport\" content=\"initial-scale=1.0\"/><head>"
                     "<link rel=\"stylesheet\" type=\"text/css\" href=\"%@.css\"><body>"
                     "<h1>%@</h1></body></html>", name, str];
    [self loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"css"]]];
    self.navigationDelegate = self;
}
-(void)loadRequestFromLink:(NSString*)strURL{
    NSURL *nsUrl = [NSURL URLWithString:strURL];
    NSURLRequest *nsRequest=[NSURLRequest requestWithURL:nsUrl];
    self.navigationDelegate = self;
    [self loadRequest:nsRequest];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [CTHHelper animation:^{
        self.alpha = 1;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishNavigation:)]) {
        [self.delegate didFinishNavigation:self];
    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [CTHHelper animation:^{
        self.alpha = 1;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailNavigation:)]) {
        [self.delegate didFinishNavigation:self];
    }
}
-(void)clear{
    [self setNavigationDelegate:nil];
    [self setUIDelegate:nil];
    [self setNavigationDelegate:nil];
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self removeFromSuperview];
}
@end
