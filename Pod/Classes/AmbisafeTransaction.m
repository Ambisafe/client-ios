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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "AmbisafeTransaction.h"

@interface AmbisafeTransaction ()

@end

@implementation AmbisafeTransaction

- (AmbisafeTransaction *)init:(NSDictionary *)json
{
    self = [super init];
    
    self.hex = json[@"hex"];
    self.fee = json[@"fee"];
    self.sighashes = json[@"sighashes"];
    self.userSignatures = json[@"user_signatures"];
    
    return self;
}

- (NSString *)stringify
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

- (NSDictionary *)dictionaryReflectFromAttributes
{
    @autoreleasepool
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *attributes = class_copyPropertyList([self class], &count);
        objc_property_t property;
        NSString *key, *value;
        
        for (int i = 0; i < count; i++)
        {
            property = attributes[i];
            key = [NSString stringWithUTF8String:property_getName(property)];
            value = [self valueForKey:key];
            [dict setObject:(value ? value : @"") forKey:key];
        }
        
        free(attributes);
        attributes = nil;
        
        return dict;
    }
}

@end
