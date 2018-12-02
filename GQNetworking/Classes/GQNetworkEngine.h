//
//  GQNetworkEngine.h
//  AFNetworking
//
//  Created by 林国强 on 2018/11/30.
//

#import <Foundation/Foundation.h>

@interface GQNetworkEngine : NSObject

+ (GQNetworkEngine *)sharedEngine;

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         headers:(NSDictionary *)headers
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

