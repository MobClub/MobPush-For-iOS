//
//  LiveActivityUtils.swift
//  MobPushDemo
//
//  Created by MobTech-iOS on 2023/7/24.
//  Copyright © 2023 com.mob. All rights reserved.
//

#if canImport(ActivityKit)
import Foundation
import ActivityKit

/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] Activity行为封装
 *
 * 警告：以下为参考代码, 注意根据实际需要修改.
 * 请参考苹果官方demo及官方文档进行开发 https://developer.apple.com/documentation/activitykit
 *
 */

@available(iOS 16.1, *)
@objcMembers
public class LiveActivityUtils : NSObject {
    static public func startActivity(pushTokenUpdate:@escaping (Bool, Data?)->Void) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            //不可用
            pushTokenUpdate(false, nil)
            //监听可用状态
//            for await enablment in ActivityAuthorizationInfo().activityEnablementUpdates {
//                print("Activity AuthorizationInfo change to \(enablment)")
//            }
            return
        }

        endPreActivity()

        let state = MobPushLiveActivitiesAttributes.ContentState(prograssState: .Car)
        let attri = MobPushLiveActivitiesAttributes(name: "MPLiveActivities")
        do {
            let current = try Activity.request(attributes: attri, contentState: state, pushType: .token)
            Task {
                for await tokenData in current.pushTokenUpdates {
                    //监听token更新 注意线程
                    pushTokenUpdate(true, tokenData)
                }
            }
            Task {
                for await state in current.contentStateUpdates {
                    //监听state状态 开发者可自行编写回调监听
                    print("content state update: tip=\(state.prograssState)")
                }
            }
            Task {
                //监听activity状态 开发者可自行编写回调监听
                for await state in current.activityStateUpdates {
                    print("activity state update: tip=\(state) id:\(current.id)")
                }
            }
        } catch(let error) {
            print("error=",error)
            pushTokenUpdate(false, nil)
        }
    }
    
    //更新Activity状态 也可通过Apns更新 交互
    static public func updateActivityState(_ value: Int) {
        Task {
            guard let current = Activity<MobPushLiveActivitiesAttributes>.activities.first else {
                return
            }
            
            let state = MobPushLiveActivitiesAttributes.ContentState(prograssState: PrograssState(rawValue: value) ?? .Arrived)
            let alertConfiguration = AlertConfiguration(title: "Delivery Update ", body: "Delivery Update State to \(state.prograssState.rawValue)", sound: .default)
            await current.update(using: state, alertConfiguration: alertConfiguration)
        }
    }
    
    //建议关闭应用的时候要关闭 不然下次启动就脱离控制了
    static public func endPreActivity() {
        let activities = Activity<MobPushLiveActivitiesAttributes>.activities.filter { act in
            return act.activityState == .active
        }
        guard activities.count > 0 else { return }
        for item in activities {
            Task {
//                print("end activity \(item.id)")
                await item.end(dismissalPolicy:.immediate)
            }
        }
    }
    
}

#endif
