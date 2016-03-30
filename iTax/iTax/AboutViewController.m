//
//  AboutViewController.m
//  iTax
//
//  Created by lpc on 16/3/30.
//  Copyright © 2016年 Paddy-long. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *aboutWebV;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"tax" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.aboutWebV loadRequest:request];
}

@end
