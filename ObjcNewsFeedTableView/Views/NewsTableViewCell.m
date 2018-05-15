//
//  NewsTableViewCell.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "CustomLabel.h"
#define kCustomRedColor [UIColor colorWithRed:0.75f green:0.00f blue:0.00f alpha:1.00f]
const CGFloat NewsCellheadlineFontSize = 17.0f;
const CGFloat NewsCellSluglineFontSize = 15.0f;
const CGFloat NewsCellPadding = 15.0f;
const CGFloat NewsCellIntraCellPadding = 8.0f;
const CGFloat NewsCellThumbnailWidth = 80.0f;
const CGFloat NewsCellThumbnailHeight = 70.0f;

@interface NewsTableViewCell () {
    
    NSURLSessionDownloadTask * downloadTask;
}
@end

@implementation NewsTableViewCell

+ (CGFloat)minimumHeight
{
    return NewsCellThumbnailHeight + NewsCellPadding*2;
}



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    self.thumbnailImageView  = [[UIImageView alloc] init];
    [self.contentView addSubview:self.thumbnailImageView];
    
    self.headlineLabel= [[CustomLabel alloc] init];
    self.headlineLabel.font = [UIFont boldSystemFontOfSize:NewsCellheadlineFontSize];
    self.headlineLabel.textColor = kCustomRedColor;
    self.headlineLabel.numberOfLines = 0;
    self.headlineLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headlineLabel];
    
    self.sluglineLabel = [[CustomLabel alloc] init];
    self.sluglineLabel.font = [UIFont systemFontOfSize:NewsCellSluglineFontSize];
    self.sluglineLabel.textColor = [UIColor blackColor];
    self.sluglineLabel.numberOfLines = 0;
    self.sluglineLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.sluglineLabel];
    
    return self;
}


+ (CGFloat)heightForNews:(News*)news constrainedToWidth:(CGFloat)width
{
    CGFloat longerLabelWidth = width-NewsCellPadding*2;
    CGFloat smallerLabelWidth = smallerLabelWidth= width -NewsCellPadding*4-NewsCellThumbnailWidth;
    
    CGFloat calculatedHeight;
    
    if([news.thumbnailURL isEqual:[NSNull null]] || [news.thumbnailURL isEqualToString:@""])
    {
        calculatedHeight =  NewsCellPadding +
        [[self class] heightForHeadline:news.headline constrainedToWidth:longerLabelWidth]
        + NewsCellIntraCellPadding+
        [[self class] heightForSlugline:news.slugline constrainedToWidth:longerLabelWidth] + NewsCellIntraCellPadding+ NewsCellPadding;
        
    }
    else
    {
        calculatedHeight =  NewsCellPadding +
        +(NewsCellThumbnailHeight > [[self class] heightForHeadline:news.headline constrainedToWidth:smallerLabelWidth] ? NewsCellThumbnailHeight: [[self class] heightForHeadline:news.headline constrainedToWidth:smallerLabelWidth]) +
        + NewsCellIntraCellPadding+
        [[self class] heightForSlugline:news.slugline constrainedToWidth:longerLabelWidth] + NewsCellIntraCellPadding+ NewsCellPadding;
        
    }
    
    return MAX([[self class] minimumHeight], calculatedHeight);
}



+ (CGFloat)heightForHeadline:(NSString*)text constrainedToWidth:(CGFloat)width {
    
    // must be multi-line
    if ([text isEqual:[NSNull null]]){
        text = @"";
    }
    
    
    CGFloat value1 = ceil(([text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:NewsCellheadlineFontSize]} context:nil]).size.height);
    
    return value1;
}

+ (CGFloat)heightForSlugline:(NSString*)text constrainedToWidth:(CGFloat)width {
    // must be multi-line
    if ([text isEqual:[NSNull null]]){
        text = @"";
    }
    CGFloat value2 = ceil(([text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:NewsCellSluglineFontSize]} context:nil]).size.height);
    
    return value2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)prepareForReuse{
    
    [super prepareForReuse];
    
    downloadTask = nil;
    self.sluglineLabel.text = nil;
    self.headlineLabel.text = nil;
    self.thumbnailImageView.image = nil;
    self.hasThumbnail = NO;
}

-(void)setNews:(News *)news{
    self.sluglineLabel.text = news.slugline;
    self.headlineLabel.text = news.headline;
    if(![news.thumbnailURL isEqual:[NSNull null]]){
        downloadTask = [self.thumbnailImageView loadImageWithURL:[NSURL URLWithString:news.thumbnailURL]];
        self.hasThumbnail = YES;
        
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageGutterWidth = NewsCellPadding*2+ NewsCellThumbnailWidth;
    CGFloat cellWidth = CGRectGetWidth(self.bounds);
    
    _labelWidth = cellWidth - imageGutterWidth - NewsCellPadding*2;
    _wideLabelWidth = cellWidth-NewsCellPadding*3;
    
    
    
    if(!self.hasThumbnail)
    {
        
        self.headlineLabel.frame = CGRectMake(NewsCellPadding,
                                              NewsCellPadding,
                                              _wideLabelWidth,
                                              [[self class] heightForHeadline:self.headlineLabel.text constrainedToWidth:_wideLabelWidth]);
        self.sluglineLabel.frame = CGRectMake(NewsCellPadding,
                                              CGRectGetMaxY(self.headlineLabel.frame)+NewsCellIntraCellPadding,
                                              _wideLabelWidth,
                                              [[self class] heightForSlugline:self.sluglineLabel.text constrainedToWidth:_wideLabelWidth]);
    }
    else
    {
        self.thumbnailImageView.frame =
        CGRectMake(NewsCellPadding,
                   NewsCellPadding,
                   NewsCellThumbnailWidth,
                   NewsCellThumbnailHeight);
        
        self.headlineLabel.frame = CGRectMake(NewsCellPadding+imageGutterWidth,
                                              NewsCellPadding,
                                              _labelWidth,
                                              [[self class] heightForHeadline:self.headlineLabel.text constrainedToWidth:_labelWidth]);
        
        self.sluglineLabel.frame = CGRectMake(NewsCellPadding,
                                              CGRectGetMaxY(self.headlineLabel.frame)>CGRectGetMaxY(self.thumbnailImageView.frame) ? CGRectGetMaxY(self.headlineLabel.frame):CGRectGetMaxY(self.thumbnailImageView.frame)+NewsCellIntraCellPadding,
                                              _wideLabelWidth,
                                              [[self class] heightForSlugline:self.sluglineLabel.text constrainedToWidth:_wideLabelWidth]);
        
        
        
    }
}


@end
