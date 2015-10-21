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
#import <JavaScriptCore/JavaScriptCore.h>
#import "AmbisafeAccount.h"
#import "AmbisafeTransaction.h"

@interface AmbisafeService : NSObject

+ (AmbisafeService *)getInstance;

- (JSContext *)getJsContext;

- (AmbisafeAccount *)generateAccount:(NSString *)currency
                    password:(NSString *)password
                        salt:(NSString *)salt;

- (NSDictionary *)generateKeyPair;

- (AmbisafeTransaction *)signTransaction:(AmbisafeTransaction *)tx
                      privateKey:(NSString *)privateKey;

- (NSString *)generateRandomValue:(NSNumber *)lenght;

- (NSString *)deriveKey:(NSString *)password
                   salt:(NSString *)salt
                  depth:(NSNumber *)depth;

- (NSString *)encrypt:(NSString *)cleardata
                   iv:(NSString *)iv
             cryptkey:(NSString *)cryptkey;

- (NSString *)decrypt:(NSString *)encryptdata
                   iv:(NSString *)iv
             cryptkey:(NSString *)cryptkey;

- (NSString *)SHA1:(NSString *)input;

@end
