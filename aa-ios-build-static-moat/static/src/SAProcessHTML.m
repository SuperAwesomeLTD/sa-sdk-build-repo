/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAProcessHTML.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAExtensions.h>)
#import <SAUtils/SAExtensions.h>
#else
#import "SAExtensions.h"
#endif
#endif

@implementation SAProcessHTML

+ (NSString*) formatCreativeIntoImageHTML:(SAAd*) ad {
    
    NSString *imgString = @"<a href='hrefURL'><img src='imageURL'/></a>_MOAT_";
    
    if (ad.creative.details.image) {
        imgString = [imgString stringByReplacingOccurrencesOfString:@"imageURL" withString:ad.creative.details.image];
    }

    
    if (ad.creative.clickUrl) {
        return [imgString stringByReplacingOccurrencesOfString:@"hrefURL" withString:ad.creative.clickUrl];
    } else {
        return [[imgString stringByReplacingOccurrencesOfString:@"<a href='hrefURL'>" withString:@""]
                stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    }
    
    return imgString;
}

+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*) ad {
    
    // the img string
    NSString *rmString = @"<iframe style='padding:0;margin:0;border:0;' width='100%' height='100%' src='richMediaURL'></iframe>_MOAT_";
    
    // format template parameters
    NSMutableString *richMediaString = [@"" mutableCopy];
    [richMediaString appendString:ad.creative.details.url];
    
    NSDictionary *richMediaDict = @{
        @"placement":@(ad.placementId),
        @"line_item":@(ad.lineItemId),
        @"creative":@(ad.creative._id),
        @"rnd":[NSNumber numberWithInteger:[SAUtils getCachebuster]]
    };
    [richMediaString appendString:@"?"];
    [richMediaString appendString:[SAUtils formGetQueryFromDict:richMediaDict]];
    
    // return the parametrized template
    NSString *richString = [rmString stringByReplacingOccurrencesOfString:@"richMediaURL" withString:richMediaString];
    
    richString = [richString stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    return richString;
}

+ (NSString*) formatCreativeIntoTagHTML:(SAAd*) ad {
    
    // the img string
    NSString *tagHtml = @"tagdata_MOAT_";
    
    // format template parameters
    NSString *tagString = ad.creative.details.tag;
    
    if (ad.creative.clickUrl) {
        tagString = [[tagString stringByReplacingOccurrencesOfString:@"[click]" withString:[NSString stringWithFormat:@"%@&redir=", ad.creative.clickUrl]]
                     stringByReplacingOccurrencesOfString:@"[click_enc]" withString:[SAUtils encodeURI:ad.creative.clickUrl]];
    } else {
        tagString = [[tagString stringByReplacingOccurrencesOfString:@"[click]" withString:@""]
                     stringByReplacingOccurrencesOfString:@"[click_enc]" withString:@""];
    }
    
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[keywords]" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[timestamp]" withString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    //    tagString = [tagString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    tagString = [tagString stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    NSString *html = [tagHtml stringByReplacingOccurrencesOfString:@"tagdata" withString:tagString];
    //    html = [html stringByReplacingOccurrencesOfString:@"\/" withString:@"/"];
    //    html = [html stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    //    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    
    // return the parametrized template
    return html;
}

@end
