////
////  CameraViewController.swift
////  Dagboksapp
////
////  Created by Mikael Elofsson on 2018-02-12.
////  Copyright © 2018 Mikael Elofsson. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class CameraViewController: UIViewController {
//
//    var captureSession: AVCaptureSession?
//    var rearCamera: AVCaptureDevice?
//    var rearCameraInput: AVCaptureDeviceInput?
//    var currentCameraPosition: CameraPosition?
//
//    enum CameraControllerError: Swift.Error {
//        case captureSessionAlreadyRunning
//        case captureSessionIsMissing
//        case inputsAreInvalid
//        case invalidOperation
//        case noCamerasAvailable
//        case unknown
//    }
//    public enum CameraPosition {
//        case front
//        case rear
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func prepare(completionHandler: @escaping(Error?) -> Void) {
//
//        func createCaptureSession() {
//            self.captureSession = AVCaptureSession()
//        }
//        func configureCaptureDevices() throws {
//
//            let camera = AVCa
//
//
//
//            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
//
//            let cameras = (session.devices.flatMap { $0 })
//
//            guard !cameras.isEmpty else {
//                throw CameraControllerError.noCamerasAvailable
//            }
//
//            for camera in cameras {
//                if camera.position == .back {
//                    self.rearCamera = camera
//
//                    try camera.lockForConfiguration()
//                    camera.focusMode = .continuousAutoFocus
//                    camera.unlockForConfiguration()
//                }
//            }
//        }
//
//        func configureDeviceInputs() throws {
//            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing}
//
//            if let rearCamera = self.rearCamera {
//                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
//
//                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
//
//                self.currentCameraPosition = .rear
//
//            }
//            else {
//                throw CameraControllerError.noCamerasAvailable
//            }
//        }
//        func configurePhotoOutpout() throws {}
//
//        DispatchQueue(label: "prepare").async {
//            do {
//                createCaptureSession()
//            try configureCaptureDevices()
//            try configureDeviceInputs()
//            try configurePhotoOutpout()
//        }
//            catch {
//                DispatchQueue.main.async {
//                    completionHandler(error)
//                }
//
//                return
//            }
//            DispatchQueue.main.async {
//                completionHandler(nil)
//            }
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//}

