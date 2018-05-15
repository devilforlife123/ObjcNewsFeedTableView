//
//  NewsTableViewCell.h
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "UIImageView+Extension.h"


@interface NewsTableViewCell : UITableViewCell

-(instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@property (strong, nonatomic) UIImageView *thumbnailImageView;
@property (strong, nonatomic) UILabel *headlineLabel;
@property (strong, nonatomic) UILabel *sluglineLabel;
@property(nonatomic,assign)CGFloat labelWidth;
@property(nonatomic,assign)CGFloat wideLabelWidth;
@property(nonatomic,assign)BOOL hasThumbnail;
@property(nonatomic,strong)News * news;
+ (CGFloat)heightForNews:(News*)news constrainedToWidth:(CGFloat)width;
+ (CGFloat)minimumHeight;
@end
