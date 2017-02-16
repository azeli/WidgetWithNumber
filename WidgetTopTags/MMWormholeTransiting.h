//
//  MMWormholeTransiting.h
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMWormholeTransiting <NSObject>


- (BOOL)writeMessageObject:(nullable id<NSCoding>)messageObject forIdentifier:(NSString *)identifier;

- (nullable id<NSCoding>)messageObjectForIdentifier:(nullable NSString *)identifier;

@end

@protocol MMWormholeTransitingDelegate <NSObject>

- (void)notifyListenerForMessageWithIdentifier:(nullable NSString *)identifier message:(nullable id<NSCoding>)message;

@end

NS_ASSUME_NONNULL_END
