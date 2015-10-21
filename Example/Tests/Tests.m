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
 * @date 10/20/2015
 */

#import <XCTest/XCTest.h>
#import "AmbisafeAccount.h"
#import "AmbisafeService.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSalt {
    XCTAssertEqualObjects([[AmbisafeService getInstance] SHA1:@"example"], @"c3499c2729730a7f807efb8676a92dcb6f8a3f8f");
}

- (void)testAccount {
    NSString* salt = [[AmbisafeService getInstance] SHA1:@"charly"];
    AmbisafeAccount* account = [[AmbisafeService getInstance] generateAccount:@"BTC" password:@"password" salt:salt];
    
    XCTAssertNotNil([account key]);
    XCTAssertNotNil([account data]);
    XCTAssertNotNil([account iv]);
    XCTAssertNotNil([account salt]);
    XCTAssertNotNil([account publicKey]);
    XCTAssertNotNil([account privateKey]);
}

- (void)generateRamdomValue {
    NSString* iv = [[AmbisafeService getInstance] generateRandomValue:[NSNumber numberWithInt:16]];
    XCTAssertNotNil(iv);
}
- (void)testGenerateKeyPair {
    NSDictionary* keypair = [[AmbisafeService getInstance] generateKeyPair];
    
    XCTAssertNotNil(keypair);
    XCTAssertNotNil([keypair valueForKey:@"private_key"]);
    XCTAssertNotNil([keypair valueForKey:@"public_key"]);
}

- (void)testDeriveKey {
    NSString* salt = [[AmbisafeService getInstance] SHA1:@"example"];
    NSString* derivedKey = [[AmbisafeService getInstance] deriveKey:@"hello" salt:salt depth:[NSNumber numberWithInt:1000]];
    
    XCTAssertNotNil(derivedKey);
}

- (void)testEncrypt {
    NSString* data = @"Example of text";
    NSString* iv = [[AmbisafeService getInstance] generateRandomValue:[NSNumber numberWithInt:16]];
    NSString* salt = [[AmbisafeService getInstance] SHA1:@"charly"];
    NSString* derivedKey = [[AmbisafeService getInstance] deriveKey:@"hello" salt:salt depth:[NSNumber numberWithInt:1000]];
    
    NSString* encryptedData = [[AmbisafeService getInstance] encrypt:data iv:iv cryptkey:derivedKey];
    NSString* decryptedData = [[AmbisafeService getInstance] decrypt:encryptedData iv:iv cryptkey:derivedKey];
    
    XCTAssertEqualObjects(data, decryptedData);
}

- (void)testSignTransaction {
    AmbisafeTransaction *tx = [[AmbisafeTransaction alloc] init];
    tx.hex = @"2340";
    tx.fee = @"0.0001 BTC";
    tx.sighashes = [NSArray arrayWithObjects:@"73020cb8c25f434e00473dcd71be5bcfc0adaf107e0b0f36499d5abf8bd2da18", nil];
    
    AmbisafeTransaction *signedtx2 = [[AmbisafeService getInstance] signTransaction:tx privateKey:@"9f1c4362cf11c5264c81330210a5c9715daf99cf54afe0d58eb86087eaa512a7"];
    
    NSArray *signatures = [NSArray arrayWithObjects:@"304402203f9d4ba19b8675653a6a6fe76a6b3e55cd545636bd1c2d384377d48d5042164302206667221e51643cfed26bd0d79e9c67b50dd543f1ff2f3dcab21374260dc7b4e8", nil];
    
    XCTAssertEqualObjects(signedtx2.hex, @"2340");
    XCTAssertEqualObjects(signedtx2.fee, @"0.0001 BTC");
    XCTAssertEqualObjects(signedtx2.sighashes, tx.sighashes);
    XCTAssertEqualObjects(signedtx2.userSignatures, signatures);
}

@end
