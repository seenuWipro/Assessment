//
//  ItemModel.h
//  ListView
//
//  Created by Wipro on 5/9/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *detail;
@property(nonatomic, strong) NSURL *imageURL;

+(NSMutableArray *)getModelArrayFromJson:(NSArray *)array;
@end
