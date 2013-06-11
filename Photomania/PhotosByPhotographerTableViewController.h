//
//  PhotosByPhotographerTableViewController.h
//  Photomania
//
//  Created by El Desperado on 6/9/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photographer.h"
#import "CoreDataTableViewController.h"

@interface PhotosByPhotographerTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Photographer *photographer;

@end
