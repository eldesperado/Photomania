//
//  HomeTableViewCell.h
//  Photomania
//
//  Created by El Desperado on 6/14/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTAttributedLabel;

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *featuredImage;
@property (strong, nonatomic) IBOutlet UIImageView *ratingBoxImage;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UIImageView *timeStampIcon;
@property (nonatomic, strong) TTTAttributedLabel *ratingScore;
@property (nonatomic, strong) TTTAttributedLabel *postTitle;
@property (nonatomic, strong) TTTAttributedLabel *userName;
@property (nonatomic, strong) TTTAttributedLabel *timeStampText;
@property (strong, nonatomic) IBOutlet UITextView *postDescription;

@end
