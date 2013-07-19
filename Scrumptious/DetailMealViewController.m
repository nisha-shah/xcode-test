//
//  DetailOpportunityViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "DetailMealViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MealProtocol.h"


@interface DetailMealViewController ()

@property (strong, nonatomic) IBOutlet UITextView *opportunityTextView;
@property (strong, nonatomic) IBOutlet UIButton *btnShareOnFacebook;
@property (strong, nonatomic) IBOutlet UIImageView *detailOpportunityImage;
- (IBAction)btnShareOnFacebookClicked:(id)sender;


@end

@implementation DetailMealViewController
/*@synthesize opportunityTextView;
@synthesize btnShareOnFacebook;
@synthesize detailOpportunityImage;
*/
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  NSLog(@"APP DELEGATE VARIABLE %@",appDelegate.selectedOpportunity);
   
    PFQuery *query = [PFQuery queryWithClassName:@"Meal"];
    [query whereKey:@"meal_name" equalTo:appDelegate.selectedOpportunity];
    PFObject *result = [query getFirstObject];
    self.navigationItem.title=[result objectForKey:@"meal_name"];
    PFFile *theImage = [result objectForKey:@"meal_image"];
    
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.detailOpportunityImage.image=image;
    self.opportunityTextView.text=[result objectForKey:@"meal_description"];

    NSLog(@"Description is %@",[result objectForKey:@"meal_description"]);

}
-(void)styleButtons:(UIButton*)btn{
    
    btn.layer.cornerRadius=15;
    btn.clipsToBounds=YES;
    [[btn layer] setBorderWidth:2.0f];
    [[btn layer] setBorderColor:[UIColor blackColor].CGColor];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShareOnFacebookClicked:(id)sender {
    
    NSLog(@"Button share clicked");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    id<SCOGMealAction> action1= (id<SCOGMealAction>)[FBGraphObject graphObject];
    
    if([appDelegate.selectedOpportunity isEqualToString:@"Brussels Sprouts"]){
        action1[@"meal"]=@"154364254746841";
    }else if([appDelegate.selectedOpportunity isEqualToString:@"Cheese Burger"]){
        action1[@"meal"]=@"271758939630210";
    }else if([appDelegate.selectedOpportunity isEqualToString:@"Lamb"]){
        action1[@"meal"]=@"1383214021895331";
    }else if([appDelegate.selectedOpportunity isEqualToString:@"Fried Chicken"]){
        action1[@"meal"]=@"613949601957268";
    }else if([appDelegate.selectedOpportunity isEqualToString:@"Pork Belly"]){
        action1[@"meal"]=@"477859455632269";
    }else{
        action1[@"meal"]=@"195176823974223";
    }
    
    
    BOOL checkShareDialogAppear= [FBDialogs presentShareDialogWithOpenGraphAction:action1
                                          actionType:@"nishaiosapp:eat"
                                 previewPropertyName:@"meal"
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if(error){
                                                     if(error.fberrorCategory == FBErrorCategoryUserCancelled){
                                                         NSLog(@"User pressed cancel button ");
                                                     }
                                                     NSLog(@"In Error Loop");
                                                     NSLog(@"Error: %@", error.description);
                                                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                 message:[NSString stringWithFormat:@"Error"]
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK!"
                                                                       otherButtonTitles:nil]
                                                      show];
                                                     
                                                     
                                                 }else{
                                                    
                                                      NSString *completeGestureValue = [results objectForKey: @"completionGesture"];
                                        
                                                     if([completeGestureValue isEqualToString:@"cancel"]){
                                                         NSLog(@"User clicked the Cancel Button");
                                                     }else{
                                                         
                                                  /* NSString *dc=[results objectForKey: @"didComplete"];
                                                         NSLog(@"DC is %@",dc);
                                                    */     
                                                         
                                                  //   NSLog(@"Success! ");
                                                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                                 message:[NSString stringWithFormat:@"Story shared successfully"]
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK !"
                                                                       otherButtonTitles:nil]
                                                      show];
                                                     
                                                     }
                                                 }
                                             }];
    
    NSLog(@"Share Dialog value %d",checkShareDialogAppear);
    //if share dialog not supported
    if(!checkShareDialogAppear/*FBShareErrorDenied*/){
         NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         @"Scrumptious", @"name",
         @"hello", @"caption",
         @"dfdsfdsfsdfsdf", @"description",
         @"https://developers.facebook.com/ios", @"link",
         @"http://s.facebooksampleapp.com/scrumptious/static/images/meals/cheeseburger@2x.jpg", @"picture",
         nil];
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Error launching the dialog or publishing a story.
                 NSLog(@"Error publishing story.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // Handle the publish feed callback
                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"post_id"]) {
                         // User clicked the Cancel button
                         NSLog(@"User canceled story publishing.");
                     } else {
                         // User clicked the Share button
                         NSString *msg = [NSString stringWithFormat:
                                          @"Story shared successfully"];
                         NSLog(@"%@", msg);
                         // Show the result in an alert
                         [[[UIAlertView alloc] initWithTitle:@"Result"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil]
                          show];
                     }
                 }
             }
         }];
    }
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
