//
//  WebSocketManager.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "WebSocketManager.h"
#import "SocketRocket/SRWebSocket.h"

@interface WebSocketManager ()<SRWebSocketDelegate>
{
    
    BOOL socketHost;  //是否获取了服务器端口
    BOOL longSocket;  //是否连接正常
    NSString *Host;
    NSInteger Port;
    NSInteger errCount;      //重连次数计数器
}

// websocket
@property(nonatomic,strong)SRWebSocket *webSocket;

// 长连接计时器
@property(nonatomic,strong)NSTimer *connectTimer;

@end

@implementation WebSocketManager


- (id)init {
    if (self=[super init]) {
        // Initialize self.
        //        Host = @"127.0.0.1";
        //        Port = 1234;
        errCount = 0;
        Host = @"192.168.10.131";
        Port = 6406;
        
        //  http://192.168.10.208:6406/mallKefu/custSocket/customerId
    }
    return self;
}


//初始化Socket并发起连接
- (void)socketConnectHost{
    if (!_webSocket)
     {
        _webSocket=nil;
     }
    
    //_webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://echo.websocket.org"]];
    //_webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"http://192.168.10.208:6406/mallKefu/custSocket/customerId"]];
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"http://192.168.10.208:6406/mallKefu/custSocket/customerId"]];
    _webSocket.delegate = self;
    
    [_webSocket open];
    
    
    
}


//--------------------------------------
#pragma mark - SRWebSocketDelegate
///--------------------------------------

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    //self.title = @"Connected!";
    
    //连接成功
    longSocket = YES;
    // 每隔20秒向服务器发送心跳包  一般设置30秒发送一次心跳包
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [_connectTimer fire];
}

// 发生错误
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":Websocket Failed With Error %@", error);
    
    //self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
    
    // 发生错误，重连
    [self reConnect];
}

// 连接失败/连接断开
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed  reason:%@",reason);
    //self.title = @"Connection Closed! (see logs)";
   
    [self reConnect];

}


-(void) reConnect
{
    errCount ++;
    //连接失败
    longSocket = NO;
    //取消定时器
    [_connectTimer invalidate];
    _connectTimer = nil;
    
    if (errCount <= 5) {
        [_webSocket close];
        // 延迟执行 ，重连接
        [self performSelector:@selector(socketConnectHost) withObject:nil afterDelay:1.0];// 延迟执行
    }else if(errCount == 6){
        //重新获取服务器端口
        //[self socketURL];
    }
}

// 收到数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string
{
    NSLog(@"Received \"%@\"", string);
    //[self _addMessage:[[TCMessage alloc] initWithMessage:string incoming:YES]];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"WebSocket received pong");
}

#pragma mark ---  发送函数
// 发送心跳包
- (void)longConnectToSocket {
    
    // 根据服务器要求发送固定格式的数据
    NSLog(@"我要发心跳包了");
    //    NetMessageObj  *netObj = [[NetMessageObj alloc] init];
    //    netObj.deviceId = [DDGSetting sharedSettings].UUID_MD5;
    //    netObj.uid = [DDGSetting sharedSettings].uid;
    //    netObj.cmdName = @"0001";
    //    //    netObj.msgRemark = @{@"deviceId":[DDGSetting sharedSettings].UUID_MD5,@"uid":[DDGSetting sharedSettings].uid};
    //    NSData *dataStream =  [netObj packCmd];
    //    [_asyncSocket readDataWithTimeout:3 tag:1];
    //    [_asyncSocket writeData:dataStream withTimeout:1 tag:1];
    
}

// 发送文本和 简单表情
- (BOOL)sendText:(NSString *) strSend
{
    // 根据服务器要求发送固定格式的数据
    NSLog(@"我发送文本信息");
    
    if(!longSocket)
     {
        NSLog(@"网络连接断开，发送失败，即将进行重连");
        
        [self socketConnectHost];
        
        return FALSE;
     }
    
    
    NSMutableDictionary *dicMsgData = [[NSMutableDictionary alloc] init];
    dicMsgData[@"type="] = @"text";
    dicMsgData[@"contentText"] = strSend;
    
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @"1";
    dicSend[@"msgData"] = dicMsgData;
    
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (error!=nil)
     {
        NSLog(@"发送<%@>   失败：%@",strSend,error);
     }
    
    return sendSuccess;
}

@end
