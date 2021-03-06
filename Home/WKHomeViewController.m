//
//  WKHomeViewController.m
//  WKBrowser
//
//  Created by 李加建 on 2017/11/7.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WKHomeViewController.h"

#import "HomeTableViewCell.h"

#import "ItemModel.h"

#import <UIButton+WebCache.h>

#import "IconButton.h"

#import "SGQRCodeScanningVC.h"

#import "LoadReadyWindow.h"

#import "WeatherViewController.h"

#import "WeatherShowView.h"

#import "MessageTableViewCell.h"

#import "LocationManager.h"

#import "MessageModel.h"

#import "DetailViewController.h"

@interface WKHomeViewController ()<UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate>

@property (strong,nonatomic)UITableView*tableView;
@property (strong,nonatomic)NSArray*tableArr;
@property (nonatomic,strong)NSMutableArray* dataSource;

@property (nonatomic,strong)NSMutableArray* dataSource3;

@property (nonatomic,strong)NSMutableArray* btnsArray;

@property (nonatomic ,strong)UIView *headView ;

@property (nonatomic ,strong)UIView *footView ;

@property (nonatomic ,strong)UIImageView *wImgView ;

@property (nonatomic ,strong)WeatherModel * model;

@property (nonatomic ,strong)UIButton * weatherBtn;

@property (nonatomic,strong)LocationManager *manager;

@property (nonatomic ,strong)UITextField * textField;

@end

@implementation WKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatBgView];
    
    _dataSource = [NSMutableArray array];
    
    self.dataSource3 = [NSMutableArray array];
    
    [self initTableView];
    
    [self loadData];
    
    [self loadData3];
    
    [self getLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initData {
    
    
    
}


- (void)getLocation {
    
    _manager = [[LocationManager alloc]init];
    
    [_manager findMe];
    
    WKSearchBarView *searchBar = [WKSearchBarView shareInstance];

    
    __weak typeof(self) weakSelf = self;
    
    _manager.getAddress = ^(NSString *city ,double lng , double lat){
        
        NSLog(@"city = %@",city);
        
        searchBar.city = city;
        searchBar.lat = lat;
        searchBar.lng = lng;
        
        [weakSelf loadData2];
        
    };
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
//    WKSearchBarView * searchBarView = [WKSearchBarView shareInstance];
//    
//    [searchBarView removeFromSuperview];
}




- (void)creatBgView {
    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_HEIGHT )];
//    img.image = [UIImage imageNamed:@"home_bg.jpg"];
//    [self.view addSubview:img];
}



- (void)creatBtn {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)btnAction {
    
    if(_tapURLBlock != nil){
        _tapURLBlock(nil);
    }
}



- (UIView *)headView {
    
    if(_headView == nil){
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_WIDTH*0.5)];
        
        [self creatHeadView];
    }
    
    return _headView;
}



- (void)weatherBtnAction:(UIButton*)sender {
    
    NSString *bgImgName = @"weather_bg_001";
    
    if(self.model.weather_bg_img.length >0){
        
        bgImgName = self.model.weather_bg_img;
    }
    
    WeatherViewController *vc = [[WeatherViewController alloc]init];
    vc.bgImgName = bgImgName;
    vc.model = self.model;
    
    [self presentViewController:vc animated:NO completion:nil];

    
//    LoadReadyWindow *loadView = [[LoadReadyWindow alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) imageName:bgImgName];
//    loadView.startFrame = sender.frame;
//    [loadView setAnimationStopOperation:^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//                        
//            [self presentViewController:vc animated:NO completion:nil];
//        });
//        
//    }];
//    [loadView makeOuttoAnimation];
}


