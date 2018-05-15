//
//  News.h
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(nonatomic,copy)NSString * headline;
@property(nonatomic,copy)NSString * slugline;
@property(nonatomic,copy)NSString * thumbnailURL;

@end

