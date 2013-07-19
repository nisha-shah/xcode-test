//
//  AboutViewController.m
//  VolunteerApp
//
//  Created by Nisha Shah on 6/17/13.
//  Copyright (c) 2013 Nisha Shah. All rights reserved.
//

#import "AboutViewController.h"
#import "MainViewController.h"
#import "MealListTableViewController.h"

@interface AboutViewController ()
@property(strong,nonatomic)VolunteerViewController *volunteerVC;
@property(strong,nonatomic)MealListTableViewController *browseOpportunityVC;

//- (IBAction)btnProceedClicked:(id)sender;
@end

@implementation AboutViewController
@synthesize volunteerVC;
@synthesize browseOpportunityVC;

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
    self.navigationItem.title=@" About ";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Done"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(btnProceedClicked:)];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnProceedClicked:(id)sender {
   // self.volunteerVC=[[VolunteerViewController alloc]initWithNibName:@"VolunteerViewController" bundle:nil];
    self.browseOpportunityVC=[[MealListTableViewController alloc]initWithNibName:@"MealListTableViewController" bundle:nil];
    [self.navigationController pushViewController:self.browseOpportunityVC animated:YES];
}
@end
