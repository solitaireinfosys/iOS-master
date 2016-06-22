//
//  Common.h
//  umami
//
//  Created by Star on 12/5/15.
//  Copyright (c) 2015 Star. All rights reserved.
//

#define STANDARD_DEFAULT_STRING [NSUserDefaults standardUserDefaults]
#define login_check_true 1
#define login_check_false 0


#define kNotificationDidReceiveRemoteMessageNotification              @"pushReceived"

#define kNotificationDidActiveAppNotification              @"activeApp"


#define EMAIL_WARNING @"Pleae input the email"
#define PASSWORD_WARNING @"Please input the password"
#define USERNAME_WARNING @"Please input the username"

#define REQUEST_WAITING @"Waiting..."
#define LOGIN_FAILED @"Email or Password incorrect"
#define WEB_FAILED @"Failed. Try again"
#define CONFIRM_FAILED @"Please confirm e-mail then continue"

static NSString *const kTrackingId = @"UA-72183017-2";
static NSString *const kAllowTracking = @"allowTracking";
#ifdef humming_dist
#define WEBSERVICE_URL                  @"http://www.hummb.com/api/"
#else
#define WEBSERVICE_URL                  @"http://hummb.com/api_dev/"
#endif
//#define WEBSERVICE_URL                  @"http://166.62.80.140/api_dev/"

#define WEB_LOGIN                       @"msg_Login.php"

#define WEB_LOGOUT                       @"msg_Logout.php"

#define NOTIFICATION_RECV               @"background_sync.php"

#define BACKGROUND_UPDATE               @"sync_update.php"

#define WEB_SIGNUP                       @"Sign.php"
#define WEB_CONFIRM                       @"check_active.php"
#define WEB_RESEND                       @"Resend.php"
#define WEB_RATING_POST                      @"rating_post1.php"

#define WEB_RESENT_ACTIVE               @"resend_activation_email.php"

#define WEB_ANSWER_LIKE                     @"add_answer_like.php"
#define WEB_FACEBOOK_LOGIN                       @"facebook_login.php"
#define WEB_UPDATE_USER                       @"update_user_info.php"

#define WEB_UPDATE_USERPHONE                       @"update_user_phone.php"
#define WEB_VERIFY_PHONE                       @"verify_phone.php"
#define WEB_VERIFY_EMAIL                       @"verify_email.php"

#define WEB_VERIFY_SENT_SMS                       @"verify_sms_sent.php"
#define WEB_VERIFY_SENT_EMAIL                       @"verify_email_sent1.php"
#define WEB_SENT_FEEDBACK                       @"feedback_sent.php"

#define WEB_CAPTURE_MAIL                        @"capture_mail.php"

#define WEB_VOICE_CHANGE               @"voice_change.php"


#define WEB_QUESTION_POST               @"question_post.php"
#define WEB_QUESTION_GET                @"get_questions1.php"
#define WEB_COMMUNITY_GET                @"get_community.php"
#define WEB_USERINFO_GET                @"get_user_info.php"

#define WEB_LINK_CHECKED                @"link_checked.php"

#define WEB_TOP_GET                @"get_top.php"
#define WEB_TOP_SEARCH                @"get_top_search.php"

#define WEB_CHECK_RATING            @"check_rating.php"


#define WEB_HISTORY_GET                @"get_history.php"
#define WEB_FORGOT_PASSWORD            @"forgot_password.php"

#define WEB_GET_NOTIFICATION                @"get_notification_capture.php"
#define WEB_CHECK_QUESTION                @"check_question.php"

#define WEB_ANSWER_GET                @"get_answers.php"
#define WEB_ANSWER_POST                @"answer_post.php"
#define WEB_BLOCK_POST                @"add_block.php"


#define MESSAGE_ANSWER_HISTORY 1
#define MESSAGE_ANSWER_CHAT 2
#define MESSAGE_ANSWER_NORATING 3
#define MESSAGE_COMMUNITY 4
#define MESSAGE_ANSWER_TOP 5

#define verify_signup 0
#define verify_sms 1


#define swt_question_sms 0
#define swt_answer_sms 1

#define swt_question_email 2
#define swt_answer_email 3
