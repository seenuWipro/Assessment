//
//  ItemTableViewCell.h
//  ListView
//
//  Created by Wipro on 5/7/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@interface ItemTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *itemImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;

-(void)setDetails:(ItemModel *)item;
-(void)setImageFromURL:(NSURL*)imageURL;
@end
