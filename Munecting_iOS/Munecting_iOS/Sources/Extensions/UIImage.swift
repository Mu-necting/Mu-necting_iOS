import UIKit

//이미지 Blur 처리 함수
extension UIImage {
    func applyBlur(radius: CGFloat) -> UIImage? {
        let context = CIContext(options: nil)
        guard let inputImage = CIImage(image: self) else { return nil }

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: inputImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }
}
