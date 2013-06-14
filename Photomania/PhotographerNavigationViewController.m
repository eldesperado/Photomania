//
//  PhotographerNavigationViewController.m
//  Photomania
//
//  Created by El Desperado on 6/11/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "PhotographerNavigationViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface PhotographerNavigationViewController ()

@end

@implementation PhotographerNavigationViewController
@synthesize menuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Action for Menu Button
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create Menu Button
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];

    menuButton.frame = CGRectMake(8, 10, 34, 24);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    if ( ![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]] ) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
