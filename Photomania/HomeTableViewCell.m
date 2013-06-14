//
//  HomeTableViewCell.m
//  Photomania
//
//  Created by El Desperado on 6/14/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "TTTAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Constants
static CGFloat const postTitleTextFontSize = 17;
static CGFloat const postRatingScoreTextFontSize = 17;
static CGFloat const postUserNameTextFontSize = 17;
static CGFloat const postTimeStampTextFontSize = 17;
static CGFloat const postDescriptionTextFontSize = 17;
static CGFloat const homeTableViewCellVerticalMargin = 20.0f;

#pragma mark - Regular Expressions for checking texts
static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}


@implementation HomeTableViewCell
@synthesize featuredImage = _featuredImage;
@synthesize ratingBoxImage = _ratingBoxImage;
@synthesize ratingScore = _ratingScore;
@synthesize postTitle = _postTitle;
@synthesize avatarImage = _avatarImage;
@synthesize userName = _userName;
@synthesize timeStampIcon = _timeStampIcon;
@synthesize timeStampText = _timeStampText;
@synthesize postDescription = _postDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self customizePostTitleText];
    
    
    return self;
}

- (void)customizePostTitleText
{
    self.postTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.postTitle.font = [UIFont systemFontOfSize:postTitleTextFontSize];
    self.postTitle.textColor = [UIColor darkGrayColor];
    self.postTitle.lineBreakMode = UILineBreakModeWordWrap;
    self.postTitle.numberOfLines = 0;
    self.postTitle.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.postTitle.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.postTitle.highlightedTextColor = [UIColor whiteColor];
    self.postTitle.shadowColor = [UIColor colorWithWhite:0.87 alpha:1.0];
    self.postTitle.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.postTitle.highlightedShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    self.postTitle.highlightedShadowOffset = CGSizeMake(0.0f, -1.0f);
    self.postTitle.highlightedShadowRadius = 1;
    self.postTitle.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    [self.contentView addSubview:self.postTitle];
}

- (void)setSummaryText:(NSString *)text {
    [self willChangeValueForKey:@"postDescription"];
    _postDescription = [text copy];
    [self didChangeValueForKey:@"postDescription"];
    
    [self.postTitle setText:self.postDescription afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:postDescriptionTextFontSize];
        CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (boldFont) {
            [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:nameRange];
            [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:nameRange];
            CFRelease(boldFont);
        }
        
        [mutableAttributedString replaceCharactersInRange:nameRange withString:[[[mutableAttributedString string] substringWithRange:nameRange] uppercaseString]];
        
        regexp = ParenthesisRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:postDescriptionTextFontSize];
            CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:result.range];
                CFRelease(italicFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[[UIColor grayColor] CGColor] range:result.range];
            }
        }];
        
        return mutableAttributedString;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    self.postTitle.frame = CGRectOffset(CGRectInset(self.bounds, 20.0f, 5.0f), -10.0f, 0.0f);
}

@end
