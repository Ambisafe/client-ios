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

/*!
 * Static method that creates an account and save it. 
 * This supposed to happen after user have filled registration form and clicked submit.
 *
 * \param {NSString} currency as NSString
 * \param {NSString} password as NSString
 * \param {NSString} salt as NSString
 * \return {AmbisafeAccount} return the generated account object
 */
- (AmbisafeAccount *)generateAccount:(NSString *)currency
                    password:(NSString *)password
                        salt:(NSString *)salt;

/*!
 * Static method that generates a key pair and returns it as a NSDictionary object.
 *
 * \return {NSDictionary} key pair
 */
- (NSDictionary *)generateKeyPair;

/*!
 * Static method that signs a transaction.
 *
 * \param {AmbisafeTransaction} tx unsigned transaction: {hex:'...', fee:'...', sighashes:['...', '...']}.
 * \param {NSString} private_key.
 * \return {AmbisafeTransaction} signed transaction.
 */
- (AmbisafeTransaction *)signTransaction:(AmbisafeTransaction *)tx
                      privateKey:(NSString *)privateKey;

/*!
 * Static method that generates random values 
 *
 * \param {NSNumber} length
 * \return {NSString} return random value 
 */
- (NSString *)generateRandomValue:(NSNumber *)lenght;

/*!
 * Static method that derives a key from a password
 *
 * \param {NSString} password
 * \param {NSString} salt
 * \param {NSNumber} depth
 * \return {NSString} key
 */
- (NSString *)deriveKey:(NSString *)password
                   salt:(NSString *)salt
                  depth:(NSNumber *)depth;

/*!
 * Static method that encrypts an input based on the Advanced Encryption Standard (AES)
 *
 * \param {NSString} cleardata
 * \param {NSString} iv
 * \param {NSString} cryptkey
 * \return {NSString} encrypted data
 */
- (NSString *)encrypt:(NSString *)cleardata
                   iv:(NSString *)iv
             cryptkey:(NSString *)cryptkey;

/*!
 * Static method that decrypts an input based on the Advanced Encryption Standard (AES)
 *
 * \param {NSString} encryptdata
 * \param {NSString} iv 
 * \param {NSString} cryptkey
 * \return {NSString} decrypted text
 */
- (NSString *)decrypt:(NSString *)encryptdata
                   iv:(NSString *)iv
             cryptkey:(NSString *)cryptkey;

/*!
 * Static method that gets the SHA1 hash of a string
 *
 * \param {NSString} input
 * \return {NSString} SHA1 hash
 */
- (NSString *)SHA1:(NSString *)input;

@end
