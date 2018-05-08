//
//  NetworkManager.h
//  ListView
//
//  Created by Wipro on 5/8/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject

+(void)fetchDetails:(void (^)(NSDictionary *result, NSError *error))completion;
+(void)downloadImage:(NSURL *)imgURL completion:(void (^)(NSData *imageData, NSError *error))completion;
@end
