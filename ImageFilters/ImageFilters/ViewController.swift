//
//  ViewController.swift
//  ImageFilters
//
//  Created by Sangita on 2021-06-09.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    struct Filter {
        let filterName: String
        var filterEffectValue: Any?
        var filterEffectValueName: String?
        
        init(filterName: String, filterEffectValue: Any?, filterEffectValueName: String?){
            self.filterName = filterName
            self.filterEffectValue = filterEffectValue
            self.filterEffectValueName = filterEffectValueName
        }
    }
    
    @IBOutlet weak var Img: UIImageView!
    private var originalImage: UIImage?
    var isFiltered = false
    
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBOutlet weak var lblSliderValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = Img.image
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        if isFiltered == true{
            Img.image = originalImage
        }
         intensitySlider.minimumValue = 0
         intensitySlider.maximumValue = 100
         
         let currentValue = Int((sender.value).rounded())
         lblSliderValue.text = String(currentValue)
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: currentValue, filterEffectValueName: kCIInputRadiusKey))
    }
    
    
    private func applyFilters(image: UIImage, filterEffect: Filter) -> UIImage? {
        guard let cgImage = image.cgImage,
              let openGLContext = EAGLContext(api: .openGLES3) else {
                return nil
              }
        let context = CIContext(eaglContext: openGLContext)
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterEffect.filterName)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filterEffectValue = filterEffect.filterEffectValue,
           let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        var filteredImage: UIImage?
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
           let cgiImageResult = context.createCGImage(output, from: output.extent){
            filteredImage = UIImage(cgImage: cgiImageResult)
        }
        return filteredImage
    }
    
    @IBAction func applyBlur(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIGaussianBlur", filterEffectValue: 50, filterEffectValueName: kCIInputRadiusKey))
        
        }
    

    @IBAction func applySepian(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CISepiaTone", filterEffectValue: 0.90, filterEffectValueName: kCIInputIntensityKey))
    }
    
    
    @IBAction func applyNoir(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil))    }
    
    @IBAction func applyInvertColor(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIColorInvert", filterEffectValue: nil, filterEffectValueName: nil))
    }
    
    @IBAction func applyHueAdjust(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIHueAdjust", filterEffectValue: 9.0, filterEffectValueName: kCIInputAngleKey))
        
    }
    
    @IBAction func applyComponent(_ sender: Any) {
        guard let image = Img.image else {
            return
        }
        Img.image = applyFilters(image: image, filterEffect: Filter(filterName: "CIMinimumComponent", filterEffectValue: nil, filterEffectValueName: nil))    }
    
    @IBAction func clearFilter(_ sender: Any) {
        Img.image = originalImage
    }
}

