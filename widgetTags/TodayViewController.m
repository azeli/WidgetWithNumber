//
//  TodayViewController.m
//  widgetTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TableViewCell.h"
#import "MMWormhole.h"


@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MMWormhole *wormhole;
@property (strong, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableViewTopTags;
@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (IBAction)didTap:(UIButton *)sender {
    [self.wormhole passMessageObject:@{@"buttonNumber" : @(1)} identifier:@"button"];
    NSLog(@"test");
    [self updateArrayText];
    [_tableViewTopTags reloadData];
    [self viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.digdes.TodayExtensionSharingDefaults" optionalDirectory:nil];
    _outLabel.text = @" ";
    [_tableViewTopTags reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableViewTopTags reloadData];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    if(_Button.selected){
        [_tableViewTopTags reloadData];
        completionHandler(NCUpdateResultNewData);
    }
    completionHandler(NCUpdateResultNewData);
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    
    [self updateArrayText];
}

- (void)updateArrayText {
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.digdes.ExtensionSharing"];
    NSString *value = [myDefaults objectForKey:@"MyKey"];
    [tagsArray2 addObject: value];
    _outLabel.text = value;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGRectGetHeight(self.view.bounds)/8;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [tagsArray2 count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    //cell.cellLabel.text = [tagsArray2 objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
