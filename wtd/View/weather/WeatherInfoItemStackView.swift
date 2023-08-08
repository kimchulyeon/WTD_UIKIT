//
//  W_InfoItemStackView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class WeatherInfoItemStackView: UIStackView {
	//MARK: - Properties
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		return iv
	}()
	private let amountLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.Yeonji(size: 26)
		lb.adjustsFontSizeToFitWidth = true
		lb.minimumScaleFactor = 0.5
		return lb
	}()
	
	//MARK: - Lifecycle
    init(imageName: String, amountText: String, isDust: Bool) {
		super.init(frame: .zero)
		
        layout(imageName: imageName, amountText: amountText, isDust: isDust)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - FUNC==============================
    private func layout(imageName: String, amountText: String, isDust: Bool) {
        if isDust {
            guard let dustAmount = Double(amountText) else { return }
            
            switch dustAmount {
            case 0...15:
                amountLabel.textColor = .systemGreen
            case 16...50:
                amountLabel.textColor = .systemOrange
            case 51...1000:
                amountLabel.textColor = .systemRed
            default:
                break
            }
        }
        
		amountLabel.text = amountText
		imageView.image = UIImage(named: imageName)
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalToConstant: 30),
			imageView.heightAnchor.constraint(equalToConstant: 30),
		])
		
		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .center
		spacing = 8
		addArrangedSubview(imageView)
		addArrangedSubview(amountLabel)
	}
    
    
}

