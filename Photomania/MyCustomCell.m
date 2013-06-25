//
//  MyCustomCell.m
//  Photomania
//
//  Created by El Desperado on 6/24/13.
//  Copyright (c) 2013 El Desperado. All rights reserved.
//

#import "MyCustomCell.h"

@implementation MyCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setLoveCountText:(NSString *) postLoveCountText
{
    //[self.description setText: descriptionText];
    [self.postLoveCountText setText: postLoveCountText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(1, 2);
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:18.0f];
        
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:stringRange];
        
        CFRelease(font);
        return mutableAttributedString;
    }];
    
}

@end
