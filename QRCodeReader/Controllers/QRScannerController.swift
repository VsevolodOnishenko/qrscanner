//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

final class QRScannerController: UIViewController {
    
    @IBOutlet private var messageLabel:UILabel!
    @IBOutlet private var topbar: UIView!
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
    }
    
    private func setups() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        
        deviceDiscoverySession.devices.first
            .then { device in
                configurations(from: device)
            }
            .otherwise {
                print("Failed to get the camera device")
                return
        }
    }
    
    private func configurations(from device: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayerConfiguration()
            greenBoxConfigurations()
            
            captureSession.startRunning()
            
        } catch {
            print("Error - \(error.localizedDescription)")
            return
        }
    }
    
    private func videoPreviewLayerConfiguration() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.then { layer in
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.layer.bounds
            view.layer.addSublayer(layer)
        }
    }
    
    private func greenBoxConfigurations() {
        qrCodeFrameView = UIView()
        
        qrCodeFrameView.then { frameView in
            frameView.layer.borderColor = UIColor.green.cgColor
            frameView.layer.borderWidth = 2
            view.addSubview(frameView)
            view.bringSubview(toFront: frameView)
        }
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = .zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        
        metadataObject
            .then { obj in
                if obj.type == AVMetadataObject.ObjectType.qr {
                    
                    let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: obj)
                    qrCodeFrameView?.frame = barCodeObject?.bounds ?? .zero
                }
                
                metadataObject?.stringValue
                    .then {  str in
                        messageLabel.text = str
                }
        }
    }
}
