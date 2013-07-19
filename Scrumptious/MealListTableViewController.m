//
//  BrowseOpportunityTableViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/6/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "MealListTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>


@interface MealListTableViewController() 

@property(strong,nonatomic)DetailMealViewController * detailOpportunityVC;
@property(strong,nonatomic)UserSettingViewController * userSettingVC;
@property(nonatomic, readwrite, retain) PFObject *selected_opportunity;
@property(nonatomic, readwrite, retain)NSMutableArray *intList;;
@property(nonatomic, readwrite, retain)PFQuery *displayOpportunityQuery;

@end


@implementation MealListTableViewController
/*@synthesize detailOpportunityVC;
@synthesize selected_opportunity;
@synthesize intList;
@synthesize displayOpportunityQuery;
@synthesize userSettingVC;*/

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad
{
   
    self.parseClassName=@"Meal";
    self.textKey=@"meal_name";
    self.paginationEnabled = YES;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.title=@"Scrumptious";
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(openSettingsView:)];
    [anotherButton setImage:[UIImage imageNamed:@"gear.png"]];
    [anotherButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem=anotherButton;
}



-(void)viewDidAppear:(BOOL)animated{
  
    [self loadObjects];
}
-(void)openSettingsView:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.userLogInStatus==0 && appDelegate.userFBLogInStatus==0)
    {
        UIAlertView *message1 = [[UIAlertView alloc] initWithTitle:@"Account Settings"
                                                           message:@"You must be logged in to view account settings."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        message1.backgroundColor=[UIColor blackColor];
        
        [message1 show];
        return;
    }else{
    self.userSettingVC=[[UserSettingViewController alloc]initWithNibName:@"UserSettingViewController" bundle:nil];
    [self.navigationController pushViewController:self.userSettingVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.

- (PFQuery *)queryForTable {
    //--  NSLog(@"Class name is %@",self.parseClassName);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 //display opportunities as per interests
    if(appDelegate.userLogInStatus==1 || appDelegate.userFBLogInStatus==1){
        NSString* uEmail= [[PFUser currentUser] objectForKey:@"email"];
        PFQuery *queryInterests = [PFQuery queryWithClassName:@"User_Interests"];
        
        if(appDelegate.userLogInStatus==1){
        [queryInterests whereKey:@"user_email" equalTo:uEmail];
        }else{
           
           // [self populateUserDetails];
            AppDelegate *appDelegate3 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSLog(@"App Delegste = FB email : %@",appDelegate3.userFbEmail);
        [queryInterests whereKey:@"user_email" equalTo:appDelegate.userFbEmail];
        }
        
       NSArray *results= [queryInterests findObjects];
        self.intList=[[NSMutableArray alloc]init];
        for(PFObject *object in results) {
         //--   NSLog(@"Received Interest List  : %@",[object objectForKey:@"interest_name"]);
            [self.intList addObject:[object objectForKey:@"interest_name"]];
        }
        
        self.displayOpportunityQuery =[PFQuery queryWithClassName:self.parseClassName];
        
        if(!([self.intList count]==0)){
        [self.displayOpportunityQuery whereKey:@"meal_type" containedIn:self.intList];
            
        }
      
       }else{
      self.displayOpportunityQuery=[PFQuery queryWithClassName:self.parseClassName];
    }
   if ([self.objects count] == 0) {
        self.displayOpportunityQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [self.displayOpportunityQuery orderByAscending:@"meal_id"];
    return self.displayOpportunityQuery;
    
   
}

//bifurcation start
- (void)findCallback:(NSArray *)results error:(NSError *)error {
    if (!error) {
        // The find succeeded.
             self.intList=[[NSMutableArray alloc]init];
        for (PFObject *object in results) {
            [self.intList addObject:[object objectForKey:@"interest_name"]];
           }
        self.displayOpportunityQuery =[PFQuery queryWithClassName:@"Meal"];
        [self.displayOpportunityQuery whereKey:@"meal_type" containedIn:self.intList];
        [self.displayOpportunityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.!!!!!", objects.count);
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        // NSLog(@"Total matching interests is %d",[retrieveOportunityQuery countObjects]);
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    
}
//bifurcation end

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.detailTextLabel.numberOfLines = 0;
    UIImage *myImage = [UIImage imageNamed:@"blackaccessorybutton.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    [cell setAccessoryView:imageView];

   // cell.textLabel.text = [object objectForKey:@"meal_name"];
    PFFile *theImage = [object objectForKey:@"meal_image"];
   // NSData *imageData = [theImage getData];
   //- UIImage *image = [UIImage imageWithData:imageData];
      cell.imageView.file = theImage;
    cell.detailTextLabel.numberOfLines = 0;
 //   [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:12]];
  //     cell.detailTextLabel.text = [object objectForKey:@"meal_description"];
  
    UILabel * mealNameLabel = [[UILabel alloc]init];
    mealNameLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
    [mealNameLabel setFrame:CGRectMake(135.0, 5.0, 200.0, 20.0)]; //final dimensions 10,60,300,240
    [mealNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    mealNameLabel.text=[object objectForKey:@"meal_name"];
    [cell addSubview:mealNameLabel];
    
    UILabel * mealDescriptionLabel = [[UILabel alloc]init];
    [mealDescriptionLabel setNumberOfLines:0];
    [mealDescriptionLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    
    
    mealDescriptionLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
    [mealDescriptionLabel setFrame:CGRectMake(135.0, 25.0, 180.0, 60.0)]; //final dimensions 10,60,300,240
    mealDescriptionLabel.text=[object objectForKey:@"meal_description"];
    [cell addSubview:mealDescriptionLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
   //  NSLog(@"in acccessory tap buton");
    NSString *sel;
    self.detailOpportunityVC=[[DetailMealViewController alloc]initWithNibName:@"DetailMealViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selected_opportunity = [self objectAtIndexPath:indexPath];
    sel=[self.selected_opportunity objectForKey:@"meal_name"];
     appDelegate.selectedOpportunity=sel;
    [self.navigationController pushViewController:self.detailOpportunityVC animated:YES];
   }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell row selected");
    NSString *sel;
    self.detailOpportunityVC=[[DetailMealViewController alloc]initWithNibName:@"DetailMealViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    self.selected_opportunity = [self objectAtIndexPath:indexPath];
    sel=[self.selected_opportunity objectForKey:@"meal_name"];
    appDelegate.selectedOpportunity=sel;
    [self.navigationController pushViewController:self.detailOpportunityVC animated:YES];
    

}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"IN VIEW WILL APPEAAR");
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"FB SESSION IS OPEN");
        [self populateUserDetails];
    }
}

- (void)populateUserDetails {
    NSLog(@"in populate user details");
    if (FBSession.activeSession.isOpen) {
        NSLog(@"open again");
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSLog(@"User name i s %@",user.name);
                 NSString *emailAddress= [user objectForKey:@"email"];
                 AppDelegate *appDelegate1 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 appDelegate1.userFbEmail=emailAddress;

                 
             }else{
                 NSLog(@"error ");
             }
         }];
    }
}*/

/*
 - (UITableViewCell *)tableView123:(UITableView *)tableView
 cellForRowAtIndexPath:(NSIndexPath *)indexPath
 object:(PFObject *)object {
 static NSString *CellIdentifier = @"Cell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
 }
 
 //to show the complete description
 cell.detailTextLabel.numberOfLines = 0;
 
 //--  cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
 
 UIImage *myImage = [UIImage imageNamed:@"blackaccessorybutton.png"];
 
 UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
 
 [cell setAccessoryView:imageView];
 
 
 //   cell.textLabel.text = [object objectForKey:@"meal_name"];
 //   [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:12]];
 //   cell.detailTextLabel.text = [object objectForKey:@"meal_description"];
 
 PFFile *theImage = [object objectForKey:@"meal_image"];
 
 NSData *imageData = [theImage getData];
 UIImage *image = [UIImage imageWithData:imageData];
 
 
 UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
 imgView.backgroundColor=[UIColor clearColor];
 [imgView.layer setCornerRadius:8.0f];
 [imgView.layer setMasksToBounds:YES];
 [imgView setImage:image];
 [cell.contentView addSubview:imgView];
 //- cell.imageView.image=image;
 
 
 UILabel * mealNameLabel = [[UILabel alloc]init];
 mealNameLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
 [mealNameLabel setFrame:CGRectMake(125.0, 5.0, 200.0, 20.0)]; //final dimensions 10,60,300,240
 [mealNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
 mealNameLabel.text=[object objectForKey:@"meal_name"];
 [cell addSubview:mealNameLabel];
 
 UILabel * mealDescriptionLabel = [[UILabel alloc]init];
 [mealDescriptionLabel setNumberOfLines:0];
 [mealDescriptionLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
 
 
 mealDescriptionLabel.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
 [mealDescriptionLabel setFrame:CGRectMake(125.0, 25.0, 180.0, 60.0)]; //final dimensions 10,60,300,240
 mealDescriptionLabel.text=[object objectForKey:@"meal_description"];
 [cell addSubview:mealDescriptionLabel];
 
 
 
 return cell;
 }
 */


@end
