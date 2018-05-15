//
//  NewsBuilder.h
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsBuilder : NSObject

+(NSArray*)newsFromJSON:(id)jsonObject;

@end
