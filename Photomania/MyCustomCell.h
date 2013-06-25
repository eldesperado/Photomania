//
//  MyCustomCell.h
//  Photomania
//
//  Created by El Desperado on 6/24/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface MyCustomCell : UITableViewCell
{
    UILabel *_ratingScore;
    TTTAttributedLabel *_postTitle;
    TTTAttributedLabel *_postAddressText;
    TTTAttributedLabel *_userName;
    TTTAttributedLabel *_timeStampText;
    TTTAttributedLabel *_postSaveCountText;
    TTTAttributedLabel *_postCommentCountText;
    TTTAttributedLabel *_postRatingScoreText;
    TTTAttributedLabel *_postLoveCountText;
    TTTAttributedLabel *_postDescription;
}

@property (strong, nonatomic) IBOutlet UIImageView *featuredImage;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, strong) IBOutlet UILabel *ratingScore;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postTitle;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postAddressText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *userName;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *timeStampText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postSaveCountText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postCommentCountText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postRatingScoreText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postLoveCountText;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *postDescription;

- (void) setLoveCountText:(NSString *) postLoveCountText;

@end
