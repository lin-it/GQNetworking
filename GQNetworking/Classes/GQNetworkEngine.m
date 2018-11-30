//
//  GQNetworkEngine.m
//  AFNetworking
//
//  Created by 林国强 on 2018/11/30.
//

#import "GQNetworkEngine.h"
#import <AFNetworking/AFNetworking.h>


@interface GQNetworkEngine()

@property (nonatomic, strong) AFHTTPSessionManager *afSessionManager;

@end

@implementation GQNetworkEngine

+ (GQNetworkEngine *)sharedEngine {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - set & get

- (AFHTTPSessionManager *)afSessionManager {
    if (!_afSessionManager) {
        _afSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    }
    return _afSessionManager;
}

@end
