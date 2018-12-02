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


#pragma mark - public

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         headers:(NSDictionary *)headers
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSError *serializationError;
    NSMutableURLRequest *request = [self.afSessionManager.requestSerializer
                                    requestWithMethod:method
                                    URLString:[[NSURL URLWithString:URLString relativeToURL:self.afSessionManager.baseURL]
                                               absoluteString]
                                    parameters:parameters
                                    error:&serializationError];
    
    if (request == nil || request.URL == nil) {
        dispatch_async(self.afSessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
            failure(nil, nil);
        });
        return nil;
    }
    
    if (serializationError) {
        dispatch_async(self.afSessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
            failure(nil, serializationError);
        });
        return nil;
    }
    
    for (NSString *key in headers) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.afSessionManager
                dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
                    if (error) {
                        failure(dataTask, error);
                    } else {
                        success(dataTask, responseObject);
                    }
                }];
    
    [dataTask resume];
    
    return dataTask;
}

#pragma mark - set & get

- (AFHTTPSessionManager *)afSessionManager {
    if (!_afSessionManager) {
        _afSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        
        _afSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _afSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                            @"text/json",
                                                                                            @"text/javascript",
                                                                                            @"application/x-javascript",
                                                                                            @"application/javascript",
                                                                                            ]];
    }
    return _afSessionManager;
}

@end
