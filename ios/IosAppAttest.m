// IosAppAttest.m

#import <Foundation/Foundation.h>
#import <React/RCTLog.h>

#import <DeviceCheck/DCAppAttestService.h>

#import "IosAppAttest.h"

@implementation IosAppAttest

// Export a module named IosAppAttest
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(attestationSupported:(RCTPromiseResolveBlock) resolve
                  rejector:(RCTPromiseRejectBlock) reject)
{
  RCTLogTrace(@"Checking if appAttest supported");
  if (@available(iOS 14, *)) {
    resolve(@(DCAppAttestService.sharedService.supported));
  } else {
    resolve(@NO);
  }
}

RCT_EXPORT_METHOD(generateKeys:(RCTPromiseResolveBlock) resolve
                  rejector:(RCTPromiseRejectBlock) reject)
{
  
  if (@available(iOS 14, *)) {
    DCAppAttestService *service = DCAppAttestService.sharedService;
    RCTLogTrace(@"Generating keys");

    [service generateKeyWithCompletionHandler:^(NSString * _Nullable keyId, NSError * _Nullable error) {
      NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
      if (error == nil) {
        resolve(keyId);
      } else {
        reject(@"Encountered unexpected error");//@([error code])
      }
    }];
  } else {
    reject(@"Attestation unsupported");
  }
}

RCT_EXPORT_METHOD(attestKeys:(NSString *) keyId
                  challengeHashBase64:(NSString*)challengeHashBase64
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejector:(RCTPromiseRejectBlock) reject)
{
  if (@available(iOS 14, *)) {
    DCAppAttestService *service = DCAppAttestService.sharedService;
    RCTLogTrace(@"Attesting key");

    NSData *challengeHash = [[NSData alloc] initWithBase64EncodedString:challengeHashBase64 options:0];
    [service attestKey:keyId clientDataHash:challengeHash completionHandler:^(NSData * _Nullable attestationObject, NSError * _Nullable error) {
      if (error == nil) {
        NSString *attestationBase64 = [attestationObject base64EncodedStringWithOptions:0];
        resolve(attestationBase64);
      } else {
        reject(@"Encountered unexpected error");//@([error code])
      }
    }];
  } else {
    reject(@"Attestation unsupported");
  }
}

RCT_EXPORT_METHOD(attestRequestData:(NSString*)requestDataHashBase64
                  withKey:(NSString*)keyId
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejector:(RCTPromiseRejectBlock) reject)
{
  if (@available(iOS 14, *)) {
    DCAppAttestService *service = DCAppAttestService.sharedService;
    RCTLogTrace(@"Attesting requestData");

    NSData *requestDataHash = [[NSData alloc] initWithBase64EncodedString:requestDataHashBase64 options:0];
    [service generateAssertion:keyId clientDataHash:requestDataHash completionHandler:^(NSData * _Nullable assertionObject, NSError * _Nullable error) {
      if (error == nil) {
        NSString *assertionBase64 = [assertionObject base64EncodedStringWithOptions:0];
        resolve(assertionBase64);
      } else {
        reject(@"Encountered unexpected error");//@([error code])
      }
    }];
  } else {
    reject(@"Attestation unsupported");
  }
}

@end
