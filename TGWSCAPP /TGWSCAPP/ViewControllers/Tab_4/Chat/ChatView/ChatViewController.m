//
//  ViewController.m
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

// Demo的Url
// https://www.jianshu.com/p/c58ad8ad75a5

#import "ChatViewController.h"
#import "CSMessageCell.h"
#import "CSMessageModel.h"
#import "CSBigView.h"
#import "EmojiView.h"
#import "CSRecord.h"




#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHight [UIScreen mainScreen].bounds.size.height

@interface ChatViewController ()< UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CSMessageCellDelegate, EmojiViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat nowHeight;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) CSBigView *bigImageView;
@property (nonatomic, strong) EmojiView *ev;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSIndexPath *selectIndex;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self layoutNaviBarViewWithTitle:@"客服聊天"];
    
    

    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight - 44)   style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    // 设置数据库的名字
    NSDictionary *dic = [CommonInfo userInfo];
    if (dic)
     {
        bg_chat_tablename = [NSString stringWithFormat:@"chatmessage%@",dic[@"telephone"]];
     }

    [self getDBData];
    
    
    
    _bigImageView = [[CSBigView alloc] init];
    _bigImageView.frame = [UIScreen mainScreen].bounds;
    
    _ev = [[EmojiView alloc] initWithFrame:CGRectMake(0, ScreenHight - 180, ScreenWidth, 180)];
    _ev.hidden = YES;
    _ev.delegate = self;
    [self.view addSubview:_ev];
    
    
    /**
     想测试更多数据库功能,打开注释掉的代码即可.
     */
//    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    
    
   
    
    
    _tableView.separatorColor = [UIColor clearColor];
    
    
    //添加手势点击空白处隐藏 弹出框
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchHideView)];
    gesture.numberOfTapsRequired  = 1;
    [_tableView addGestureRecognizer:gesture];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    _ev.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    // 调整_tableView 的滚动位置
    [self tabeleViewMidScorllEnd:height];
    
    UIView *vi = [self.view viewWithTag:100];
    CGRect rec = vi.frame ;
    rec.origin.y = _nowHeight - height;
    vi.frame = rec;
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _ev.hidden = YES;

    // 滚动到最后一列
    [self tabeleViewScorllEnd];
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView *vi = [self.view viewWithTag:100];
    if (!vi)
    {
       _nowHeight =  SCREEN_HEIGHT- 44; //_tableView.frame.size.height;
       [self bottomView];
       
       [self tabeleViewScorllEnd];
    }
    
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMessageCell *cell=[CSMessageCell cellWithTableView:tableView messageModel:_dataArray[indexPath.row]];
    cell.delegate = self;
    cell.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMessageModel *model = _dataArray[indexPath.row];
    return [model cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (void)messageCellSingleClickedWith:(CSMessageCell *)cell
{
    
    [self.view endEditing:YES];
    
    
    if (_ev.hidden == NO)
    {
        _ev.hidden = YES;
        // 调整tableView的高度
        //_tableView.height = SCREEN_HEIGHT - 44 - NavHeight;
       [self tabeleViewScorllEnd];
       
        UIView *vi = [self.view viewWithTag:100];
        vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CSMessageModel *model = _dataArray[indexPath.row];
    if (model.messageType == MessageTypeVoice)
    {
        [[CSRecord ShareCSRecord] playRecord];
        
        if ([_selectIndex isEqual: indexPath] == NO)
        {
            
            CSMessageCell *cell1 = [self.tableView cellForRowAtIndexPath:_selectIndex];
            [cell1 stopVoiceAnimation];
            
            _selectIndex = indexPath;
            [cell startVoiceAnimation];
        }
        else
        {
            if (cell.voiceAnimationImageView.isAnimating)
            {
                [cell stopVoiceAnimation];
            }
            else
            {
                [cell startVoiceAnimation];
            }
        }
    }
    else if (model.messageType == MessageTypeImage)
    {
        _bigImageView.bigImageView.image = model.imageSmall;
        _bigImageView.show = YES;
        
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_bigImageView];
    }
    
}

#pragma mark  ---  布局底部输入框
-(void)bottomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44)];
    bgView.tag = 100;  // 底部view的 tag
    bgView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = [[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(49, 0, bgView.bounds.size.width - 152, 44)];
    textView.delegate = self;
    textView.tag = 101;
    textView.returnKeyType = UIReturnKeySend;
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textView.text = @"";
    [bgView addSubview:textView];


    
    UIButton *recordBtn = [[UIButton alloc] init];
    recordBtn.frame = CGRectMake(10, 5, 34, 34);
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(leaveBtnClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [recordBtn addTarget:self action:@selector(touchDown:)forControlEvents: UIControlEventTouchDragInside];
    [bgView addSubview:recordBtn];
    
    UIButton *emojiBtn = [[UIButton alloc] init];
    emojiBtn.frame = CGRectMake(bgView.frame.size.width - 83, 5, 34, 34);
    [emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    emojiBtn.tag = 12;
    [bgView addSubview:emojiBtn];
    
    UIButton *imageBtn = [[UIButton alloc] init];
    imageBtn.frame = CGRectMake(bgView.frame.size.width - 39, 5, 34, 34);
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.tag = 13;
    [bgView addSubview:imageBtn];
    
}

#pragma mark --- action
// 隐藏所有输入框，笑脸符号框
-(void) TouchHideView
{
    [self.view endEditing:YES];
    _ev.hidden = YES;
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, SCREEN_HEIGHT-44, [UIScreen mainScreen].bounds.size.width, 44);
    
}


#pragma mark ---  输入完成
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length == 0)
        {
            return NO;
        }
        CSMessageModel *model = [[CSMessageModel alloc] init];
       
        model.messageSenderType = MessageSenderTypeMe;
        model.messageType = MessageTypeText;
        model.messageText = textView.text;
        //model.showMessageTime=YES;
        //model.messageTime = @"16:40";
        [_dataArray addObject:model];
       
        [model bg_save];
       
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        textView.text = @"";
       
        [self.view endEditing:YES];
       
        return NO;
    }
    
    return YES;
}

