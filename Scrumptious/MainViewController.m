//
//  VolunteerViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"
#import "AppDelegate.h"


@interface MainViewController() <FBLoginViewDelegate>

@property(strong,nonatomic)MealListTableViewController * browseViewController;
@property(strong,nonatomic)UserSignInViewController * userSignInVC;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
//@property (strong, nonatomic) IBOutlet UIButton *btnLoginWithFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnBrowseOpportunities;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic)MealListTableViewController *browseOpportunityVC;


- (IBAction)buttonSignInClicked:(id)sender;
//- (IBAction)buttonLoginWithFacebookClicked:(id)sender;
- (IBAction)buttonBrowseOpportunitiesClicked:(id)sender;


@end


@implementation MainViewController
//@synthesize btnLoginWithFacebook,btnSignIn,btnBrowseOpportunities;
//@synthesize browseViewController;
//@synthesize userSignInVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.navigationController.navigationBarHidden=YES;
   // FBLoginView *loginview = [[FBLoginView alloc] init];
    FBLoginView *loginview = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    loginview.frame = CGRectOffset(loginview.frame, 70, 300);
    loginview.delegate = self;
    [self.view addSubview:loginview];
    [loginview sizeToFit];

  //  [self styleButtons:self.btnLoginWithFacebook];
    [self styleButtons:self.btnSignIn];
    }

//setting the app delegate userfbemail value

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Login view showwing logged in user");
    // Fetch user data
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error) {
             NSString *emailAddress= [user objectForKey:@"email"];
             AppDelegate *appDelegate1 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             appDelegate1.userFBLogInStatus=YES;
             appDelegate1.userFbEmail=emailAddress;
             
             self.browseOpportunityVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
             [self.navigationController pushViewController:self.browseOpportunityVC animated:YES];
             }else{
                 NSLog(@"Error");
             }
                    
     }];
    
   
}

-(void)styleButtons:(UIButton*)btn{

    btn.layer.cornerRadius=15;
    btn.clipsToBounds=YES;
    [[btn layer] setBorderWidth:2.0f];
   [[btn layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;

}

- (IBAction)buttonSignInClicked:(id)sender {
    
   //- NSLog(@"In Sign In Button");
    self.userSignInVC=[[UserSignInViewController alloc]initWithNibName:@"UserSignInViewController" bundle:nil];
    [self.navigationController pushViewController:self.userSignInVC animated:YES];
}

- (IBAction)buttonLoginWithFacebookClicked:(id)sender {
    
  //  NSLog(@"In FB Login");
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (IBAction)buttonBrowseOpportunitiesClicked:(id)sender {
  
    self.browseViewController=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
 [self.navigationController pushViewController:self.browseViewController animated:YES];
    
   /* AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
   // appDelegate.mainViewController = self.browseViewController;
    appDelegate.navigationController = [[UINavigationController alloc]initWithRootViewController:self.browseViewController];
    appDelegate.window.rootViewController = self.navigationController;
    */
    
   }


- (void)viewDidUnload {
   
    [super viewDidUnload];
}
@end
