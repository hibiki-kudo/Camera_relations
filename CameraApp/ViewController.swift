//
//  ViewController.swift
//  CameraApp
//
//  Created by 工藤 響 on 2018/10/28.
//  Copyright © 2018 工藤 響. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    
    //    AVCaputureの立ち上げ
    var captureSession = AVCaptureSession()
    //    バックカメラかフロントカメラか現在のカメラかの選択
    var backCamera:AVCaptureDevice?
    var frontCamera:AVCaptureDevice?
    var currennCamera:AVCaptureDevice?
    //    写真のアウトプット
    var Output:AVCapturePhotoOutput?
    var PreviewLayer:AVCaptureVideoPreviewLayer?
    //    撮影したものの入る箱
    var image:UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        カメラの許可を出す
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
                
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("許可")
            
                DispatchQueue.main.async {
                    self.setUpCaptureSession()
                    self.setUpDevice()
                    self.setUpInputOutput()
                    self.setUpPreviewLayer()
                    self.startRunningCaptureSession()
        }
            }
        }
    }

    
    func setUpCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setUpDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:[AVCaptureDevice.DeviceType.builtInWideAngleCamera],mediaType:AVMediaType.video,position:AVCaptureDevice.Position.unspecified
        )
        
        let device = deviceDiscoverySession.devices
        for device in device{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.back{
                frontCamera = device
                
            }
        }
        
        currennCamera = backCamera
    }
    
    func setUpInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currennCamera!)
            captureSession.addInput(captureDeviceInput)
            
            Output = AVCapturePhotoOutput()
            
            Output!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(Output!)
            
        } catch  {
            print(error)
        }
    }
    
    
    func setUpPreviewLayer(){
        PreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        PreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        PreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        PreviewLayer!.frame = self.view.frame
        self.view.layer.insertSublayer(PreviewLayer!, at: 0)
        
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
   
    @IBAction func cameraButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        Output!.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageDate = photo.fileDataRepresentation(){
            
            image = UIImage(data: imageDate)!
            performSegue(withIdentifier: "next", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            
            let preVC = segue.destination as! PreViewController
            preVC.image = self.image!
        }
    }

}

