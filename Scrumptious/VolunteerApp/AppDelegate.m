//
//  AppDelegate.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

NSString *const SCSessionStateChangedNotification =
@"com.facebook.Scrumptious:SCSessionStateChangedNotification";



#import "AppDelegate.h"
#import "MainViewController.h"
#import <Parse/Parse.h>


@implementation AppDelegate
//
//@synthesize navigationController,mainViewController;
//@synthesize selectedOpportunity;
//@synthesize userLogInStatus;
//@synthesize volunteerVC;
//@synthesize browseOpportunityVC;
//@synthesize userFBLogInStatus;
//@synthesize userSettingsVC;
//@synthesize interestTableVC;
//@synthesize userFbEmail;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //added for profile picture
    [FBProfilePictureView class];

    //Parse keys
    [Parse setApplicationId:@"M9HDjHaW7ygJrNHr0qy5taUmJXLphqlv1xmFwgEF"
                  clientKey:@"c1FNBR2CyvKYHwY79wuAeqaD0caouRvGD4EawSMb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Setting the "Volunteer View Controller" as the root view controller.
    self.mainViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navigationController;
    [FBLoginView class];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)openSession
{
    // set permissions for accessing the user basic info,emailId
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
    
    
   }

/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
  }
*/
//feedback changes start
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
                        if (call.accessTokenData) {
                            if ([FBSession activeSession].isOpen) {
                                NSLog(@"INFO: Ignoring app link because current session is open.");
                            }
                            else {
                                [self handleAppLink:call.accessTokenData];
                            }
                        }

                    }];
}


- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                 // [self.loginViewController loginView:nil handleError:error];
                                  NSLog(@"Error");
                              }
                          }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // We need to properly handle activation of the application with regards to SSO
    // (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

//feedback changes end

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
        {
            
            /* Display the page you want to display after user logged in . */
            self.userFBLogInStatus=YES;
            self.browseOpportunityVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
           [self.navigationController pushViewController:self.browseOpportunityVC animated:YES];
           
                 /* self.userSettingsVC=[[UserSettingViewController alloc]init];
            [self.navigationController pushViewController:self.userSettingsVC animated:YES];*/
                    }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            //put the page u want to display on failed login
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.userFBLogInStatus=NO;
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
            
        default: NSLog(@"Default");break;
            
    }
    
    //added for  ProfilePicture
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];
    
        if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}



@end
