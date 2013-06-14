//
//  InitViewController.m
//  Photomania
//
//  Created by El Desperado on 6/10/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "InitViewController.h"

@interface InitViewController ()

@end

@implementation InitViewController

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
	// Do any additional setup after loading the view.
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Photographers"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
