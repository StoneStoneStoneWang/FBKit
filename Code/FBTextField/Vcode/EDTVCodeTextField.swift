//
//  WLLoginVCodeTextField.swift
//  WLCompoentViewDemo
//
//  Created by three stone 王 on 2019/4/16.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import UIKit
import WLToolsKit

@objc (EDTVCodeImageTextField)
public final class EDTVCodeImageTextField: EDTLeftImageTextField {
    
    public final let vcodeItem: UIButton = UIButton(type: .custom).then {
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        $0.setTitle("获取验证码", for: .normal)
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        
        return CGRect(x: rect.minX - 20, y: rect.minY, width: rect.width, height: rect.height)
    }
    @objc (commitInit)
    public override func commitInit() {
        super.commitInit()
        
        EDT_rightViewMode(.always)
        
        EDT_rightView(vcodeItem)
        
        vcodeItem.sizeToFit()
    }
}

@objc (EDTVCodeTitleTextField)
public final class EDTVCodeTitleTextField: EDTLeftTitleTextField {
    
    public final let vcodeItem: UIButton = UIButton(type: .custom).then {
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        $0.setTitle("获取验证码", for: .normal)
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.rightViewRect(forBounds: bounds)
        
        return CGRect(x: rect.minX - 20, y: rect.minY, width: rect.width, height: rect.height)
    }
    @objc (commitInit)
    public override func commitInit() {
        super.commitInit()
        
        EDT_rightViewMode(.always)
        
        EDT_rightView(vcodeItem)
        
        vcodeItem.sizeToFit()
    }
}