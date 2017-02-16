//
//  ViewController.m
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "ViewController.h"
#import "TodayViewController.h"
#import "MMWormhole.h"

@interface ViewController ()

@property (nonatomic, strong) MMWormhole *Wormhole;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) NSNumber *randomNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tagsArray = [NSMutableArray new];
    self.Wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.digdes.TodayExtensionSharingDefaults" optionalDirectory:nil];
    [self.Wormhole listenForMessageWithIdentifier:@"button" listener:^(id messageObject) {
        self.randomNumber = @(arc4random() % 100);
        self.numberLabel.text = [self.randomNumber stringValue];
        NSString *string = [self.randomNumber stringValue];
        [tagsArray addObject: string];
        NSLog(@"%@",string);
        NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.digdes.ExtensionSharing"];
               [mySharedDefaults setObject: string forKey: @"MyKey"];
               [mySharedDefaults synchronize];
    }];
}

@end
