//
//  NewsFetcher.h
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 22/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NewsSearchCompletionBlock)(NSString*title,NSArray * newsArray,NSError * error);

@interface NewsFetcher : NSObject

-(void)searchNewsItemForURLString:(NSString*)urlString withCompletionBlock:(NewsSearchCompletionBlock)completionBlock;

@end
