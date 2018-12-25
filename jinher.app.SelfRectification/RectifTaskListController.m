//
//  RectifTaskListController.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/21.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "RectifTaskListController.h"
#import "RectTaskCell.h"
#import "RectifTaskList.h"
#import "SelfRectificationController.h"
#import "SelfRectPreViewController.h"
#import "ReqRectifServer.h"
#import "MBProgressHUD.h"

@interface RectifTaskListController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *taskArray;
@end

@implementation RectifTaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RectTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RectTaskCell"];
    cell.model = self.taskArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RectifTask *task = self.taskArray[indexPath.row];
    ///
    if (task.IsCompleted) {
        //
        SelfRectPreViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelfRectPreViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SelfRectificationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelfRectificationController"];
        if (task.ComInspectOptionList.count > 0) {
            vc.task = task;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"没有检查项！";
            [hud hide:YES afterDelay:1.f];
        }
    }
}

-(void)loadData
{
    [MBProgressHUD showHUDText:@"正在加载数据中..." animated:YES];
    [[ReqRectifServer shared] reqGetComInspectTaskList:_storeId handler:^(NSArray<RectifTask *> *data) {
        //
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MBProgressHUD hideHUDanimated:YES];
            self.taskArray = data;
            [self.tableView reloadData];
        }];
    }];
}

- (IBAction)ibaBackAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray *)taskArray
{
    if (!_taskArray) {
        _taskArray = [NSArray new];
    }
    return _taskArray;
}

@end
