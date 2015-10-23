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
#import "AmbisafeTransaction.h"

@interface AmbisafeAccount : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *iv;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, copy) NSString *privateKey;
@property (nonatomic, copy) NSString *password;

/*!
 * Defines the Account constructor based on a container and a password.
 *
 * \param {NSDictionary} container.
 * \param {NSString} password.
 * \return none.
 */
- (AmbisafeAccount *)initWithContainer:(NSDictionary *)container password:(NSString *)password;

/*!
 * Instance method that signs a transaction.
 *
 * \param {AmbisafeTransaction} tx unsigned transaction: {hex:'...', fee:'...', sighashes:['...', '...']}.
 * \return {AmbisafeTransaction} signed transaction.
 */
- (AmbisafeTransaction *)signTransaction:(AmbisafeTransaction *)tx;

/*!
 * Instance method that set a new password
 *
 * \param {NSString} password
 * \return none.
 */
- (NSString *)setNewPassword:(NSString *)password;

/*!
 * Instance method that returns the Account's data in a JSON format
 *
 * \return {NSString} return the account data as NSString.
 */
- (NSString *)stringify;

/*!
 * Instance method that parse the Account's data
 *
 * \param {NSString} data return the account data as NSString
 * \return none.
 */
- (NSString *)parse:(NSString *)data;

/*!
 * Instance method that get the Account's container as a NSObject
 *
 * \return {NSObject}
 */
- (NSObject *)getContainer;

/*!
 * Instance method that get the Account's container as NSString
 *
 * \return {NSString}
 */
- (NSString *)getStringContainer;

@end