// 把tableView 滚动到底部
-(void) tabeleViewScorllEnd
{
    if (_dataArray.count > 1)
     {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
//        //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexpath];
//        [self.tableView setContentOffset:CGPointMake(0,rectInTableView.origin.y) animated:YES];
    
     }
}


// 有弹出界面时， 需要将tableview 底部往上滚动
-(void) tabeleViewMidScorllEnd:(float) fHeight
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexpath];

    
    [self.tableView setContentOffset:CGPointMake(0,rectInTableView.origin.y - rectInTableView.size.height - fHeight) animated:YES];
}



static int iiii = 0;
- (void)touchDown:(UIButton *)btn
{
    if (iiii == 0)
    {
        [[CSRecord ShareCSRecord] beginRecord];
        iiii = 1;
    }
    
}
- (void)leaveBtnClicked:(UIButton *)btn
{
    iiii = 0;
    NSLog(@"松开了");
    [[CSRecord ShareCSRecord] endRecord];
}
- (void)btnClicked:(UIButton *)btn
{
    [self.view endEditing:YES];
    _ev.hidden = YES;
    //调整tableView的高度
    //_tableView.height = SCREEN_HEIGHT - 44 - NavHeight;
    //[self tabeleViewScorllEnd];
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
    switch (btn.tag)
    {
        case 11:
            
            break;
        case 12:
            
        {
            
            _ev.hidden = NO;
        
           // 调整_tableView的高度
           //_tableView.height = SCREEN_HEIGHT - 44 - NavHeight - 180;
           [self tabeleViewScorllEnd];
           
            UIView *vi = [self.view viewWithTag:100];
            CGRect rec = vi.frame ;
            rec.origin.y = _nowHeight - 180;
            vi.frame = rec;

        }
            
            break;
        case 13:
            {
                
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        
                        //图片选择是相册（图片来源自相册）
                        
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        //设置代理
                        
                        picker.delegate=self;
                        
                        //模态显示界面
                        
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    }
                    
                    else {
                        
                        NSLog(@"不支持相机");
                        
                    }
                    

                    NSLog(@"点击确认");
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        
                        //图片选择是相册（图片来源自相册）
                        
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        
                        //设置代理
                        
                        picker.delegate=self;
                        
                        //模态显示界面
                        
                        [self presentViewController:picker animated:YES completion:nil];
                        
                        
                        
                    }
                    
                    NSLog(@"点击确认");
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    NSLog(@"点击取消");
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            break;
        default:
            break;
    }
    NSLog(@"呀！我这个按钮别点击了！");
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
     {
        UIImage * image =info[UIImagePickerControllerOriginalImage];
        CSMessageModel * model = [[CSMessageModel alloc] init];
         //model.showMessageTime=YES;
         model.messageSenderType = MessageSenderTypeOther;
         model.messageType = MessageTypeImage;
         model.imageSmall = image;
         //model.messageTime = @"16:40";
         [_dataArray addObject:model];
        
         [model bg_save];
         
         [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                     animated:YES
                               scrollPosition:UITableViewScrollPositionMiddle];
         
        [self dismissViewControllerAnimated:YES completion:nil];
     }
   else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage * image =info[UIImagePickerControllerOriginalImage];
        CSMessageModel * model = [[CSMessageModel alloc] init];
        //model.showMessageTime=YES;
        model.messageSenderType = MessageSenderTypeOther;
        model.messageType = MessageTypeImage;
        model.imageSmall = image;
        //model.messageTime = @"16:40";
        [_dataArray addObject:model];
       
        [model bg_save];
        
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)showBigImage
{
    
}

