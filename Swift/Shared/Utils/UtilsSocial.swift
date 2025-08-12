import Foundation
import FBSDKLoginKit
import Social
import STTwitter
//import TwitterKit
struct UtilsSocial {
    static public func loginFacebook(_ viewController: UIViewController) {
        let loginManager = LoginManager()
        guard let configuration = LoginConfiguration(
            permissions:["email", "user_friends", "user_birthday", "user_age_range", "user_gender", "user_location", "user_hometown", "user_link"],
            tracking: .limited,
            nonce: "123"
        )
        else {
            return
        }
        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .cancelled, .failed:
                break
            case .success:
                let userID = Profile.current?.userID
                let email = Profile.current?.email
                let friendIDs = Profile.current?.friendIDs
                let birthday = Profile.current?.birthday
                let ageRange = Profile.current?.ageRange
                let gender = Profile.current?.gender
                let location = Profile.current?.location
                let hometown = Profile.current?.hometown
                let profileURL = Profile.current?.linkURL
                let tokenString = AuthenticationToken.current?.tokenString
            }
        }
    }
    static public func loginTwitter(_ viewController: UIViewController) {
		/*var twitter: STTwitterAPI = STTwitterAPI(oAuthConsumerKey: "8RXSzFgZsPDwNYBGZbP4TtOU0",
									  consumerSecret: "lrVlOTM8jyazzYbSkxHBgJ8RE4YGcSpZqis0EaV8RB0r6428zl")
		twitter.postTokenRequest(oauthCallback: "yourapp://oauth-callback/twitter",
										 successBlock: { [weak self] url, oauthToken in
				   if let url = url {
					   UIApplication.shared.open(url, options: [:], completionHandler: nil)
				   }
			   }, errorBlock: { error in
				   print("Error getting request token: \(error?.localizedDescription ?? "unknown error")")
			   })*/
        /*TWTRTwitter.sharedInstance().logIn(with: viewController) { (session, error) in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }*/
        /*TWTRTwitter.sharedInstance().logIn(with:viewController completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })*/
    }
    static public func shareAppToFacebook(_ viewController: UIViewController) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)){
            let facebookViewController = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
            facebookViewController?.setInitialText("facebook")
            facebookViewController?.add(URL(string:"https://facebook.com"))
            facebookViewController?.add(UIImage(named: "image"))
            facebookViewController?.completionHandler = { result in
                if (result == SLComposeViewControllerResult.done) {
                }else {
                }
            }
            viewController.present(facebookViewController!, animated: true, completion: nil)
        }
    }
    static public func shareAppToTwitter(_ viewController: UIViewController) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
            let twitterViewController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            twitterViewController?.setInitialText("twitter")
            twitterViewController?.add(URL(string:"https://twitter.com"))
            twitterViewController?.add(UIImage(named: "image"))
            twitterViewController?.completionHandler = { result in
                if (result == SLComposeViewControllerResult.done) {
                }else {
                }
            }
            viewController.present(twitterViewController!, animated: true, completion: nil)
        }
    }
}
