//
//  EncryptAndDecryptTool.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "EncryptAndDecryptTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define CC_MD5_DIGEST_LENGTH    16

@implementation EncryptAndDecryptTool
+ (instancetype)sharedSingleton {
    static EncryptAndDecryptTool *_encryptAndDecryptTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _encryptAndDecryptTool = [[EncryptAndDecryptTool alloc] init];
    });
    return _encryptAndDecryptTool;
}
//
//// 防止外部调用alloc 或者 new
//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [EncryptAndDecryptTool sharedSingleton];
//}
//
//// 防止外部调用copy
//- (id)copyWithZone:(nullable NSZone *)zone {
//    return [EncryptAndDecryptTool sharedSingleton];
//}
//
//// 防止外部调用mutableCopy
//- (id)mutableCopyWithZone:(nullable NSZone *)zone {
//    return [EncryptAndDecryptTool sharedSingleton];
//}

#pragma mark - MD5
//算法实现
- (NSString *)md5_32:(NSString *)text upperCase:(BOOL)uppuerCase {
    // 1、转化为UTF8字符串
    const char *chars = [text UTF8String];
    // 2、设置一个接收字符数组
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    // 3、把str字符串转换成为32位的16进制数列，存到result中
    CC_MD5(chars, (int)strlen(chars), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:1];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        // 4、将16字节的16进制转成32字节的16进制字符串
        [result appendFormat:@"%02x", digest[i]];
    }
    
    if (uppuerCase) {
        return [result uppercaseString];
    } else {
        return [result lowercaseString];
    }
}

- (NSString *)md5_16:(NSString *)text upperCase:(BOOL)uppuerCase  {
    NSString *md5_32 = [self md5_32:text upperCase:uppuerCase];
    
    // 从32位中提取9~24位
    return [[md5_32 substringToIndex:24] substringFromIndex:8];
}

#pragma mark - AES加密
// 对NSData加密
- (NSData *)AESEncryptWithData:(NSData *)data Key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if(cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    
    return nil;
}

// 对NSData解密
- (NSData *)AESDecryptWithData:(NSData *)data andKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    if(cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    
    return nil;
}

// 对NSString加密（实际上是先把字符串转化为NSData进行加密，再把加密后的NSData转化为字符串）
- (NSString *)AESEncryptWithString:(NSString *)string andKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];//
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        NSString *stringBase64 = [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
        return stringBase64;
        
    }
    free(buffer);
    return nil;}

// 对NSString解密（实际上是先把字符串转化为NSData进行解密，再把解密后的NSData转化为字符串）
- (NSString *)AESDecryptWithString:(NSString *)string andKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];//base64解码
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}


#pragma mark - applePay支付加解密
// 获取私钥
// 传入.p12的私钥文件路径和密码
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password {
    
    NSData *p12Data = [NSData dataWithContentsOfFile:filePath];
    if (!p12Data) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}
 
 
// 解密数据，返回字符串类型
+ (NSString *)decryptWrappedKey:(NSString *)str
   privateKeyWithContentsOfFile:(NSString *)path
                       password:(NSString *)password
{
    SecKeyRef keyRef = [self getPrivateKeyRefWithContentsOfFile:path password:password];
    NSData *origionData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    
    CFErrorRef errorRef = nil;
    
    size_t blockBytes = SecKeyGetBlockSize(keyRef);
    size_t src_block_size = blockBytes;
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    for (int idx = 0; idx < origionData.length; idx += src_block_size)
    {
        NSData *targetData = [[origionData subdataWithRange:NSMakeRange(idx, src_block_size)] copy];
        CFDataRef targetDataRef = (__bridge CFDataRef)(targetData);
        CFDataRef dataRef = SecKeyCreateDecryptedData(keyRef, kSecKeyAlgorithmRSAEncryptionOAEPSHA256, targetDataRef, &errorRef);
        
        if (dataRef != nil) {
            NSData *partData = (__bridge NSData *)(dataRef);
            [resultData appendData:partData];
        }
        
        if (errorRef != nil) {
            NSLog(@"error = %@", errorRef);
        }
        
        NSUInteger leftSize = origionData.length - idx - src_block_size;
        
        if ((leftSize < src_block_size) && leftSize > 0) {
            // 剩余部分也要解密
            NSData *targetData2 = [[origionData subdataWithRange:NSMakeRange(idx + src_block_size, leftSize)] copy];
            CFDataRef targetDataRef2 = (__bridge CFDataRef)(targetData2);
            CFDataRef dataRef2 = SecKeyCreateDecryptedData(keyRef, kSecKeyAlgorithmRSAEncryptionOAEPSHA256, targetDataRef2, &errorRef);
            
            if (dataRef2 != nil) {
                NSData *partData2 = (__bridge NSData *)(dataRef2);
                [resultData appendData:partData2];
            }
            
            break;
        }
    }
    
    if (resultData.length == 0) {
        return nil;
    }
    else {
        //2.把二进制数据转换为字符串返回
        return [resultData base64EncodedStringWithOptions:0];
    }
}
@end
