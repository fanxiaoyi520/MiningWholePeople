//
//  EncryptAndDecryptTool.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncryptAndDecryptTool : NSObject
+ (instancetype)sharedSingleton;

#pragma mark - MD5
- (NSString *)md5_32:(NSString *)text upperCase:(BOOL)uppuerCase;
- (NSString *)md5_16:(NSString *)text upperCase:(BOOL)uppuerCase;

#pragma mark - AES加密
// 对NSData加密
- (NSData *)AESEncryptWithData:(NSData *)data Key:(NSString *)key;
// 对NSData解密
- (NSData *)AESDecryptWithData:(NSData *)data andKey:(NSString *)key;
// 对NSString加密（实际上是先把字符串转化为NSData进行加密，再把加密后的NSData转化为字符串）
- (NSString *)AESEncryptWithString:(NSString *)string andKey:(NSString *)key;
// 对NSString解密（实际上是先把字符串转化为NSData进行解密，再把解密后的NSData转化为字符串）
- (NSString *)AESDecryptWithString:(NSString *)string andKey:(NSString *)key;

#pragma mark - applePay支付加解密
// 获取私钥
// 传入.p12的私钥文件路径和密码
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password;// 解密数据，返回字符串类型
+ (NSString *)decryptWrappedKey:(NSString *)str
   privateKeyWithContentsOfFile:(NSString *)path
                       password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
