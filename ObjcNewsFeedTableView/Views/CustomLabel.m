//
//  CustomLabel.m
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 15/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)init {
    self = [super init];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisVertical];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    
    [super layoutSubviews];
}

@end
