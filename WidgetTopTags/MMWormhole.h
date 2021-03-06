//
//  MMWormhole.h
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMWormholeTransiting.h"

typedef NS_ENUM(NSInteger, MMWormholeTransitingType) {
   MMWormholeTransitingTypeFile = 0,
    MMWormholeTransitingTypeCoordinatedFile,
    MMWormholeTransitingTypeSessionContext,
    MMWormholeTransitingTypeSessionMessage,
    MMWormholeTransitingTypeSessionFile
};

NS_ASSUME_NONNULL_BEGIN

@interface MMWormhole : NSObject <MMWormholeTransitingDelegate>

@property (nonatomic, strong) id<MMWormholeTransiting> wormholeMessenger;

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory NS_DESIGNATED_INITIALIZER;

- (void)passMessageObject:(nullable id <NSCoding>)messageObject
			   identifier:(nullable NSString *)identifier;

- (nullable id)messageWithIdentifier:(nullable NSString *)identifier;

- (void)listenForMessageWithIdentifier:(nullable NSString *)identifier
                              listener:(nullable void (^)(__nullable id messageObject))listener;
@end

NS_ASSUME_NONNULL_END
