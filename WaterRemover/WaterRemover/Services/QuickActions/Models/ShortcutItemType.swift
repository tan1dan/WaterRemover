
import Foundation

enum ShortcutItemType: String {

	case email1, email2, rateUs

	var title: String {
		
        switch self {
        case .rateUs:
            "🌟 Rate Application"
        case .email2:
            "❓ Ask Questions\nGet answers"
        case .email1:
            "⛔️ Cancel subscription\nand refund money?"
        }
	}

	var subtitle: String? {
        switch self {
        case .rateUs:
            "Your review = better app"
        case .email1:
            "Contact us to find out\n how to unsubscribe"
        case .email2:
            "Feel free contact us any questions"
        }
	}

	var systemImageName: String {
        switch self {
        case .rateUs:
            "star.fill"
        case .email1:
            "envelope"
        case .email2:
            "envelope"
        }
	}

}

import UIKit

extension UIButton {

	enum ImageTitlePosition {
		case imgTop
		case imgBottom
		case imgLeft
		case imgRight
	}

	@discardableResult
	func setImageTitleLayout(position: ImageTitlePosition, spacing: CGFloat = 0) -> UIButton {
		switch position {
		case .imgLeft:
			alignHorizontal(spacing: spacing, imageFirst: true)
		case .imgRight:
			alignHorizontal(spacing: spacing, imageFirst: false)
		case .imgTop:
			alignVertical(spacing: spacing, imageTop: true)
		case .imgBottom:
			alignVertical(spacing: spacing, imageTop: false)
		}
		return self
	}

	private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
		let edgeOffset = spacing / 2
		imageEdgeInsets = UIEdgeInsets(top: 0,
									   left: -1 * edgeOffset,
									   bottom: 0,
									   right: edgeOffset)
		titleEdgeInsets = UIEdgeInsets(top: 0,
									   left: edgeOffset,
									   bottom: 0,
									   right: -1 * edgeOffset)
		if !imageFirst {
			transform = CGAffineTransform(scaleX: -1, y: 1)
			imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
			titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
		}
		contentEdgeInsets = UIEdgeInsets(top: 0,
										 left: edgeOffset,
										 bottom: 0,
										 right: edgeOffset)
	}

	private func alignVertical(spacing: CGFloat, imageTop: Bool) {
		guard let imageSize = imageView?.image?.size,
			  let text = titleLabel?.text,
			  let font = titleLabel?.font
		else {
			return
		}
		let labelString = NSString(string: text)
		let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])

		let imageVerticalOffset = (titleSize.height + spacing) / 2
		let titleVerticalOffset = (imageSize.height + spacing) / 2
		let imageHorizontalOffset = (titleSize.width) / 2
		let titleHorizontalOffset = (imageSize.width) / 2
		let vet: CGFloat = imageTop ? 1 : -1

		imageEdgeInsets = UIEdgeInsets(top: -1 * imageVerticalOffset * vet,
											left: imageHorizontalOffset,
											bottom: imageVerticalOffset * vet,
											right: -1 * imageHorizontalOffset)
		titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * vet,
											left: -1 * titleHorizontalOffset,
											bottom: -1 * titleVerticalOffset * vet,
											right: titleHorizontalOffset)

		let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) / 2
		contentEdgeInsets = UIEdgeInsets(top: edgeOffset,
										 left: 0,
										 bottom: edgeOffset,
										 right: 0)
	}

}
