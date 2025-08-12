#import <Foundation/Foundation.h>
#define POST_METHOD @"POST"
#define PUT_METHOD @"PUT"
#define GET_METHOD @"GET"
#define DELETE_METHOD @"DELETE"
#define STATUS_SUCCESS 200
#define STATUS_NO_SUCCESS 400
#define STATUS_EXPIRED_TOKEN 401
@interface CTHBaseApi : NSObject
+(NSString*)API_GIGYA_SIGN_IN;
+(NSString*)API_GIGYA_SIGN_UP;
+(NSString*)API_GIGYA_CHECK_CONFLICK_ACCOUNT;
+(NSString*)API_GIGYA_LINK_ACCOUNT;
+(NSString*)API_COUNTRIES;
+(NSString*)API_CONFIG;
+(NSString*)API_STATIC_CONTENT;
+(NSString*)API_LINK_ACCOUNT;
+(NSString*)API_REFRESH_TOKEN:(NSString*)token;
+(NSString*)API_LOGOUT;
+(NSString*)API_SIGN_IN;
+(NSString*)API_SIGN_UP;
+(NSString*)API_FORGOT_PASSWORD;
+(NSString*)API_RESEND_EMAIL;
+(NSString*)API_CHECK_PINCODE;
+(NSString*)API_FORGOT_PINCODE;
+(NSString*)API_CHANGE_PASSWORD;
+(NSString*)API_GET_USER;
+(NSString*)API_KID_LIST;
+(NSString*)API_KID_ADD;
+(NSString*)API_KID_DETAIL:(NSInteger)kid_id;
+(NSString*)API_KID_DELETE:(NSInteger)kid_id;
+(NSString*)API_KID_EDIT:(NSInteger)kid_id;
+(NSString*)API_AVATAR;
+(NSString*)API_SAVE_AVATAR;
+(NSString*)API_TEAM_NAME;
+(NSString*)API_FRIEND_LIST;
+(NSString*)API_SEARCH_FRIEND;
+(NSString*)API_ADD_FRIEND;
+(NSString*)API_TASKS;
+(NSString*)API_CONFIRM_ALL_TASKS;
+(NSString*)API_UPDATE_TASK_STATUS:(NSInteger)task_id;
+(NSString*)API_SELF_ASSESSMENT:(NSInteger)kid_id;
+(NSString*)API_KID_LESSONS:(NSInteger)kid_id;
+(NSString*)API_KID_EXERCISE:(NSInteger)kid_id;
+(NSString*)API_KID_EXERCISE_RATING:(NSInteger)kid_id;
+(NSString*)API_USER_CHALLENGES:(NSString*)type;
+(NSString*)API_KID_CHALLENGES:(NSInteger)kid_id Type:(NSString*)type;
+(NSString*)API_KID_SUBMIT_CHALLENGES:(NSInteger)kid_id ChallengeId:(NSInteger)challengeId;
+(NSString*)API_KID_BAND_CHALLENGES:(NSInteger)kid_id;
+(NSString*)API_KID_SUBMIT_BAND_CHALLENGE:(NSInteger)kid_id;
+(NSString*)API_KID_ACTIVATION:(NSInteger)kid_id;
+(NSString*)API_KID_SUBMIT_REWARD:(NSInteger)kid_id;
+(NSString*)API_KID_SUBMIT_CHALLENGE:(NSInteger)kid_id;
+(NSString*)API_KID_BADGES:(NSInteger)kid_id;
+(NSString*)API_KID_LEADERBOARD:(NSInteger)kid_id Type:(NSString*)type Page:(NSInteger)page Total:(NSInteger)total;
+(NSString*)API_KID_SUBMIT_AVATAR:(NSInteger)kid_id;
+(NSString*)API_KID_SUBMIT_BAND:(NSInteger)kid_id Type:(NSInteger)type;
+(NSString*)API_KID_GET_BAND:(NSInteger)kid_id Type:(NSString*)type Timestamp:(NSInteger)timestamp Total:(NSInteger)total;
+(NSString*)API_KID_SAVE_BAND:(NSInteger)kid_id;
+(NSString*)API_EVENTS:(NSInteger)page Total:(NSInteger)total;
+(NSString*)API_EVENTS_MONTH:(NSInteger)page Total:(NSInteger)total Month:(NSString*)month;
+(NSString*)API_BAND_TIME;
+(NSString*)API_KID_QUESTIONAIRE_POINT:(NSInteger)kid_id;
+(NSString*)API_KID_CLAIMS:(NSInteger)kid_id;
+(NSString*)API_NOTIFICATION;
+(NSString*)API_START_LESSON_CHALLENGES:(NSInteger)kid_id Type:(NSString*)type;
+(NSString*)API_CHECK_POINT:(NSInteger)kid_id;
+(NSString*)API_ECAMP_POINT;
+(NSString*)API_ECAMP_BANNER;
+(NSString*)API_ECAMP_PROMOTION;
+(NSString*)API_REWARDS_LIST;
+(NSString*)API_MY_REWARDS;
+(NSString*)API_LOCATION;
+(NSString*)API_QRCode;
+(NSString*)API_REDEEM;
+(NSString*)API_SUBMIT_SURVEY;
@end