#pragma mark --- EmojiViewDelegate
- (void)emojiClicked:(NSString *)strEmoji {
    UITextView *tv = [self.view viewWithTag:101];
    tv.text = [tv.text stringByAppendingString:strEmoji];
    
}



#pragma mark --- 数据库操作
-(void) initDB
{
    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageTime = @"2017年12月12日 16:37";
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = @"推开窗看见星星依然守在夜空中心中不免多了些暖暖的感动一闪一闪的光努力把黑夜变亮气氛如此安详你在我的生命中是那最闪亮的星一直在无声夜空守护着我们的梦这世界那么大 我的爱只想要你懂 陪伴我孤寂旅程你知道我的梦 你知道我的痛你知道我们感受都相同    就算有再大的风也挡不住勇敢的冲动    努力的往前飞 再累也无所谓    黑夜过后的光芒有多美    分享你我的力量就能把对方的路照亮    我想我们都一样    渴望梦想的光芒    这一路喜悦彷徨    不要轻易说失望    回到最初时光    当时的你多么坚强    那鼓励让我难忘";
    
    // 存储到数据库
    [model bg_save];
    
    
    
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = @"我们都一样";
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = @"我们都一样";
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageTime = @"2017年12月12日 16:37";
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = @"推开窗看见星星依然守在夜空中心中不免多了些暖暖的感动一闪一闪的光努力把黑夜变亮气氛如此安详你在我的生命中是那最闪亮的星一直在无声夜空守护着我们的梦这世界那么大 我的爱只想要你懂 陪伴我孤寂旅程你知道我的梦 你知道我的痛你知道我们感受都相同    就算有再大的风也挡不住勇敢的冲动    努力的往前飞 再累也无所谓    黑夜过后的光芒有多美    分享你我的力量就能把对方的路照亮    我想我们都一样    渴望梦想的光芒    这一路喜悦彷徨    不要轻易说失望    回到最初时光    当时的你多么坚强    那鼓励让我难忘";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 30;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 15;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 100;
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 20;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 10;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 15;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"w"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"mm"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"w"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"m"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"dd"];
    model.messageTime = @"16:40";
   [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"ll"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"ss"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"m"];
    model.messageTime = @"16:40";
    [model bg_save];
}

-(void) getDBData
{
    /**
     当数据量巨大时采用分页范围查询.
     */
    NSInteger count = [CSMessageModel bg_count:bg_chat_tablename where:nil];
    
    if (count == 0)
     {
        [self initDB];
     }
    
    
    for(int i=1;i<=count;i+=50){
        NSArray* arr = [CSMessageModel bg_find:bg_chat_tablename range:NSMakeRange(i,50) orderBy:nil desc:NO];
        for(CSMessageModel* model in arr){
            //具体数据请断点查看
            //库新增两个自带字段createTime和updateTime方便开发者使用和做参考对比.
            NSLog(@"主键 = %@, 表名 = %@, 创建时间 = %@, 更新时间 = %@",model.bg_id,model.bg_tableName,model.bg_createTime,model.bg_updateTime);
            
            // 将数据中数据， 插入列表的_dataArray
            [_dataArray addObject:model];
        }
        
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
