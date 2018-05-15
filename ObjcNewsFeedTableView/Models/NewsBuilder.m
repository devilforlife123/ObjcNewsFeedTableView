//
//  NewsBuilder.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "NewsBuilder.h"
#import "News.h"

@implementation NewsBuilder

+(NSArray*)newsFromJSON:(id)jsonObject{
    
    NSMutableArray * newsArray = [NSMutableArray new];
    NSArray * results = [jsonObject valueForKey:@"rows"];
    for (NSDictionary * newsDict in results){
        News * news = [[News alloc]init];
        
        if(![[newsDict objectForKey:@"title"] isEqual:[NSNull null]])
        {
            news.headline = [newsDict objectForKey:@"title"];
        }else{
            news.headline = @"No title Available";
        }
        if(![[newsDict objectForKey:@"description"] isEqual:[NSNull null]])
        {
            news.slugline = [newsDict objectForKey:@"description"];
        }else{
            news.headline = @"No title Available";
        }
        news.thumbnailURL = [newsDict objectForKey:@"imageHref"];
        [newsArray addObject:news];
    }
    
    return newsArray;
}

@end
