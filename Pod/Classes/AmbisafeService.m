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


@interface AmbisafeService ()

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation AmbisafeService

+ (AmbisafeService *)getInstance
{
    static AmbisafeService *classInstance;
    
    @synchronized(self)
    {
        if (!classInstance)
        {
            classInstance = [[AmbisafeService alloc] init];
        }
    }
    
    return classInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.jsContext = [[JSContext alloc] init];
        
        [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *value) {
            NSLog(@"%@", value);
        }];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"ambisafe" ofType:@"js"];
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        [self.jsContext evaluateScript:script];
    }
    
    return self;
}

- (JSContext *)getJsContext
{
    return self.jsContext;
}

- (AmbisafeAccount *)generateAccount:(NSString *)currency password:(NSString *)password salt:(NSString *)salt
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.generateAccount('%@', '%@', '%@').getContainer();",
                        currency, password, salt];
    NSDictionary *container = [[self.jsContext evaluateScript:script] toDictionary];
    AmbisafeAccount *account = [[AmbisafeAccount alloc] initWithContainer:container password:password];
    
    return account;
};

- (NSDictionary *)generateKeyPair
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.generateKeyPair();"];
    NSDictionary *keyPair = [[self.jsContext evaluateScript:script] toDictionary];
    
    return keyPair;
};

- (AmbisafeTransaction *)signTransaction:(AmbisafeTransaction *)tx privateKey:(NSString *)privateKey
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.signTransaction(%@, '%@');", [tx stringify], privateKey];
    NSDictionary *txDictionary = [[self.jsContext evaluateScript:script] toDictionary];
    
    AmbisafeTransaction *signedtx = [[AmbisafeTransaction alloc] init:txDictionary];
    
    return signedtx;
};

- (NSString *)generateRandomValue:(NSNumber *)lenght
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.generateRandomValue(%@)", lenght];
    NSString *value = [[self.jsContext evaluateScript:script] toString];
    
    return value;
};

- (NSString *)deriveKey:(NSString *)password salt:(NSString *)salt depth:(NSNumber *)depth
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.deriveKey('%@', '%@', %@)", password, salt, depth];
    NSString *key = [[self.jsContext evaluateScript:script] toString];
    
    return key;
};

- (NSString *)encrypt:(NSString *)cleardata iv:(NSString *)iv cryptkey:(NSString *)cryptkey
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.encrypt('%@', '%@', '%@')", cleardata, iv, cryptkey];
    NSString *value = [[self.jsContext evaluateScript:script] toString];
    
    return value;
};

- (NSString *)decrypt:(NSString *)encryptdata iv:(NSString *)iv cryptkey:(NSString *)cryptkey
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.decrypt('%@', '%@', '%@')", encryptdata, iv, cryptkey];
    NSString *value = [[self.jsContext evaluateScript:script] toString];
    
    return value;
};

- (NSString *)SHA1:(NSString *)input
{
    NSString *script = [NSString stringWithFormat:@"Ambisafe.SHA1('%@');", input];
    NSString *value = [[self.jsContext evaluateScript:script] toString];
    
    return value;
};

@end
