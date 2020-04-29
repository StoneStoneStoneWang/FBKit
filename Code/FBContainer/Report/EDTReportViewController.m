//
//  EDTReportViewController.m
//  EDTContainer
//
//  Created by 王磊 on 2020/3/31.
//  Copyright © 2020 王磊. All rights reserved.
//
#import "EDTReportViewController.h"

@import JXTAlertManager;
@import Masonry;
@import EDTColor;

@interface EDTReportTableViewCell()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIButton *selectItem;

@end

@implementation EDTReportTableViewCell

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
    
        _titleLabel = [UILabel new];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        _titleLabel.textColor = EDTColorCreate(@"#666666");
    }
    return _titleLabel;
}

- (UIButton *)selectItem {
    
    if (!_selectItem) {
        
        _selectItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_selectItem setImage:[UIImage imageNamed:@EDTNormalIcon] forState:UIControlStateNormal];
        
        [_selectItem setImage:[UIImage imageNamed:@EDTSelectedIcon] forState:UIControlStateSelected];
        
        [_selectItem sizeToFit];
        
    }
    return _selectItem;
}
- (void)setReportBean:(EDTReportBean *)reportBean {
    
    self.selectItem.selected = reportBean.isSelected;
    
    self.titleLabel.text = reportBean.title;
    
    self.bottomLineType = EDTBottomLineTypeNormal;
}

- (void)commitInit {
    [super commitInit];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    self.accessoryView = self.selectItem;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.titleLabel];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        
        make.centerY.equalTo(self);
    }];
    
}
@end

@interface EDTReportViewController ()

@property (nonatomic ,strong) EDTReportBridge *bridge;

@property (nonatomic ,strong) UITextView *textView;

@property (nonatomic ,copy) NSString *uid;

@property (nonatomic ,copy) NSString *encode;

@property (nonatomic ,strong) UIButton *completeItem;

@property (nonatomic ,copy) EDTReportBlock block;
@end

@implementation EDTReportViewController

- (UIButton *)completeItem {
    
    if (!_completeItem) {
        
        _completeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_completeItem setTitle:@"举报" forState:UIControlStateNormal];
        
        [_completeItem setTitle:@"举报" forState:UIControlStateHighlighted];
        
        [_completeItem setTitle:@"举报" forState:UIControlStateSelected];
        
        _completeItem.titleLabel.font = [UIFont systemFontOfSize:15];
        
//        if ([@EDTColor isEqualToString:@"#ffffff"]) {
//            
//            [_completeItem setTitleColor:EDTColorCreate(@"#666666") forState:UIControlStateNormal];
//            
//            [_completeItem setTitleColor:[UIColor s_transformTo_AlphaColorByHexColorStr:@"#66666680"] forState:UIControlStateHighlighted];
//            
//            [_completeItem setTitleColor:[UIColor s_transformTo_AlphaColorByHexColorStr:@"#66666650"] forState:UIControlStateDisabled];
//            
//        } else {
//            
//            [_completeItem setTitleColor:[UIColor s_transformToColorByHexColorStr:@"#ffffff"] forState:UIControlStateNormal];
//            
//            [_completeItem setTitleColor:[UIColor s_transformTo_AlphaColorByHexColorStr:@"#ffffff80"] forState:UIControlStateHighlighted];
//            
//            [_completeItem setTitleColor:[UIColor s_transformTo_AlphaColorByHexColorStr:@"#ffffff50"] forState:UIControlStateDisabled];
//        }
    }
    return _completeItem;
}

- (UITextView *)textView {
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        
        _textView.font = [UIFont systemFontOfSize:15];
        
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _textView.tag = 201;
    }
    return _textView;
}

+ (instancetype)createReportWithUid:(NSString *)uid andEncode:(NSString *)encode andBlock:( EDTReportBlock)block {
    
    return [[self alloc] initWithUid:uid andEncode:encode andBlock:block];
}
- (instancetype)initWithUid:(NSString *)uid andEncode:(NSString *)encode andBlock:( EDTReportBlock)block{
    
    if (self = [super init]) {
        
        self.uid = uid;
        
        self.encode = encode;
        
        self.block = block;
    }
    return self;
}
- (void)configOwnSubViews {
    [super configOwnSubViews];
    
    [self.tableView registerClass:[EDTReportTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = footerView;
    
    [footerView addSubview:self.textView];
    
    self.textView.frame = footerView.bounds;
}

- (UITableViewCell *)configTableViewCell:(id)data forIndexPath:(NSIndexPath *)ip {
    
    EDTReportTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.reportBean = data;
    
    return cell;
}

- (void)configViewModel {
    
    self.bridge = [EDTReportBridge new];

    __weak typeof(self) weakSelf = self;
    
    [self.bridge createReport:self reports:EDTReportKeyValues uid:self.uid encoded:self.encode textView:self.textView reportAction:^{
        
        [weakSelf alertShow];
        
        weakSelf.textView.text = @"";
        
    }];
    
}
- (void)alertShow {
    
    __weak typeof(self) weakSelf = self;
    
    [self jxt_showAlertWithTitle:@"举报成功" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker
        .addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
       
        weakSelf.block(weakSelf);
    }];
}
- (void)configNaviItem {
    
    self.title = @"举报";
    
    [self.completeItem sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeItem];
}

- (CGFloat)caculateForCell:(id)data forIndexPath:(NSIndexPath *)ip {
    
    return 55;
}

@end
