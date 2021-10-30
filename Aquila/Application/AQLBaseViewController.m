//
//  AQLBaseViewController.m
//  Aquila
//
//  Created by Lumen on 2021/10/2.
//

#import "AQLBaseViewController.h"

@interface AQLBaseViewController ()
@property (nonatomic, strong) NSArray* cellTitle;
@property (nonatomic, strong) NSArray* cellClass;
@end

@implementation AQLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Shaders";
    [self p_constructCellModel];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)p_constructCellModel {
    self.cellTitle = @[@"Test"];
    self.cellClass = @[@"AQLShaderTestViewController"];
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class class = NSClassFromString(self.cellClass[indexPath.row]);
    if (class) {
        UIViewController *towardsVC = [class new];
        towardsVC.title = self.cellTitle[indexPath.row];
        [self.navigationController pushViewController:towardsVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AQL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AQL"];
    }
    cell.textLabel.text = self.cellTitle[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitle.count;
}

@end
