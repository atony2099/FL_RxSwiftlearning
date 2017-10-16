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

    photosViewController.selectedPhotos.subscribe(onNext: {[weak self] image in
        guard let images = self?.images else { return }
        images.value.append(image)
    }, onDisposed: {
        print("dispose ================")
    }).addDisposableTo(photosViewController.bag)
    navigationController!.pushViewController(photosViewController, animated: true)

  }

      func showMessage(_ title: String, description: String? = nil) {


        alertMessage(title, description: description)
            .subscribe(onNext: { [weak self] in
                print("next")            },
            onDisposed:{
            print("dispose ================")
            }

            )
            .addDisposableTo(bag)

        
        }
}




extension UIViewController {
    
    func alertMessage(_ title: String, description: String? = nil)->Observable<Void>{
        return Observable.create({[weak self] (observe) -> Disposable in
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "close", style: .default, handler: {[weak self] _ in
                observe.onCompleted()
            }))
            self?.present(alert, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated:true, completion: nil)
                print("i have dispose")
            }
        })
    
    }

}