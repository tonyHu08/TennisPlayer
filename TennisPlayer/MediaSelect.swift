import UIKit
import MobileCoreServices
import AVFoundation

extension NewPlayerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        if mediaType == (kUTTypeMovie as String) {
            // 获取视频url
            videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            // 将视频url转换为视频资源
            let asset = AVAsset(url: videoUrl)
            // 从视频资源中选取一张图片
            let gen = AVAssetImageGenerator(asset: asset)
            // 图片在视频中的时间位置
            let time = CMTime(seconds: 0, preferredTimescale: 1)
            // 从视频中time的位置copy一张CGImage的图片
            let image = try! gen.copyCGImage(at: time, actualTime: nil)
            // 将CGImage转换为UIImage设置为背景图片
            headImg.image = UIImage(cgImage: image)

            playBtn.isHidden = false
        } else {
            headImg.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewPlayerController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let photoAction = UIAlertAction(title: "添加照片", style: .default) { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    print("授权不成功！")
                    return
                }

                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary

                picker.delegate = self
                self.present(picker, animated: true)
            }

            let takePhotoAction = UIAlertAction(title: "拍摄照片", style: .default) { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    print("授权不成功！")
                    return
                }

                let picker = UIImagePickerController()
                picker.sourceType = .camera

                picker.delegate = self
                self.present(picker, animated: true)
            }

            let videoAction = UIAlertAction(title: "添加视频", style: .default) { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    print("授权不成功！")
                    return
                }

                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.mediaTypes = [kUTTypeMovie as String]

                picker.delegate = self
                self.present(picker, animated: true)
            }

            let recordAction = UIAlertAction(title: "拍摄视频", style: .default) { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    print("授权不成功！")
                    return
                }

                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.videoQuality = .typeHigh
                picker.videoMaximumDuration = 10

                picker.delegate = self
                self.present(picker, animated: true)
            }

            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in

            }

            actionSheet.addAction(photoAction)
            actionSheet.addAction(takePhotoAction)
            actionSheet.addAction(videoAction)
            actionSheet.addAction(recordAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
        }
        //tableView.allowsSelection = false
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellId = String(describing: DetailCell.self)
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
//        return cell
//    }
}

