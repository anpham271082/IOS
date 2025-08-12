#import "CTHBaseApi.h"
#define API_KID @"/user/%@/kid"
@implementation CTHBaseApi
+(NSString*)API_GIGYA_SIGN_IN{
    return @"";
    //return [NSString stringWithFormat:@"%@/social-sign-in", [CountryModel sharedInstance].url];
}
+(NSString*)API_GIGYA_SIGN_UP{
    return @"";
    //return [NSString stringWithFormat:@"%@/social-sign-up", [CountryModel sharedInstance].url];
}
+(NSString*)API_GIGYA_CHECK_CONFLICK_ACCOUNT{
    return @"";
    //return [NSString stringWithFormat:@"%@/check-conflicting-account", [CountryModel sharedInstance].url];
}
+(NSString*)API_GIGYA_LINK_ACCOUNT{
    return @"";
    //return [NSString stringWithFormat:@"%@/link-account", [CountryModel sharedInstance].url];
}
+(NSString*)API_COUNTRIES{
    return @"";
    //return [CTHUserDefined.LINK_PRO_APP stringByAppendingString:@"countries"];
}
+(NSString*)API_CONFIG{
    return @"";
    //return [NSString stringWithFormat:@"%@/config", [CountryModel sharedInstance].url];
}
+(NSString*)API_STATIC_CONTENT{
    return @"";
    //return [NSString stringWithFormat:@"%@/static-content", [CountryModel sharedInstance].url];
}
+(NSString*)API_LINK_ACCOUNT{
    return @"";
    //return [NSString stringWithFormat:@"%@/user", [CountryModel sharedInstance].url];
}
+(NSString*)API_REFRESH_TOKEN:(NSString*)token{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/refresh-token", [CountryModel sharedInstance].url, token];
}
+(NSString*)API_LOGOUT{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/logout", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_SIGN_IN{
    return @"";
    //return [NSString stringWithFormat:@"%@/sign-in", [CountryModel sharedInstance].url];
}
+(NSString*)API_SIGN_UP{
    return @"";
    //return [NSString stringWithFormat:@"%@/sign-up", [CountryModel sharedInstance].url];
}
+(NSString*)API_FORGOT_PASSWORD{
    return @"";
    //return [NSString stringWithFormat:@"%@/forgot-password", [CountryModel sharedInstance].url];
}
+(NSString*)API_RESEND_EMAIL{
    return @"";
    //return [NSString stringWithFormat:@"%@/resend-email", [CountryModel sharedInstance].url];
}
+(NSString*)API_CHECK_PINCODE{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/check-pin", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_FORGOT_PINCODE{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/forgot-pin", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_CHANGE_PASSWORD{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/change-password", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_GET_USER{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_KID_LIST{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kids", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_KID_ADD{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_KID_DETAIL:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_DELETE:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_EDIT:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_AVATAR{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/avatars", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_SAVE_AVATAR{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/avatar", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_TEAM_NAME{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/team-name", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_FRIEND_LIST{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/friends", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_SEARCH_FRIEND{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/search-friends", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_ADD_FRIEND{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/friend", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], [KidModel sharedInstance].kid_id];
}
+(NSString*)API_TASKS{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/tasks", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_CONFIRM_ALL_TASKS{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/tasks/confirm-all", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_UPDATE_TASK_STATUS:(NSInteger)task_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/task/%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], task_id];
}
+(NSString*)API_SELF_ASSESSMENT:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/self-assessment", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_LESSONS:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/lessons", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_EXERCISE:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/exercise", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_EXERCISE_RATING:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/lesson", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_USER_CHALLENGES:(NSString*)type{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/challenges?type=%@", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], type];
}
+(NSString*)API_KID_CHALLENGES:(NSInteger)kid_id Type:(NSString*)type{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/challenges?type=%@", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, type];
}
+(NSString*)API_KID_SUBMIT_CHALLENGES:(NSInteger)kid_id ChallengeId:(NSInteger)challengeId{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/challenge/%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, challengeId];
}
+(NSString*)API_KID_BAND_CHALLENGES:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/band-challenges", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_SUBMIT_BAND_CHALLENGE:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/band-challenge", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_ACTIVATION:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/activation", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_SUBMIT_REWARD:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/reward", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_SUBMIT_CHALLENGE:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/challenge", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_BADGES:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/badges", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_LEADERBOARD:(NSInteger)kid_id Type:(NSString*)type Page:(NSInteger)page Total:(NSInteger)total{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/leaderboards?type=%@&page=%ld&total=%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, type, page, total];
}
+(NSString*)API_KID_SUBMIT_AVATAR:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/avatar-icon", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_SUBMIT_BAND:(NSInteger)kid_id Type:(NSInteger)type{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/band?version=%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, type];
}
+(NSString*)API_KID_GET_BAND:(NSInteger)kid_id Type:(NSString*)type Timestamp:(NSInteger)timestamp Total:(NSInteger)total{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/band?type=%@&start_at=%ld&total=%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, type, timestamp, total];
}
+(NSString*)API_KID_SAVE_BAND:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/band", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_EVENTS:(NSInteger)page Total:(NSInteger)total{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/events?start=%ld&total=%ld", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], page, total];
}
+(NSString*)API_EVENTS_MONTH:(NSInteger)page Total:(NSInteger)total Month:(NSString*)month{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/events?start=%ld&total=%ld&month=%@", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], page, total, month];
}
+(NSString*)API_BAND_TIME{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/band", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_KID_QUESTIONAIRE_POINT:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/questionnaire-point", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_KID_CLAIMS:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/claims", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_NOTIFICATION{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/notification", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_START_LESSON_CHALLENGES:(NSInteger)kid_id Type:(NSString*)type{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/start-lesson-challenges?type=%@", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id, type];
}
+(NSString*)API_CHECK_POINT:(NSInteger)kid_id{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/kid/%ld/check-point", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id], kid_id];
}
+(NSString*)API_ECAMP_POINT{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/ecamp-point", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_ECAMP_BANNER{
    return @"";
    //return [NSString stringWithFormat:@"%@/ecamp-banners", [CountryModel sharedInstance].url];
}
+(NSString*)API_ECAMP_PROMOTION{
    return @"";
    //return [NSString stringWithFormat:@"%@/ecamp-promotion", [CountryModel sharedInstance].url];
}
+(NSString*)API_REWARDS_LIST{
    return @"";
    //return @"";return [NSString stringWithFormat:@"%@/rewards", [CountryModel sharedInstance].url];
}
+(NSString*)API_MY_REWARDS{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/my-rewards", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_LOCATION{
    return @"";
    //return [NSString stringWithFormat:@"%@/ecamp-location", [CountryModel sharedInstance].url];
}
+(NSString*)API_QRCode{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/qr-scan", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_REDEEM{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/redeem", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
+(NSString*)API_SUBMIT_SURVEY{
    return @"";
    //return [NSString stringWithFormat:@"%@/user/%@/ecamp-survey", [CountryModel sharedInstance].url, [CallUnity.GetDelegate.cthSwift decodeAES256WithStr:[UserModel sharedInstance].user_id]];
}
@end
