//
//  itemModel.m
//  ListView
//
//  Created by Wipro on 5/9/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+(NSMutableArray *)getModelArrayFromJson:(NSArray *)array {
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        if ([dict objectForKey:@"title"] != [NSNull null] || [dict objectForKey:@"description"] != [NSNull null] || [dict objectForKey:@"imageHref"] != [NSNull null]) {
            
            ItemModel *model = [[ItemModel alloc]init];
            if ([dict objectForKey:@"title"] != [NSNull null]) {
                model.title = [dict objectForKey:@"title"];
            }
            
            if ([dict objectForKey:@"description"] != [NSNull null]) {
                model.detail = [dict objectForKey:@"description"];
            }
            
            if ([dict objectForKey:@"imageHref"] != [NSNull null]) {
                NSString *strImgURLAsString = [dict objectForKey:@"imageHref"];
                [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
                model.imageURL = imgURL;
            }
            
            [modelArray addObject:model];
        }
    }
    
    return modelArray;
}
@end
