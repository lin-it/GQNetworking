//
//  GQRequest.h
//  AFNetworking
//
//  Created by 幸.😳 on 2018/12/1.
//

#import <Foundation/Foundation.h>

@class GQRequest;
@protocol GQRequestProtocol <NSObject>

- (BOOL)request:(GQRequest *)request shouldStartWithError:(NSError **)error;


@end

@interface GQRequest : NSObject

@property (nonatomic, strong) NSMutableDictionary *fields;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) void(^successBlock)(id result);
@property (nonatomic, copy) void(^errorBlock)(NSError *error);

- (void)sendRequest;

- (void)cancelRequest;

- (NSString *)route;

+ (void)registerHandler:(id<GQRequestProtocol>)handler;



@end



@interface GQRequest (Subscript)

- (id)objectForKeyedSubscript:(id)key; //getter

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key; //setter

@end
