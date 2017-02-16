//
//  FlickrURL.m
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "FlickrURL.h"

@implementation FlickrURL

+ (NSURL *)URLForQuery:(NSString *)query {
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=371ce0f45a8bc73c2827560200eee82e", query];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:set];
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLforTopTags {
    return [self URLForQuery:@"https://api.flickr.com/services/rest/?method=flickr.tags.getHotList"];
}

@end

