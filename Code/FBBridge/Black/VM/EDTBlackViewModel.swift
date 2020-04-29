//
//  EDTBlackViewModel.swift
//  EDTBridge
//
//  Created by three stone 王 on 2019/8/26.
//  Copyright © 2019 three stone 王. All rights reserved.
//

import Foundation
import EDTViewModel
import RxCocoa
import RxSwift
import EDTResult
import EDTRReq
import EDTBean
import EDTApi
import EDTError
import EDTObservableMapper

public struct EDTBlackViewModel: EDTViewModel {
    
    public var input: WLInput
    
    public var output: WLOutput
    
    public struct WLInput {
        
        let modelSelect: ControlEvent<EDTBlackBean>
        
        let itemSelect: ControlEvent<IndexPath>
        
        let headerRefresh: Driver<Void>
    }
    
    public struct WLOutput {
        
        let zip: Observable<(EDTBlackBean,IndexPath)>
        
        let tableData: BehaviorRelay<[EDTBlackBean]> = BehaviorRelay<[EDTBlackBean]>(value: [])
        
        let endHeaderRefreshing: Driver<EDTResult>
    }
    init(_ input: WLInput ,disposed: DisposeBag) {
        
        self.input = input
        
        let zip = Observable.zip(input.modelSelect,input.itemSelect)
        
        let headerRefreshData = input
            .headerRefresh
            .startWith(())
            .flatMapLatest({_ in

                return EDTArrayResp(EDTApi.fetchBlackList)
                    .mapArray(type: EDTBlackBean.self)
                    .map({ return $0.count > 0 ? EDTResult.fetchList($0) : EDTResult.empty })
                    .asDriver(onErrorRecover: { return Driver.just(EDTResult.failed(($0 as! EDTError).description.0)) })
            })
        
        let endHeaderRefreshing = headerRefreshData.map { $0 }
        
        let output = WLOutput(zip: zip, endHeaderRefreshing: endHeaderRefreshing)
        
        headerRefreshData
            .drive(onNext: { (result) in
                
                switch result {
                case let .fetchList(items):
                    
                    output.tableData.accept(items as! [EDTBlackBean])
                    
                default: break
                }
            })
            .disposed(by: disposed)
        
        self.output = output
    }
}
extension EDTBlackViewModel {
    
    static func removeBlack(_ encode: String) -> Driver<EDTResult> {
        
        return EDTVoidResp(EDTApi.removeBlack(encode))
            .flatMapLatest({ return Driver.just(EDTResult.ok("移除成功")) })
            .asDriver(onErrorRecover: { return Driver.just(EDTResult.failed(($0 as! EDTError).description.0)) })
    }
}