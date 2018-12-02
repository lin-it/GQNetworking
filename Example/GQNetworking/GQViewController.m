//
//  GQViewController.m
//  GQNetworking
//
//  Created by lin-it on 11/30/2018.
//  Copyright (c) 2018 lin-it. All rights reserved.
//

#import "GQViewController.h"
#import <GQNetworking/GQNetworkEngine.h>

@interface GQViewController ()

@end

@implementation GQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GQNetworkEngine GET:@"api/xxx" parameters:@{} progress:nil success:^(id data) {
        NSLog(@"%@",data);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
