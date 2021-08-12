//
//  ViewController.swift
//  BeaconSample
//
//  Created by ayako on 2021/05/27.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // CoreLocation
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!
    
    @IBOutlet weak var immediateLabel: UILabel!
    
    @IBOutlet weak var nearLabel: UILabel!
    
    @IBOutlet weak var farLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避
        self.overrideUserInterfaceStyle = .light
        // ロケーションマネージャーオブジェクトを作成
        self.locationManager = CLLocationManager();

        // デリゲートを自身に設定
        self.locationManager.delegate = self;
        
        // 位置情報の認証ステータスを取得
        let status = CLLocationManager.authorizationStatus()
       
        // 位置情報の認証が許可されていない場合は認証ダイアログを表示
        if (status != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 受信対象のビーコンのUUIDを設定
        let uuid:UUID? = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")
       
        // ビーコン領域の初期化
        beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "BeaconApp")
    }
    
    // 位置情報の認証ステータス変更
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        if (status == .authorizedWhenInUse) {
            // ビーコン領域の観測を開始
            self.locationManager.startMonitoring(for: self.beaconRegion)
        }
    }

    // ビーコン領域の観測を開始
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // ビーコン領域のステータスを取得
        self.locationManager.requestState(for: self.beaconRegion)
    }
   
    // ビーコン領域のステータスを取得
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {

        switch (state) {
        case .inside: // ビーコン領域内
            // ビーコンの測定を開始
            self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
            break
        case .outside: // ビーコン領域外
            break

        case .unknown: // 不明
            break

        }
    }
       
    // ビーコン領域に入った時
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // ビーコンの位置測定を開始
        self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
       
    }

    // ビーコン領域から出た時
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // ビーコンの位置測定を停止
        self.locationManager.stopRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
    }
   
    // ビーコンの位置測定
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
       
        for beacon in beacons {
            changeLabelColor(proximity: beacon.proximity)
            print("uuid:\(beacon.uuid)")
            print("major:\(beacon.major)")
            print("minor:\(beacon.minor)")
            if (beacon.proximity == CLProximity.immediate) {
                // 1m未満
                print("proximity:immediate")
            }
            if (beacon.proximity == CLProximity.near) {
                // 1～3m
                print("proximity:near")
            }
            if (beacon.proximity == CLProximity.far) {
                // 3m以上
                print("proximity:Far")
            }
            if (beacon.proximity == CLProximity.unknown) {
                // 計測不能
                print("proximity:unknown")
            }
            print("accuracy:\(beacon.accuracy)")
            print("rssi:\(beacon.rssi)")
            print("timestamp:\(beacon.timestamp)")

        }
    }
    
    /// Labelの色変える用
    private func changeLabelColor(proximity: CLProximity) {
        immediateLabel.textColor = .systemGray3
        nearLabel.textColor = .systemGray3
        farLabel.textColor = .systemGray3
        unknownLabel.textColor = .systemGray3
        
        switch proximity {
        case .immediate:
            immediateLabel.textColor = .red
        case .near:
            nearLabel.textColor = .red
        case .far:
            farLabel.textColor = .red
        case .unknown:
            unknownLabel.textColor = .red
        @unknown default:
            print("proximity:unknown")
        }
    }


}

