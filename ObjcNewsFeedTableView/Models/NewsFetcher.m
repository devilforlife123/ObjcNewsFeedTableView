//
//  NewsFetcher.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 22/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "NewsFetcher.h"
#import "NewsBuilder.h"

@implementation NewsFetcher

-(void)searchNewsItemForURLString:(NSString*)searchURL withCompletionBlock:(NewsSearchCompletionBlock)completionBlock{
    
    
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:searchURL]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSString *strISOLatin = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                                              NSData *dataUTF8 = [strISOLatin dataUsingEncoding:NSUTF8StringEncoding];
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:dataUTF8 options:kNilOptions error:&parseError];
                                              NSString * title = [responseDictionary objectForKey:@"title"];
                                              NSArray * newsFeed = [NewsBuilder newsFromJSON:responseDictionary];
                                              completionBlock(title,newsFeed,nil);
                                          }
                                          else
                                          {
                                              completionBlock(@"",nil,error);
                                          }
                                      }];
    [dataTask resume];
}
@end
