//
//  WebSocketManager.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager : NSObject

- (id)init;


//初始化Socket并发起连接
- (void)socketConnectHost;


// 发送文本和简单表情
- (BOOL)sendText:(NSString *) strSend;

@end

NS_ASSUME_NONNULL_END
