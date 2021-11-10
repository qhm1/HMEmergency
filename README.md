# HMEmergency

[![Version](https://img.shields.io/cocoapods/v/ZJKitTool.svg?style=flat)](https://cocoapods.org/pods/ZJKitTool)
[![License](https://img.shields.io/cocoapods/l/ZJKitTool.svg?style=flat)](https://cocoapods.org/pods/ZJKitTool)
[![Platform](https://img.shields.io/cocoapods/p/ZJKitTool.svg?style=flat)](https://cocoapods.org/pods/ZJKitTool)

## Statement

一款采用Swift编写的iOS app，支持一键发布紧急求助，发起远程音视频指导。
![image](https://github.com/QHM-tjut/HMEmergency/blob/master/photo/lal%20%E6%89%8B%E6%9C%BA2.gif?raw=true)
<img width="150" height="150" src="https://github.com/QHM-tjut/HMEmergency/blob/master/photo/lal%20%E6%89%8B%E6%9C%BA2.gif"/>

### Contact

Author:Qhm

Email:2466506269@qq.com

QQ:2466506269

## Installation

> 采用Cocoa Pod 管理第三方库

```
cd .../HMEmergency
pod install
```

## details

#### 获取当前定位

> 引入高德地图SDK
>
> 使用桥文件Bridging-Header将OC项目链接到Swift

采用高德地图开放平台获取当前定位并将经纬度地址化为当前地址的文字描述

#### 网络请求

> 引入 Alamofire 处理网络请求

通过 Alamofire 发送 post 和 get 请求并处理相关回调

#### 文字沟通

> 引入 Starscream

由后端同学搭建WebSocket服务器并下发userId实现点对点实时通信

采用 Starscream 库维护 socket 连接并遵守WebSocketDelegate处理接收到的消息

```swift
func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            //isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            //isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        // .......
        case .error(_):
            //isConnected = false
            handleError(error)
        }
    }
```

#### 音视频通话

> 引入腾讯云视频通话SDK

通过后端下发房间号匹配用户进行音视频通话

#### 单例模式

通过单例模式管理登陆等部分网络请求

#### UICollectionViewCell 自适应高度

> 引入 SnapKit 库

通过设置完整的 AutoLayout 约束实现文字卡片高度自适应

## License
HMEmergency is released under the MIT license. See LICENSE for details.

## Other

项目已移除SDKAppID、SECRETKEY、AMapServices.shared().apiKey等第三方库配置参数，如有需要请自行申请配置
