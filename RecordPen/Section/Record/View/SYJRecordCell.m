//
//  SYJRecordCell.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/2.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJRecordCell.h"

@implementation SYJRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.font = [UIFont systemFontOfSize:16.0];
        self.nameLab.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(20).widthIs(180);
        
        
        self.timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLab];
        self.timeLab.font = [UIFont systemFontOfSize:14.0];
        self.timeLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.timeLab.textAlignment = NSTextAlignmentRight;
        self.timeLab.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 6).heightIs(20).widthIs(200);
        
        
        self.sizeLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.sizeLab];
        self.sizeLab.font = [UIFont systemFontOfSize:14.0];
        self.sizeLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.sizeLab.textAlignment = NSTextAlignmentRight;
        self.sizeLab.sd_layout.rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 6).heightIs(20).widthIs(120);
        
        self.totlaTimeLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.totlaTimeLab];
        self.totlaTimeLab.font = [UIFont systemFontOfSize:14.0];
        self.totlaTimeLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.totlaTimeLab.textAlignment = NSTextAlignmentRight;
        self.totlaTimeLab.sd_layout.rightSpaceToView(self.sizeLab, 10).bottomSpaceToView(self.contentView, 6).heightIs(20).widthIs(200);

        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = Gray;
        line.sd_layout.leftSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 1).heightIs(1);
        
    }
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
