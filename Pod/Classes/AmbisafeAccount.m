/**
 * Copyright (c) 2015 Ambisafe Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including the rights to use, copy, modify,
 * merge, publish, distribute, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * @author Charlie Fontana <charlie@ambisafe.co>
 * @date 10/07/2015
 */

#import "AmbisafeService.h"
#import "AmbisafeAccount.h"
#import <objc/runtime.h>

@interface AmbisafeAccount ()

@end

@implementation AmbisafeAccount

- (AmbisafeAccount *)initWithContainer:(NSDictionary *)container password:(NSString *)password1
{
    self = [super init];
    if (self) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:container options:NSJSONWritingPrettyPrinted error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
            return nil;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@');account.data;", jsonString, password1];
        NSDictionary *account = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toDictionary];
        
        self.data = account[@"data"];
        self.iv = account[@"iv"];
        self.key = account[@"key"];
        self.privateKey = account[@"private_key"];
        self.publicKey = account[@"public_key"];
        self.salt = account[@"salt"];
        self.password = password1;
    }
    
    return self;
}

- (AmbisafeTransaction *)signTransaction:(AmbisafeTransaction *)tx
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@');account.signTransaction(%@);", [self getJSON], [self password], [tx stringify]];
    NSLog(@"%@", script);
    NSDictionary *txDictionary = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toDictionary];
    
    AmbisafeTransaction *signedtx = [[AmbisafeTransaction alloc] init:txDictionary];
    
    return signedtx;
};

- (NSString *)setNewPassword:(NSString *)password1
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@');account.setNewPassword('%@');", [self getJSON], [self password], password1];
    NSString *value = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toString];
    
    self.password = password1;
    
    return value;
};

- (NSString *)stringify
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@'); account.stringify();", [self getJSON], [self password]];
    NSString *value = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toString];
    
    return value;
};

- (NSString *)parse:(NSString *)data1
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@'); account.parse('%@');", [self getJSON], [self password], data1];
    NSString *value = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toString];
    
    return value;
};

- (NSDictionary *)getContainer
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@'); account.getContainer();", [self getJSON], [self password]];
    NSDictionary *container = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toDictionary];
    
    return container;
};

- (NSString *)getStringContainer
{
    NSString *script = [NSString stringWithFormat:@"var account = new Ambisafe.Account(%@, '%@');account.getStringContainer();", [self getJSON], [self password]];
    NSString *container = [[[[AmbisafeService getInstance] getJsContext] evaluateScript:script] toString];
    
    return container;
};

- (NSDictionary *)dictionaryReflectFromAttributes
{
    @autoreleasepool
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *attributes = class_copyPropertyList([self class], &count);
        objc_property_t property;
        NSString *key1, *value1;
        
        for (int i = 0; i < count; i++)
        {
            property = attributes[i];
            key1 = [NSString stringWithUTF8String:property_getName(property)];
            value1 = [self valueForKey:key1];
            [dict setObject:(value1 ? value1 : @"") forKey:key1];
        }
        
        free(attributes);
        attributes = nil;
        
        return dict;
    }
}

- (NSString *) getJSON
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionaryReflectFromAttributes] options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return json;
}

@end
