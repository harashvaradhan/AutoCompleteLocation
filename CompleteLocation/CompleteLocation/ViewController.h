//
//  ViewController.h
//  CompleteLocation
//
//  Created by GNR solution PVT.LTD on 19/06/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearchResult;


@end