- (void)creatHeadView {
    
    _wImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _headView.width, _headView.height)];
    
    _wImgView.contentMode = UIViewContentModeScaleAspectFill;
    _wImgView.clipsToBounds = YES;
    
    _wImgView.image = [UIImage imageNamed:@"weather_001"];
    [_headView addSubview:_wImgView];
    
    
    CGFloat w = SCREEM_WIDTH*0.2;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, w/2, w*3, w)];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_headView addSubview:btn];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(weatherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weatherBtn = btn;
    [self.weatherBtn setAttributedTitle:[self showTemp] forState:UIControlStateNormal];
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, SCREEM_WIDTH*0.3, SCREEM_WIDTH - 40, 44)];
    
    textField.placeholder = @"搜索或输入网址";
    textField.backgroundColor = RGBA(255, 255, 255, 0.6);
    textField.textColor = RGBA(255, 255, 255, 1);
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4;
    textField.font = FONT14;
    
    
    textField.keyboardType = UIKeyboardTypeWebSearch;
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [textField setValue:RGBA(255, 255, 255, 0.9) forKeyPath:@"_placeholderLabel.textColor"];

    self.textField = textField;
    
    [_headView addSubview:textField];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"root_search"] forState:UIControlStateNormal];
    textField.leftView = leftBtn;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    rightBtn.backgroundColor = [UIColor redColor];
    
    textField.rightView = rightBtn;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [rightBtn setImage:[UIImage imageNamed:@"root_qrcode"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"Return");
    
    [self searchWithWords:textField.text];
    
    if ([textField returnKeyType] != UIReturnKeyDone) {
        NSInteger nextTag = textField.tag+1;
        UIView*nextTextField = [self.view viewWithTag:nextTag];
        [nextTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"down");
    
    [self searchWithWords:textField.text];
}



- (void)searchWithWords:(NSString*)words {
    
    if(words.length <= 0){
        
        return;
    }
    
    [_textField resignFirstResponder];
    
    if ([words hasPrefix:@"http"]) {
        
    } else {
      
        words = [NSString stringWithFormat:@"https://wap.baidu.com/from=1009547a/s?word=%@",words];
//        NSString *transString = [NSString stringWithString:[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        words = [words stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    
    if(_tapURLBlock != nil){
        _tapURLBlock(words);
    }
    
}



- (void)rightBtnAction {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        SGQRCodeScanningVC *nextVC = [[SGQRCodeScanningVC alloc]init];
        nextVC.hidesBottomBarWhenPushed = YES;
        
        [nextVC setScanSuccess:^(NSString *scanString){
    
//            [self scanActionWithString:scanString];
            
            if(_tapURLBlock != nil){
                _tapURLBlock(scanString);
            }
        }];
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:nextVC];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [root presentViewController:navi animated:YES completion:nil];
        
    }else {
        NSLog(@"无相机");
    }
}


- (UIView *)footView {
    
    if(_footView == nil){
        
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, SCREEM_WIDTH*0.4)];
        
        
    }
    
    return _footView;
}


- (NSMutableArray *)btnsArray {
    
    if(_btnsArray == nil){
        _btnsArray = [NSMutableArray array];
    }
    
    return _btnsArray;
}

- (void)creatFootView {
    
    NSInteger count = 5;
    
    CGFloat w = SCREEM_WIDTH/count;
    
    CGFloat h = 70;
    
    CGFloat y = SCREEM_WIDTH*0.5;
    
    self.footView.frame = CGRectMake(0, y, SCREEM_WIDTH, (h*((_dataSource.count-1)/count + 1) + 20));
//    self.tableView.tableFooterView = self.footView;
    
    [self.headView addSubview:self.footView];
    
    self.headView.frame = CGRectMake(0, 0, SCREEM_WIDTH, y + self.footView.height);
    
    self.tableView.tableHeaderView = self.headView;
    
    for(int i = 0 ;i<_dataSource.count;i++){
        
        IconButton *btn ;
        
        ItemModel *model = _dataSource[i];
        
        if(i<self.btnsArray.count){
            
            btn = self.btnsArray[i];
        }
        else {
            
            btn = [[IconButton alloc]initWithFrame:CGRectMake(w*(i%count), 20+ h*(i/count), w, h)];
            
            [self.footView addSubview:btn];
            [self.btnsArray addObject:btn];
            btn.titleLabel.font = FONT12;
            [btn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
            [btn setImageRect:CGRectMake(btn.width/2 - 12, btn.height/2 - 25, 24, 24)];
            btn.imageView.layer.cornerRadius = 5;
            [btn setTitleRect:CGRectMake(0, btn.height/2 + 5, btn.width, 20)];
            
            [btn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [btn setTitle:model.title forState:UIControlStateNormal];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal];
    }
}



- (void)itemBtnAction:(IconButton*)btn {
    
    
    NSInteger tag = [_btnsArray indexOfObject:btn];
    
    [self chechItemWithTag:tag];
    
    ItemModel *model = _dataSource[tag];
    
    if([UserManager isBannaer].length > 0 && [model.type integerValue] == 1){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
        return;
    }
    
    
    if(_tapURLBlock != nil){
        _tapURLBlock(model.url);
    }
    
}



- (void)chechItemWithTag:(NSInteger)tag {

    NSLog(@"MobClick");
    
    NSString * item = [NSString stringWithFormat:@"itemaction%@",@(tag)];
  
    if(tag < 10){
        
        [MobClick event:item];
    }
    
}



- (void)initTableView  {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0  - 44)];
    

    if(kDevice_Is_iPhoneX){
        
        _tableView.frame = CGRectMake(0, 44, SCREEM_WIDTH, SCREEM_HEIGHT - 44 - 78);
    }
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshing)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshing)];
    
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    [footer endRefreshingWithNoMoreData];
    
    
    _tableView.mj_footer = footer;
    
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.pagingEnabled = YES;
    
    
    _tableView.tableHeaderView = self.headView;
    
    _tableView.tableFooterView = [[UIView alloc] init];
}


