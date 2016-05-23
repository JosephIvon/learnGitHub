//
//  ViewController.m
//  UIStackView
//
//  Created by fanwenbo on 16/5/6.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *starStackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)addStar:(id)sender {
    UIImageView * star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    [self.starStackView addArrangedSubview:star];
    [UIView animateWithDuration:0.3f animations:^{
        [self.starStackView layoutIfNeeded];
    }];
}

- (IBAction)removeStar:(id)sender {
    UIImageView * star = self.starStackView.subviews.lastObject;
    [self.starStackView removeArrangedSubview:star];
    [star removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [self.starStackView layoutIfNeeded];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
