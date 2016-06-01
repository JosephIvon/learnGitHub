//
//  FWBViewController.m
//  FWBAutoScrollLabel
//
//  Created by fanwenbo on 16/5/6.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "FWBViewController.h"
#import "CBAutoScrollLabel.h"

@interface FWBViewController ()

@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *autoScrollLabel;

@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *NavigationBarScrollLabel;

@end

@implementation FWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.autoScrollLabel.text = @"This text may be clipped, but now it will be scrolled. This text will be scrolled even after device rotation.";
    self.autoScrollLabel.textColor = [UIColor redColor];
    self.autoScrollLabel.labelSpacing = 30; // distance between start and end labels
    self.autoScrollLabel.pauseInterval = 1.0; // seconds of pause before scrolling starts again
    self.autoScrollLabel.scrollSpeed = 30; // pixels per second
    self.autoScrollLabel.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    self.autoScrollLabel.font = [UIFont systemFontOfSize:22.0];
    self.autoScrollLabel.fadeLength = 12.f;
    self.autoScrollLabel.scrollDirection = CBAutoScrollDirectionLeft;
    self.autoScrollLabel.shadowOffset = CGSizeMake(3, 3);
    self.autoScrollLabel.shadowColor = [UIColor greenColor];
    [self.autoScrollLabel observeApplicationNotifications];
    
    // navigation bar auto scroll label
    self.NavigationBarScrollLabel.text = @"Navigation Bar Title... Scrolling... And scrolling.";
    self.NavigationBarScrollLabel.pauseInterval = 3.f;
    self.NavigationBarScrollLabel.font = [UIFont boldSystemFontOfSize:20];
    self.NavigationBarScrollLabel.textColor = [UIColor blackColor];
    [self.NavigationBarScrollLabel observeApplicationNotifications];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
