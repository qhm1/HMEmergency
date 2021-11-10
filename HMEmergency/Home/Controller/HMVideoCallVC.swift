//
//  HMVideoCallVC.swift
//  Nicret
//
//  Created by 齐浩铭 on 2021/10/14.
//

import UIKit
import TXLiteAVSDK_TRTC

class HMVideoCallVC: UIViewController {
    
    let userId = shareLoginManager.userId
    
    var localVideoView  = UIView()
    private lazy var trtcCloud: TRTCCloud = {
        let instance: TRTCCloud = TRTCCloud.sharedInstance()
        ///设置TRTCCloud的回调接口
        instance.delegate = self;
        return instance;
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "视频通话"

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTX()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 开启麦克风采集
        trtcCloud.startLocalAudio()
        /// 开启摄像头采集
        trtcCloud.startLocalPreview(true, view: localVideoView)
    }
    
    deinit {
        TRTCCloud.destroySharedIntance()
    }
    
    func initTX() {
        let param = TRTCParams.init()
        param.sdkAppId = UInt32(1400583847)
        param.roomId = UInt32(self.userId!)
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
        trtcCloud.startLocalPreview(true, view: localVideoView)
        // 开启麦克风采集
        trtcCloud.startLocalAudio()
    }
    
    func setUI() {
        view.addSubview(self.localVideoView)
        localVideoView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

}

extension HMVideoCallVC: TRTCCloudDelegate {
    
}
