import UIKit

class Splash_VC: UIViewController {
    
    // MARK: - Properties for Dash
    private var background_image_view_for_dash: UIImageView!
    private var overlay_view_for_dash: UIView!
    private var title_label_for_dash: UILabel!
    private var subtitle_label_for_dash: UILabel!
    private var loading_indicator_for_dash: UIActivityIndicatorView!
    private var start_button_for_dash: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ui_for_dash()
        setup_constraints_for_dash()
        setup_animations_for_dash()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新Start按钮的渐变层frame
        if let gradient_layer = start_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            gradient_layer.frame = start_button_for_dash.bounds
        }
    }
    
    // MARK: - Setup Methods for Dash
    private func setup_ui_for_dash() {
        view.backgroundColor = .black
        
        // Background Image
        background_image_view_for_dash = UIImageView()
        background_image_view_for_dash.image = UIImage(named: "dashforback")
        background_image_view_for_dash.contentMode = .scaleAspectFill
        background_image_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background_image_view_for_dash)
        
        // Overlay View
        overlay_view_for_dash = UIView()
        overlay_view_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay_view_for_dash.layer.cornerRadius = 20
        overlay_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay_view_for_dash)
        
        // Title Label
        title_label_for_dash = UILabel()
        title_label_for_dash.text = "Mahjong Dash"
        title_label_for_dash.textColor = .white
        title_label_for_dash.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        title_label_for_dash.textAlignment = .center
        title_label_for_dash.alpha = 0
        title_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(title_label_for_dash)
        
        // Subtitle Label
        subtitle_label_for_dash = UILabel()
        subtitle_label_for_dash.text = "Fast-paced Mahjong Action"
        subtitle_label_for_dash.textColor = .systemYellow
        subtitle_label_for_dash.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitle_label_for_dash.textAlignment = .center
        subtitle_label_for_dash.alpha = 0
        subtitle_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(subtitle_label_for_dash)
        
        // Loading Indicator
        loading_indicator_for_dash = UIActivityIndicatorView(style: .large)
        loading_indicator_for_dash.color = .white
        loading_indicator_for_dash.alpha = 0
        loading_indicator_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(loading_indicator_for_dash)
        
        // Start Button
        start_button_for_dash = UIButton(type: .system)
        start_button_for_dash.setTitle("Start Game", for: .normal)
        start_button_for_dash.setTitleColor(.white, for: .normal)
        start_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // 创建渐变背景
        let gradient_layer = CAGradientLayer()
        gradient_layer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        gradient_layer.cornerRadius = 25
        
        start_button_for_dash.layer.insertSublayer(gradient_layer, at: 0)
        start_button_for_dash.layer.cornerRadius = 25
        start_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        start_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 4)
        start_button_for_dash.layer.shadowOpacity = 0.3
        start_button_for_dash.layer.shadowRadius = 8
        start_button_for_dash.layer.borderWidth = 2
        start_button_for_dash.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        start_button_for_dash.alpha = 0
        start_button_for_dash.addTarget(self, action: #selector(start_button_tapped_for_dash), for: .touchUpInside)
        start_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(start_button_for_dash)
    }
    
    private func setup_constraints_for_dash() {
        NSLayoutConstraint.activate([
            // Background Image
            background_image_view_for_dash.topAnchor.constraint(equalTo: view.topAnchor),
            background_image_view_for_dash.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background_image_view_for_dash.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background_image_view_for_dash.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Overlay View
            overlay_view_for_dash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay_view_for_dash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overlay_view_for_dash.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            overlay_view_for_dash.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            // Title Label
            title_label_for_dash.topAnchor.constraint(equalTo: overlay_view_for_dash.topAnchor, constant: 60),
            title_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            title_label_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            title_label_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -20),
            
            // Subtitle Label
            subtitle_label_for_dash.topAnchor.constraint(equalTo: title_label_for_dash.bottomAnchor, constant: 20),
            subtitle_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            subtitle_label_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            subtitle_label_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -20),
            
            // Loading Indicator
            loading_indicator_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            loading_indicator_for_dash.centerYAnchor.constraint(equalTo: overlay_view_for_dash.centerYAnchor),
            
            // Start Button
            start_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            start_button_for_dash.bottomAnchor.constraint(equalTo: overlay_view_for_dash.bottomAnchor, constant: -60),
            start_button_for_dash.widthAnchor.constraint(equalToConstant: 200),
            start_button_for_dash.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setup_animations_for_dash() {
        // Start loading indicator
        loading_indicator_for_dash.startAnimating()
        
        // Animate title appearance
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            self.title_label_for_dash.alpha = 1.0
            self.title_label_for_dash.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.title_label_for_dash.transform = .identity
            }
        }
        
        // Animate subtitle appearance
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut) {
            self.subtitle_label_for_dash.alpha = 1.0
        }
        
        // Animate loading indicator appearance
        UIView.animate(withDuration: 0.8, delay: 1.5, options: .curveEaseInOut) {
            self.loading_indicator_for_dash.alpha = 1.0
        }
        
        // Simulate loading and show start button
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.show_start_button_for_dash()
        }
    }
    
    private func show_start_button_for_dash() {
        // Hide loading indicator
        UIView.animate(withDuration: 0.5) {
            self.loading_indicator_for_dash.alpha = 0
        } completion: { _ in
            self.loading_indicator_for_dash.stopAnimating()
        }
        
        // Show start button with animation
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .curveEaseInOut) {
            self.start_button_for_dash.alpha = 1.0
            self.start_button_for_dash.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.start_button_for_dash.transform = .identity
            }
            
            // 设置渐变层的frame
            if let gradient_layer = self.start_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
                gradient_layer.frame = self.start_button_for_dash.bounds
            }
        }
    }
    
    // MARK: - Actions for Dash
    @objc private func start_button_tapped_for_dash() {
        // Add button press animation
        UIView.animate(withDuration: 0.1, animations: {
            self.start_button_for_dash.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.start_button_for_dash.transform = .identity
            } completion: { _ in
                self.transition_to_main_game_for_dash()
            }
        }
    }
    
    private func transition_to_main_game_for_dash() {
        let main_game_vc = Main_Game_VC()
        main_game_vc.modalPresentationStyle = .fullScreen
        main_game_vc.modalTransitionStyle = .crossDissolve
        
        present(main_game_vc, animated: true) {
            // 主游戏页面已经成功展示，不需要dismiss启动页面
            // 启动页面会自动被主游戏页面覆盖
        }
    }
}
