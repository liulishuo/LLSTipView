# LLSTipView
![image](https://github.com/liulishuo/LLSTipView/blob/master/LLSTipView/LLSTipView/Demo.gif)

用法
==============

### 全能初始化方法
```objc
/**
 全能初始化方法

 @param frame frame
 @param timeInterval 滚动时间间隔
 @param direction 滚动方向
 @param image 左侧图片
 @param messageBlock 数据源block
 @param tapBlock 点击回调block
 @param dismissBlock 点击 close button 回调block
 @return tipView实例，如果数据源为空，则返回nil
 */
- (nullable instancetype)initWithFrame:(CGRect)frame
                 timeInterval:(NSTimeInterval)timeInterval
                    direction:(LLSTipViewRollDirection)direction
                    leftImage:(nullable UIImage *)image
                     messages:(nonnull TipViewMessagesBlock)messageBlock
                     tapBlock:(nullable TipViewTapBlock)tapBlock
                 dismissBlock:(nullable TipViewDismissBlock)dismissBlock NS_DESIGNATED_INITIALIZER;
```                 

### 基本用法
```objc
__weak typeof (&*self) weakSelf = self;
    _tipView = [[LLSTipView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeight)
                                    timeInterval:1
                                       direction:LLSTipViewRollDirectionUp
                                       leftImage:[UIImage imageNamed:@"speaker"]
                                        messages:^NSArray<NSString *> *{
                                            return weakSelf.data;
                                        } tapBlock:^(NSUInteger index) {
                                            NSLog(@"select %ld",index);
                                        } dismissBlock:^{
                                            weakSelf.topBackgroundViewHeight.constant = 0;
                                        }];
    
    _tipView.backgroundColor = [UIColor redColor];
    
    [_topBackgroundView addSubview:_tipView];
 ```
