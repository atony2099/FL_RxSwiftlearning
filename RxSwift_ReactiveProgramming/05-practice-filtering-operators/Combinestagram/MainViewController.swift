/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RxSwift

class MainViewController: UIViewController {

  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var buttonClear: UIButton!
  @IBOutlet weak var buttonSave: UIButton!
  @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    
    private let bag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    
    

  override func viewDidLoad() {
    super.viewDidLoad()

    images.asObservable()
        .throttle(0.5, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] photos in
            guard let preview = self?.imagePreview else {return}
            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
            
        }).addDisposableTo(bag)
  }
    
    
    func updateUI(photos:[UIImage])  {
        buttonSave.isEnabled = photos.count > 0
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6;
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
    

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  @IBAction func actionClear() {
    images.value = []
  }

  @IBAction func actionSave() {
    guard let image = imagePreview.image else { return }
    
    PhotoWriter.save(image).subscribe( onError: {[weak self] (error) in
        self?.showMessage("Error", description: error.localizedDescription);
    }, onCompleted: {  [weak self] in
        self?.showMessage("Saved")
        self?.actionClear()
        },onDisposed:{
                print("PhotoWriter === dispose")
    } ).addDisposableTo(bag)
  }

  @IBAction func actionAdd() {
    let photosViewController = storyboard!.instantiateViewController(
        withIdentifier: "PhotosViewController") as! PhotosViewController
    
    let newphotos = photosViewController.selectedPhotos.share()
    

    // 过滤
    newphotos
        .takeWhile { [weak self] image in
            return (self?.images.value.count ?? 0) < 6
    }
    
        .filter {  newImage in
            return newImage.size.width > newImage.size.height
    }
    
        .subscribe(onNext: { [weak self] newImage in
            guard let images = self?.images else { return }
            images.value.append(newImage)
            }, onDisposed: {
                print("completed photo selection")
        })
        .addDisposableTo(photosViewController.bag)
    

    
    // 预览的图标
 
    newphotos
        .ignoreElements()
        .subscribe(onCompleted: { [weak self] in
            self?.updateNavigationIcon()
        })
        .addDisposableTo(photosViewController.bag)

    
    navigationController!.pushViewController(photosViewController, animated: true)
  }


    
    private func updateNavigationIcon() {
        let icon = imagePreview.image?
            .scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon,
                                                           style: .done, target: nil, action: nil)
    }
    
    
    
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(bag)
    }

}




extension UIViewController {
    func alert(title: String, text: String?) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                observer.onCompleted()
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

