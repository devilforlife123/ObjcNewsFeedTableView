//
//  UIImageView+Extension.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

-(NSURLSessionDownloadTask*)loadImageWithURL:(NSURL*)url{
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    __weak UIImageView * weakSelf = self;
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            return;
        }else{
            NSData * data = [[NSData alloc]initWithContentsOfURL:location];
            UIImage * image = [[UIImage alloc]initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = image;
            });
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
    
    
    
}


@end
