#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <STTwitter/STTwitter.h>
#import "Social/Social.h"
@implementation CTHSocial

+(void)loginFaceBook:(UIViewController*)viewController{
    FBSDKLoginManager *loginManager = [FBSDKLoginManager new];
    if(FBSDKAccessToken.currentAccessToken!=nil)
        [loginManager logOut];
    FBSDKLoginConfiguration *configuration = [[FBSDKLoginConfiguration alloc] initWithPermissions:@[@"email", @"public_profile", @"user_birthday", @"user_age_range", @"user_hometown", @"user_location", @"user_gender", @"user_link"] tracking:FBSDKLoginTrackingLimited nonce:@"123"];
    [loginManager logInFromViewController:viewController configuration:configuration
                  completion:^(FBSDKLoginManagerLoginResult * result, NSError *error) {
        if (!error && !result.isCancelled) {
            NSString *userID =
            FBSDKProfile.currentProfile.userID;

            NSString *idTokenString =
            FBSDKAuthenticationToken.currentAuthenticationToken.tokenString;

            NSString *email = FBSDKProfile.currentProfile.email;
        
            NSArray *friendIDs = FBSDKProfile.currentProfile.friendIDs;

            NSDate *birthday = FBSDKProfile.currentProfile.birthday;

            FBSDKUserAgeRange *ageRange = FBSDKProfile.currentProfile.ageRange;
        
            FBSDKLocation *hometown = FBSDKProfile.currentProfile.hometown;
        
            FBSDKLocation *location = FBSDKProfile.currentProfile.location;
        
            NSString *gender = FBSDKProfile.currentProfile.gender;
        
            NSURL *userLink = FBSDKProfile.currentProfile.linkURL;
        }
    }];
}
+(void)loginTwitter:(UIViewController*)viewController{
		STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"8RXSzFgZsPDwNYBGZbP4TtOU0"
													consumerSecret:@"lrVlOTM8jyazzYbSkxHBgJ8RE4YGcSpZqis0EaV8RB0r6428zl"];
		[twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
			// Mở Safari hoặc WebView để user đăng nhập Twitter tại URL này
			NSLog(@"Mở URL: %@", url.absoluteString);

			// Ví dụ: mở trình duyệt
			[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

		} oauthCallback:@"yourapp://oauth-callback/twitter" errorBlock:^(NSError *error) {
			NSLog(@"Lỗi lấy token request: %@", error.localizedDescription);
		}];
		/*STTwitterAPI *twitter
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
          NSLog(@"signed in as %@", [session userName]);
        } else {
          NSLog(@"error: %@", [error localizedDescription]);
        }
    }];*/
}
/*- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
	if ([url.scheme isEqualToString:@"yourapp"] && [url.host isEqualToString:@"oauth-callback"]) {
		
		NSString *query = url.query;
		NSDictionary *params = [self parametersDictionaryFromQuery:query];
		
		NSString *oauthVerifier = params[@"oauth_verifier"];

		[self.twitter postAccessTokenRequestWithPIN:oauthVerifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
			
			NSLog(@"Đăng nhập thành công - Tên: %@", screenName);
			// Lưu token nếu muốn gọi API

		} errorBlock:^(NSError *error) {
			NSLog(@"Lỗi xác thực: %@", error.localizedDescription);
		}];
		return YES;
	}

	return NO;
}*/

// Hàm phân tích URL query
- (NSDictionary *)parametersDictionaryFromQuery:(NSString *)query {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *components = [query componentsSeparatedByString:@"&"];
	for (NSString *component in components) {
		NSArray *pair = [component componentsSeparatedByString:@"="];
		if (pair.count == 2) {
			dict[pair[0]] = pair[1];
		}
	}
	return dict;
}

+(void)shareAppToFacebook:(UIViewController*)viewController{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *facebookViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookViewController setInitialText:@"facebook"];
        [facebookViewController addURL:[NSURL URLWithString:@"https://facebook.com"]];
        [facebookViewController addImage:[UIImage imageNamed:@"image"]];
        [facebookViewController setCompletionHandler:^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Compose Result: Canelled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Compose Result: Done");
                default:
                    break;
            }
        }];
        [viewController presentViewController:facebookViewController animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"SocialShare" message:@"You are not signed in to facebook."preferredStyle:UIAlertControllerStyleAlert];
        [viewController presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
    }
}
+(void)shareAppToTwitter:(UIViewController*)viewController{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterViewController setInitialText:@"twitter"];
        [twitterViewController addURL:[NSURL URLWithString:@"https://twitter.com"]];
        [twitterViewController addImage:[UIImage imageNamed:@"image"]];
        [twitterViewController setCompletionHandler:^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Compose Result: Canelled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Compose Result: Done");
                default:
                    break;
            }
        }];
        [viewController presentViewController:twitterViewController animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"SocialShare" message:@"You are not signed in to twitter."preferredStyle:UIAlertControllerStyleAlert];
         [viewController presentViewController:alertController animated:YES completion:nil];
         UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
         [alertController addAction:alertAction];
    }
}
@end
