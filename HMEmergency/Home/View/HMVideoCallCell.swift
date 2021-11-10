//
//  HMVideoCallCell.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/15.
//

import UIKit
import Reusable
import TXLiteAVSDK_TRTC

class HMVideoCallCell: UICollectionViewCell, Reusable {
    
    let userId = shareLoginManager.userId
    private lazy var trtcCloud: TRTCCloud = {
        let instance: TRTCCloud = TRTCCloud.sharedInstance()
        ///设置TRTCCloud的回调接口
        instance.delegate = self;
        return instance;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTX()
        load()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        TRTCCloud.destroySharedIntance()
    }
    
    func load() {
        setUI()
        /// 开启麦克风采集
        trtcCloud.startLocalAudio()
        /// 开启摄像头采集
        trtcCloud.startLocalPreview(true, view: contentView)
    }
    
    func setUI() {
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(HMwidth-20)
            make.height.equalTo(250)
        }
        
    }
    
    func initTX() {
        let param = TRTCParams.init()
        param.sdkAppId = UInt32(1400583847)
        param.roomId = UInt32(shareLoginManager.userId!)
        param.userId = shareLoginManager.phone!
        param.role = TRTCRoleType.anchor
        param.userSig = GenerateTestUserSig.genTestUserSig(param.userId)
        trtcCloud.enterRoom(param, appScene: TRTCAppScene.videoCall)
        /// 设置视频通话的画质（帧率 15fps，码率550, 分辨率 360*640）
        /// 指定以“视频通话场景”（TRTCAppScene.videoCall）进入房间
        let videoEncParam = TRTCVideoEncParam.init()
        videoEncParam.videoResolution = TRTCVideoResolution._640_360
        videoEncParam.videoBitrate = 550
        videoEncParam.videoFps = 15
        trtcCloud.setVideoEncoderParam(videoEncParam)
        /**
         * 设置默认美颜效果（美颜效果：自然，美颜级别：5, 美白级别：1）
         * 视频通话场景推荐使用“自然”美颜效果
         */
        let beautyManager = trtcCloud.getBeautyManager()
        beautyManager?.setBeautyStyle(TXBeautyStyle.nature)
        beautyManager?.setBeautyLevel(5)
        beautyManager?.setWhitenessLevel(1)
        /// 调整仪表盘显示位置
        trtcCloud.setDebugViewMargin(param.userId, margin: TXEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0))
        // 开启摄像头采集
        trtcCloud.startLocalPreview(true, view: contentView)
        // 开启麦克风采集
        trtcCloud.startLocalAudio()
    }
}

extension HMVideoCallCell: TRTCCloudDelegate {
    
}
