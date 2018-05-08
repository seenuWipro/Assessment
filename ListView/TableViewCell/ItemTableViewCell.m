//
//  ItemTableViewCell.m
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
    
     [self addImageViewLayout];
}

-(void)addImageViewLayout {
    
    NSDictionary *views = @{@"imageView":self.itemImageView,@"title":self.titleLabel,@"description":self.descriptionLabel};
    NSDictionary *metrics = @{@"imageSize":@100.0,@"padding":@15.0};

    // Horizontal layouts
    NSArray *horizontalImgeandTitle =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[imageView]-padding-[title]-padding-|" options:0 metrics:metrics views:views];
    NSArray *horizontalDesc =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[imageView]-padding-[description]-padding-|" options:0 metrics:metrics views:views];
    [self.contentView addConstraints:horizontalImgeandTitle];
    [self.contentView addConstraints:horizontalDesc];

    // Vertical layouts
    NSArray *verticalImageTop =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[imageView]->=padding-|" options:0 metrics:metrics views:views];
    NSArray *verticalTitleandDescription =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[title]-[description]->=padding-|" options:0 metrics:metrics views:views];
    [self.contentView addConstraints:verticalImageTop];
    [self.contentView addConstraints:verticalTitleandDescription];

    // Image Height and Width
    NSArray *imageWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(imageSize)]" options:0 metrics:metrics views:views];
    NSArray *imageHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(imageSize)]" options:0 metrics:metrics views:views];
    [self.contentView addConstraints:imageWidth];
    [self.contentView addConstraints:imageHeight];

    // ContentHugging for uilabel auto height
    [self.titleLabel setContentHuggingPriority:252
                                             forAxis:UILayoutConstraintAxisVertical];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