- (void)headRefreshing {
    
//    [_dataSource removeAllObjects];
    
    [_tableView.mj_header endRefreshing];
    
    [self loadData3];
    
    [self loadData2];
}


- (void)footRefreshing {
    
    [_tableView.mj_footer endRefreshing];
    
    [self loadData3];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _dataSource3.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil){
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    if(_dataSource.count <= 0){
        return cell;
    }
    
    
    MessageModel *model = _dataSource3[indexPath.row];
    
    [cell dataWithModel:model];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self chechMsgWithTag:indexPath.row];
    
    MessageModel *model = _dataSource3[indexPath.row];
    
    if(model.url.length > 0){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
        return;
    }
   
    DetailViewController *nextVC = [[DetailViewController alloc]init];
    WKRootViewController * root = [WKSearchBarView  shareInstance].rootVC;
    nextVC.model = model;
    [root.navigationController pushViewController:nextVC animated:YES];
    
}


- (void)chechMsgWithTag:(NSInteger)tag {
    
    NSLog(@"MobClick");
    NSString * item = [NSString stringWithFormat:@"msgaction%@",@(tag)];
    
    if(tag < 5){
        
        [MobClick event:item];
    }
}

- (void)loadData {
    
    [ItemModel findObjects:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:objects];
        
        [self creatFootView];
        
        [_tableView reloadData];
    }];
}




- (void)loadData2 {
    
    
    WKSearchBarView *searchBar = [WKSearchBarView shareInstance];

    
    double lat = searchBar.lat;
    double lng = searchBar.lng;
    
    NSString *mUrl = [NSString stringWithFormat:@"%@weather?units=metric&lang=zh_cn&appid=%@&lat=%@&lon=%@",REQUEST_URL_HEAD, WEATHER_API_KEY,@(lat),@(lng)];
    
    NSLog(@"当前天气情况请求地址：%@", mUrl);
    
    NSURL*url = [NSURL URLWithString:mUrl];
    
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue  mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"weather ==2== data");
        
        if(data.length>0&&[(NSHTTPURLResponse*)response statusCode]==200)//获取数据
        {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            WeatherModel * model = [[WeatherModel alloc]initWithDict:dict];
            
            NSLog(@"%@",model);
            
//            [self updateWithModel:model];
            
            self.model = model;
            self.model.city_name = searchBar.city;
            
            if(self.model.weather_img.length > 0){
                
                _wImgView.image = [UIImage imageNamed:self.model.weather_img];
            }
            
            [self.weatherBtn setAttributedTitle:[self showTemp] forState:UIControlStateNormal];
            
        }
        
     
        
    }];
    
    
}



- (NSAttributedString *)showTemp {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Lato-Light" size:40]};
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Lato-Light" size:15]};
    
    
    NSString *temp = self.model.temp.length <= 0?@"20":self.model.temp;
    
    NSString *city = self.model.city_name.length <= 0?@"北京市":self.model.city_name;
    
    NSAttributedString * attri1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@°",@([temp integerValue])] attributes:attributes];
    
    NSAttributedString * attri2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",city] attributes:attributes2];
    
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
    
    [attriString appendAttributedString:attri1];
    [attriString appendAttributedString:attri2];
    
    
    return attriString;
    
}



- (void)loadData3 {
    
    [MessageModel findObjects:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        [_dataSource3 removeAllObjects];
        [_dataSource3 addObjectsFromArray:objects];
        
        [_dataSource3 sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return (NSInteger)arc4random() % 3 - 1;
        }];
        
        [_tableView reloadData];
        
    }];
}





@end
