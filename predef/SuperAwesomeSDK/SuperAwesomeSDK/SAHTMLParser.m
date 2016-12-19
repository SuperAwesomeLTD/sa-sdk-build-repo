//
//  SAFormatter.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

// import header
#import "SAHTMLParser.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAModelSpace.h>)
#import <SAModelSpace/SAModelSpace.h>
#else
#import "SAModelSpace.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif


@implementation SAHTMLParser

+ (NSString*) formatCreativeDataIntoAdHTML:(SAAd*)ad {
    
    switch (ad.creative.creativeFormat) {
        case image:{
            return [self formatCreativeIntoImageHTML:ad];
            break;
        }
        case video:{
            return nil;
            break;
        }
        case rich:{
            return [self formatCreativeIntoRichMediaHTML:ad];
            break;
        }
        case tag:{
            return [self formatCreativeIntoTagHTML:ad];
            break;
        }
        case invalid:
        default:{
            return nil;
            break;
        }
    }
}

+ (NSString*) formatCreativeIntoImageHTML:(SAAd*)ad {
    
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    [htmlString appendString:@"<!DOCTYPE html><html><head><meta charset=\"UTF-8\"/>"];
    [htmlString appendString:@"<meta name='viewport' content='width=device-width, initial-scale=_PARAM_SCALE_, maximum-scale=_PARAM_SCALE_, user-scalable=no' />"];
    [htmlString appendString:@"<title>SuperAwesome Image Template</title>"];
    [htmlString appendString:@"<style>html, body, div { margin: 0px; padding: 0px; width: 100%; height: 100%; overflow: hidden; background-color: #efefef; }</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"<a href='hrefURL'>"];
    [htmlString appendString:@"<img id='image' src='imageURL'/>"];
    [htmlString appendString:@"</a>"];
    [htmlString appendString:@"_MOAT_"];
    [htmlString appendString:@"</body></html>"];
    
    // determine the Click URL
    NSString *click = ad.creative.clickUrl;
    
    if (!click) {
        NSArray *potentialClicks = [ad.creative.events filterBy:@"event" withValue:@"sa_tracking"];
        if ([potentialClicks count] > 1) {
            click = [potentialClicks objectAtIndex:0];
        }
    }
    
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"hrefURL" withString:click] mutableCopy];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"imageURL" withString:ad.creative.details.image] mutableCopy];
    return htmlString;
}

+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*)ad {
    
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    [htmlString appendString:@"<!DOCTYPE html><html><head>"];
    [htmlString appendString:@"<meta name='viewport' content='width=device-width, initial-scale=_PARAM_SCALE_, maximum-scale=_PARAM_SCALE_, user-scalable=no, target-densitydpi=device-dpi'/>"];
    [htmlString appendString:@"<title>SuperAwesome Rich Media Template</title>"];
    [htmlString appendString:@"<style>html, body, iframe { width: 100%; height: 100%; padding: 0; margin: 0; border: 0; background-color: #efefef; overflow: hidden; }</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"<iframe src='richMediaURL'></iframe>"];
    [htmlString appendString:@"_MOAT_"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    
    // format template parameters
    NSMutableString *richMediaString = [[NSMutableString alloc] init];
    [richMediaString appendString:ad.creative.details.url];
    
    NSDictionary *richMediaDict = @{
        @"placement":[NSNumber numberWithInteger:ad.placementId],
        @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
        @"creative":[NSNumber numberWithInteger:ad.creative._id],
        @"rnd":[NSNumber numberWithInteger:[SAAux getCachebuster]]
    };
    [richMediaString appendString:@"?"];
    [richMediaString appendString:[SAAux formGetQueryFromDict:richMediaDict]];
    
    // return the parametrized template
    NSString *richString = [htmlString stringByReplacingOccurrencesOfString:@"richMediaURL" withString:richMediaString];
    
    richString = [richString stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    return richString;
}

+ (NSString*) formatCreativeIntoTagHTML:(SAAd*)ad {
    
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    [htmlString appendString:@"<!DOCTYPE html><html><head><meta charset=\"UTF-8\"/>"];
    [htmlString appendString:@"<title>SuperAwesome 3rd Party Tag Template</title>"];
    [htmlString appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=_PARAM_SCALE_, maximum-scale=_PARAM_SCALE_, user-scalable=no, target-densitydpi=device-dpi\"/>"];
    [htmlString appendString:@"<style>"];
    [htmlString appendString:@"html, body { width: _WIDTH_px; height: _HEIGHT_px; padding: 0; margin: 0; border: 0; background-color: #efefef; }"];
    [htmlString appendString:@"* { width: 100%; height: 100%; }"];
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"tagdata"];
    [htmlString appendString:@"_MOAT_"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    
    // format template parameters
    NSString *tagString = ad.creative.details.tag;
    
    NSString *click = ad.creative.clickUrl;
    
    if (!click) {
        NSArray *potentialClicks = [ad.creative.events filterBy:@"event" withValue:@"sa_tracking"];
        if ([potentialClicks count] > 1) {
            click = [potentialClicks objectAtIndex:0];
        }
    }
    
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click]" withString:[NSString stringWithFormat:@"%@&redir=",click]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click_enc]" withString:[SAAux encodeURI:click]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[keywords]" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[timestamp]" withString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    NSString *html = [htmlString stringByReplacingOccurrencesOfString:@"tagdata" withString:tagString];
    // html = [html stringByReplacingOccurrencesOfString:@"\/" withString:@"/"];
    html = [html stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    
    // return the parametrized template
    return html;
}

@end
