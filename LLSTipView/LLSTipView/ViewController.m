//
//  ViewController.m
//  LLSTipView
//
//  Created by liulishuo on 2017/10/27.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import "ViewController.h"
#import "LLSTipView.h"

static const CGFloat kHeight = 30;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuTitleArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackgroundViewHeight;
@property (nonatomic, strong) LLSTipView *tipView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _menuTitleArray = @[@"删除视图",@"添加视图",@"切换数据",@"删除按钮",@"更换按钮",@"文字颜色",@"文字字体"];
    
    _data = @[@"1",@"2",@"3"];
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
                                            NSLog(@"%s",__FUNCTION__);
                                            weakSelf.topBackgroundViewHeight.constant = 0;
                                        }];
    
    _tipView.backgroundColor = [UIColor redColor];
    
    [_topBackgroundView addSubview:_tipView];
    
    _topBackgroundView.clipsToBounds = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
    }
    cell.textLabel.text = _menuTitleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            _topBackgroundViewHeight.constant = 0;
            [_tipView removeFromSuperview];
            break;
        case 1:
        {
            _topBackgroundViewHeight.constant = kHeight;
            [_tipView removeFromSuperview];
            __weak typeof (&*self) weakSelf = self;
            _tipView = [[LLSTipView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeight)
                                            timeInterval:1
                                               direction:LLSTipViewRollDirectionDown
                                               leftImage:[UIImage imageNamed:@"speaker"]
                                                messages:^NSArray<NSString *> *{
                                                    return weakSelf.data;
                                                } tapBlock:^(NSUInteger index) {
                                                    NSLog(@"select %ld",index);
                                                } dismissBlock:^{
                                                    NSLog(@"%s",__FUNCTION__);
                                                    weakSelf.topBackgroundViewHeight.constant = 0;
                                                }];
            
            _tipView.backgroundColor = [UIColor blueColor];
            
            [_topBackgroundView addSubview:_tipView];
        }
            
            break;
        case 2:
            _data = @[@"ABC",@"DEFGH",@"IIOOII",@"KJALJSFOIGUYGIUGUYGIYasdfasdfasdfasdf"];
            [_tipView reloadData];
            break;
        case 3:
            _tipView.closeButton = nil;
            break;
        case 4:
        {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeInfoDark];
            _tipView.closeButton = b;
        }
            break;
        case 5:
            _tipView.textColor = [UIColor yellowColor];
            break;
        case 6:
            _tipView.textFont = [UIFont systemFontOfSize:17];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
