//
//  MainTableTableViewController.h
//  ObjcNewsFeedTableView
//
//  Created by suraj poudel on 14/5/18.
//  Copyright © 2018 suraj poudel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * newsTable;
@end
