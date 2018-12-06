//
//  GQRequest.m
//  AFNetworking
//
//  Created by 幸.😳 on 2018/12/1.
//

#import "GQRequest.h"
#import "GQNetworkEngine.h"


static id<GQRequestProtocol> delegate;

@interface GQRequest()
@property (nonatomic, strong) NSURLSessionTask *task;

@end


@implementation GQRequest

#pragma mark - delegate
+ (void)registerHandler:(id<GQRequestProtocol>)handler {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = handler;
    });
}

#pragma mark - public

- (void)sendRequest {
    __weak typeof(self) weakSelf = self;

    if ([delegate respondsToSelector:@selector(request:shouldStartWithError:)]) {
        NSError *error;
        if (NO == [delegate request:self shouldStartWithError:&error]) {
            if (self.errorBlock) {
                self.errorBlock(error);
            }
            return;
        }
    }
    
    self.task = [[GQNetworkEngine sharedEngine] dataTaskWithHTTPMethod:self.type URLString:self.route parameters:self.fields headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull result) {
        if(result) {
            id dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            if(weakSelf.successBlock) {
                weakSelf.successBlock(dict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if(weakSelf.errorBlock) {
            weakSelf.errorBlock(error);
        }
    }];
}

- (void)cancelRequest {
    [self.task cancel];
    self.task = nil;
}

- (NSString *)route {
    return [NSString stringWithFormat:@"%@://%@",self.scheme,self.url];
}

#pragma mark - ser & get

- (NSString *)scheme {
    if(_scheme.length == 0) {
        return @"http";
    }
    return _scheme;
}

- (NSMutableDictionary *)fields {
    if(!_fields) {
        _fields = @{}.mutableCopy;
    }
    return _fields;
}

@end


@implementation GQRequest (Subscript)

- (id)objectForKeyedSubscript:(id)key; //getter
{
    return self.fields[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key; //setter
{
    self.fields[key] = obj;
}

@end
