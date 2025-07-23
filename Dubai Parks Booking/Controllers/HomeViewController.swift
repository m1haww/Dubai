import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    private let parks = [
        ("Dubai Aquarium", "yourdomain.com/aquarium"),
        ("The Green Planet", "yourdomain.com/greenplanet"),
        ("Aquaventure Atlantis", "yourdomain.com/aquaventure"),
        ("IMG Worlds of Adventure", "yourdomain.com/imgworlds")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController viewDidLoad called")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeViewController viewDidAppear called")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Navigation bar setup
        navigationController?.navigationBar.backgroundColor = UIColor(red: 112/255, green: 60/255, blue: 241/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 112/255, green: 60/255, blue: 241/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        title = "Dubai Parks Day Pass"
        
        // Create scroll view for better layout
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Parks"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Stack view for park buttons
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Create park buttons
        for (index, park) in parks.enumerated() {
            let buttonContainer = createParkButton(title: park.0, imageName: "\(index + 1)")
            
            // Add tap gesture to container
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(parkButtonTapped(_:)))
            buttonContainer.tag = index
            buttonContainer.addGestureRecognizer(tapGesture)
            buttonContainer.isUserInteractionEnabled = true
            
            stackView.addArrangedSubview(buttonContainer)
        }
        
        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func createParkButton(title: String, imageName: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 229/255, green: 236/255, blue: 252/255, alpha: 1.0)
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView.layer.shadowRadius = 20
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Background image
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 16
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(backgroundImageView)
        
        // Gradient overlay
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        gradientView.layer.cornerRadius = 16
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(gradientView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 16
        gradientView.layer.addSublayer(gradientLayer)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(titleLabel)
        
        // Arrow button
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "Button")
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(arrowImageView)
        
        containerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            button.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            backgroundImageView.topAnchor.constraint(equalTo: button.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            
            gradientView.topAnchor.constraint(equalTo: button.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -20),
            
            arrowImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
            arrowImageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 30),
            arrowImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Update gradient frame when layout changes
        DispatchQueue.main.async {
            gradientLayer.frame = gradientView.bounds
        }
        
        return containerView
    }
    
    @objc private func parkButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let containerView = sender.view else { return }
        let park = parks[containerView.tag]
        let webViewController = ParkWebViewController()
        webViewController.parkName = park.0
        webViewController.urlString = "https://\(park.1)"
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
