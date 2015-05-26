//
//  CYSecureEngine.m
//  CYiOS8_Day31_TouchID
//
//  Created by Constance Yang on 15/5/13.
//  Copyright (c) 2015年 Constance Yang. All rights reserved.
//

#import "CYSecureEngine.h"

#import <Security/Security.h>

#define kServiceIdentifier @"constance.service.keychain.identifier"
#define kAccountName @"constance.accountName"

@implementation CYSecureEngine
@synthesize secretString = _secretString;

#pragma mark -- 
#pragma mark -- override getter and setter method

-(NSString *)secretString
{
    return [self loadToken];
}

-(void)setSecretString:(NSString *)newSecretString
{
    if(newSecretString.length > 0)
    {
        [self saveToken:newSecretString];
    }
    else
    {
        [self deleteToken];
    }
}

#pragma mark --
#pragma mark -- save the token

-(void)saveToken:(NSString *)token
{
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [self deleteToken];
    
    CFErrorRef sacError = NULL;
    
    SecAccessControlRef control = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, kSecAccessControlUserPresence, &sacError);
    
    if(sacError != NULL || control == NULL)
    {
        NSLog(@"some error occur create SecAccessControlRef");
        
        return;
    }
    
    NSDictionary *tokenDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
                               kServiceIdentifier,(__bridge id)kSecAttrService,
                               kAccountName,(__bridge id)kSecAttrAccount,
                               tokenData,(__bridge id)kSecValueData,
                               @YES,(__bridge id)kSecUseNoAuthenticationUI,
                               control,(__bridge id)kSecAttrAccessControl,nil];
    
    SecItemAdd((__bridge CFDictionaryRef)tokenDict, nil);
}

-(void)deleteToken
{
    NSDictionary *tokenDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,kServiceIdentifier,(__bridge id)kSecAttrService,kAccountName,(__bridge id)kSecAttrAccount,nil];
    
    SecItemDelete((__bridge CFDictionaryRef)tokenDict);
}

-(NSString *)loadToken
{
    NSDictionary *tokenDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
                               kServiceIdentifier,(__bridge id)kSecAttrService,
                               kAccountName,(__bridge id)kSecAttrAccount,
                               @YES,(__bridge id)kSecReturnData,
                               (__bridge id)kSecMatchLimitOne,(__bridge id)kSecMatchLimit,
                               @"Authenticate to retrieve your secret",(__bridge id)kSecUseOperationPrompt,nil];
    
    NSString *contentOfString = nil;
    
    CFDataRef resultData = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)tokenDict,(CFTypeRef *)&resultData);
    
    if(status == noErr)
    {
        contentOfString = [[NSString alloc]initWithData:(__bridge_transfer NSData *)resultData encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSLog(@"nothing can be retrieved!");
    }
    
    NSLog(@"item in keychain = %@",contentOfString);
    
    return contentOfString;
}

@end
