//
//  ItemTableViewCell.m
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "NetworkManager.h"

@implementation ItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        self.itemImageView = [[UIImageView alloc]init];
        [self.itemImageView setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.itemImageView];
        
        // Title
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setNumberOfLines:0];
        [self.contentView addSubview:self.titleLabel];
        
        // Description
        self.descriptionLabel = [[UILabel alloc] init];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        [self addImageViewLayout];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
    NSArray *verticalImageTop =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[imageView]->=padding@500-|" options:0 metrics:metrics views:views];
    NSArray *verticalTitleandDescription =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[title]-[description]->=padding-|" options:0 metrics:metrics views:views];
    [self.contentView addConstraints:verticalImageTop];
    [self.contentView addConstraints:verticalTitleandDescription];

    // Image Height and Width
    NSArray *imageWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(imageSize)]" options:0 metrics:metrics views:views];
    NSArray *imageHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(imageSize)]" options:0 metrics:metrics views:views];
    [self.itemImageView addConstraints:imageWidth];
    [self.itemImageView addConstraints:imageHeight];

    // ContentHugging for uilabel auto height
    [self.titleLabel setContentHuggingPriority:252 forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - cell details

-(void)setDetails:(ItemModel *)item {
    
    if (item.title) {
        self.titleLabel.text = item.title;
    }
    
    if (item.detail) {
        self.descriptionLabel.text = item.detail;
    }
    
    if (item.imageURL) {
        [self setImageFromURL:item.imageURL];
    }
    
}

-(void)setImageFromURL:(NSURL*)imageURL {
    typeof(self) weakSelf = self;
    [NetworkManager downloadImage:imageURL completion:^(NSData *imageData, NSError *error) {
        if (imageData) {
            UIImage *img = [[UIImage alloc] initWithData:imageData];
            // validate for refresh imageview
            if (weakSelf.itemImageView) {
                weakSelf.itemImageView.image = img;
            }
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
