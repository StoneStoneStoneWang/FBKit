//
//  EDTUserCenterBridge.swift
//  EDTBridge
//
//  Created by 王磊 on 2020/3/30.
//  Copyright © 2020 王磊. All rights reserved.
//

import Foundation
import EDTCollection
import RxDataSources
import EDTCocoa
import EDTCache
import RxCocoa
import RxSwift
import EDTBean
import RxGesture

@objc(EDTUserCenterActionType)
public enum EDTUserCenterActionType: Int ,Codable {
    
    case header
    
    case about
    
    case userInfo
    
    case setting
    
    case contactUS
    
    case privacy
    
    case focus
    
    case space
    
    case myCircle
    
    case order
    
    case address
    
    case characters
    
    case unLogin
    
    case feedBack
    
    case share
    
    case service
    
    case version
}

public typealias EDTUserCenterAction = (_ action: EDTUserCenterActionType ) -> ()

private var key: Void?

extension EDTCollectionHeaderView {
    
    @objc public var user: EDTUserBean? {
        get {
            return objc_getAssociatedObject(self, &key) as? EDTUserBean
        }
        set{
            objc_setAssociatedObject(self, &key,newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Reactive where Base: EDTCollectionHeaderView {
    
    var user: Binder<EDTUserBean?> {
        
        return Binder(base) { view, user in
            
            view.user = user
        }
    }
}

@objc (EDTUserCenterBridge)
public final class EDTUserCenterBridge: EDTBaseBridge {
    
    typealias Section = EDTSectionModel<(), EDTUserCenterBean>
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!
    
    var viewModel: EDTUserCenterViewModel!
    
    weak var vc: EDTCollectionNoLoadingViewController!
    
    @objc public var headerView: EDTCollectionHeaderView!
}

extension EDTUserCenterBridge {
    
    @objc public func createUserCenter(_ vc: EDTCollectionNoLoadingViewController,centerAction:@escaping EDTUserCenterAction) {
        
        self.vc = vc
        
        let input = EDTUserCenterViewModel.WLInput(modelSelect: vc.collectionView.rx.modelSelected(EDTUserCenterBean.self),
                                                   itemSelect: vc.collectionView.rx.itemSelected)
        
        viewModel = EDTUserCenterViewModel(input, disposed: disposed)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { ds, cv, ip, item in return vc.configCollectionViewCell(item, for: ip)},
            configureSupplementaryView: { ds, cv, kind, ip in return vc.configCollectionViewHeader(EDTUserInfoCache.default.userBean, for: ip)})
        
        viewModel
            .output
            .tableData
            .asDriver()
            .map({ [Section(model: (), items: $0)]  })
            .drive(vc.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposed)
        
        self.dataSource = dataSource
        
        viewModel
            .output
            .zip
            .subscribe(onNext: {(type,ip) in
                
                vc.collectionView.deselectItem(at: ip, animated: true)
                
                let isLogin = EDTAccountCache.default.isLogin()
                
                switch type.type {
                case .setting: centerAction(.setting)
                    
                case .privacy: centerAction(.privacy)
                case .about: centerAction(.about)
                    
                case .userInfo: centerAction(isLogin ? .userInfo : .unLogin)
                case .address: centerAction(isLogin ? .address : .unLogin)
                case .order: centerAction(isLogin ? .order : .unLogin)
                case .focus: centerAction(isLogin ? .focus : .unLogin)
                case .characters: centerAction(isLogin ? .characters : .unLogin)
                case .myCircle: centerAction(isLogin ? .myCircle : .unLogin)
                case .feedBack: centerAction(.feedBack)
                case .service: centerAction(.service)
                case .header: centerAction(isLogin ? .header : .unLogin)
                case .share: centerAction(.share)
                case .version: centerAction(.version)
                case .contactUS: centerAction(.contactUS)
                    
                    
                default:
                    break
                }
            })
            .disposed(by: disposed)
        
    }
    
    @objc public func bindUserView(_ headerView: EDTCollectionHeaderView,centerAction:@escaping EDTUserCenterAction) {
        
        self.headerView = headerView
        
        viewModel
            .output
            .userInfo
            .bind(to: headerView.rx.user)
            .disposed(by: disposed)
        
        headerView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { (_) in
                
                let isLogin = EDTAccountCache.default.isLogin()
                
                centerAction(isLogin ? .header : .unLogin)
                
            })
            .disposed(by: disposed)
    }
}
