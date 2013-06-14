//
//  PhotographersTableViewController.h
//  Photomania
//
//  Created by El Desperado on 6/9/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "TTTAttributedLabel.h"


@interface PhotographersTableViewController : CoreDataTableViewController <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIManagedDocument *photoDatabase;

@end
