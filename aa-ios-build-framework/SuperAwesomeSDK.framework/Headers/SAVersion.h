//
//  SAVersion.h
//  Pods
//
//  Created by Gabriel Coman on 26/07/2017.
//
//

#import <Foundation/Foundation.h>

@interface SAVersion : NSObject

/**
 * Getter for a string comprising of SDK & version bundled
 *
 * @return  a string
 */
+ (NSString*) getSdkVersion;

/**
 * Method that overrides the current version string.
 * It's used by the AIR & Unity SDKs
 *
 * @param version the new version
 */
+ (void) overrideVersion: (NSString*) version;

/**
 * Method that overrides the current sdk string.
 * It's used by the AIR & Unity SDKs
 *
 * @param sdk the new sdk
 */
+ (void) overrideSdk: (NSString*) sdk;

@end
