#import "Signup_PasswordVC.h"
#import "AppDelegate.h"
#import "userModel.h"
#import "Common.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Utility.h"
#import "ConfirmVC.h"
#import "SignupVC.h"

@interface Signup_PasswordVC ()

@end

@implementation Signup_PasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef humming_dev
    
    [imgLogo setImage:[UIImage imageNamed:@"splash_dev_icon"]];
#endif
    self.navigationItem.title = @"Password";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [txtPassword resignFirstResponder];
    
    return YES;
}
-(IBAction)onSignup:(id)sender{
    
    [txtPassword resignFirstResponder];
    
    if (txtPassword.text.length != 0) {
        
        SignupVC *signVC = [theAppDelegate.gMainStoryboard instantiateViewControllerWithIdentifier:@"SignupVC"];
        signVC.mUserEmail = _mUserEmail;
        signVC.mUserPassword = txtPassword.text;
        [self.navigationController pushViewController:signVC animated:YES];
        
    }else{

        [SVProgressHUD showErrorWithStatus:PASSWORD_WARNING];
    }
}


@end
