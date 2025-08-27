import UIKit

protocol MahjongTileViewDelegate: AnyObject {
    func tile_tapped_for_dash(_ tile: MahjongTileView)
    func tile_exploded_for_dash(_ tile: MahjongTileView)
}

class MahjongTileView: UIView {
    
    weak var delegate: MahjongTileViewDelegate?
    private var countdown_timer_for_dash: Timer?
    private var remaining_time_for_dash: TimeInterval = 0
    private var initial_time_for_dash: TimeInterval = 0 // 新增：存储初始时间
    private var is_paused_for_dash: Bool = false
    
    private var tile_image_view_for_dash: UIImageView!
    private var countdown_label_for_dash: UILabel!
    // 移除进度条设置
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup_tile_for_dash()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup_tile_for_dash()
    }
    
    // 新增：支持自定义尺寸的初始化方法
    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    private func setup_tile_for_dash() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(tile_tapped_for_dash))
        addGestureRecognizer(tap_gesture)
        
        setup_tile_image_for_dash()
        setup_countdown_ui_for_dash()
        // 移除进度条设置
    }
    
    private func setup_tile_image_for_dash() {
        tile_image_view_for_dash = UIImageView()
        tile_image_view_for_dash.contentMode = .scaleAspectFit
        tile_image_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tile_image_view_for_dash)
        
        set_random_tile_image_for_dash()
        
        NSLayoutConstraint.activate([
            tile_image_view_for_dash.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tile_image_view_for_dash.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            tile_image_view_for_dash.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            tile_image_view_for_dash.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setup_countdown_ui_for_dash() {
        countdown_label_for_dash = UILabel()
        countdown_label_for_dash.textColor = .white
        countdown_label_for_dash.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        countdown_label_for_dash.textAlignment = .center
        countdown_label_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        countdown_label_for_dash.layer.cornerRadius = 8
        countdown_label_for_dash.clipsToBounds = true
        countdown_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countdown_label_for_dash)
        
        NSLayoutConstraint.activate([
            countdown_label_for_dash.topAnchor.constraint(equalTo: tile_image_view_for_dash.bottomAnchor, constant: 12),
            countdown_label_for_dash.centerXAnchor.constraint(equalTo: centerXAnchor),
            countdown_label_for_dash.widthAnchor.constraint(equalToConstant: 65),
            countdown_label_for_dash.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    // 移除进度条设置
    
    private func set_random_tile_image_for_dash() {
        let tile_images = [
            "dashTiao 1", "dashTiao 2", "dashTiao 3", "dashTiao 4", "dashTiao 5",
            "dashTiao 6", "dashTiao 7", "dashTiao 8", "dashTiao 9",
            "dashTong 1", "dashTong 2", "dashTong 3", "dashTong 4", "dashTong 5",
            "dashTong 6", "dashTong 7", "dashTong 8", "dashTong 9",
            "dashWan 1", "dashWan 2", "dashWan 3", "dashWan 4", "dashWan 5",
            "dashWan 6", "dashWan 7", "dashWan 8", "dashWan 9"
        ]
        
        let random_image_name = tile_images.randomElement() ?? "dashTiao 1"
        tile_image_view_for_dash.image = UIImage(named: random_image_name)
    }
    
    // MARK: - Public Methods for Dash
    func start_countdown_for_dash(duration: TimeInterval) {
        remaining_time_for_dash = duration
        initial_time_for_dash = duration // 初始化
        is_paused_for_dash = false
        
        countdown_timer_for_dash = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.update_countdown_for_dash()
        }
        
        update_countdown_display_for_dash()
    }
    
    func pause_countdown_for_dash() {
        is_paused_for_dash = true
        countdown_timer_for_dash?.invalidate()
    }
    
    func stop_countdown_for_dash() {
        is_paused_for_dash = true
        countdown_timer_for_dash?.invalidate()
        countdown_timer_for_dash = nil
        remaining_time_for_dash = 0
    }
    
    func extend_time_for_dash(by seconds: TimeInterval) {
        remaining_time_for_dash += seconds
        initial_time_for_dash += seconds // 同时更新初始时间
        update_countdown_display_for_dash()
    }
    
    // MARK: - Private Methods for Dash
    private func update_countdown_for_dash() {
        guard !is_paused_for_dash else { return }
        
        remaining_time_for_dash -= 0.1
        
        if remaining_time_for_dash <= 0 {
            tile_exploded_for_dash()
        } else {
            update_countdown_display_for_dash()
        }
    }
    
    private func update_countdown_display_for_dash() {
        let time_string = String(format: "%.1f", remaining_time_for_dash)
        countdown_label_for_dash.text = time_string
        
        // Update progress bar - use the stored initial duration
        let progress = Float(remaining_time_for_dash / initial_time_for_dash)
        // 移除进度条设置
        
        // Change colors based on time remaining
        if remaining_time_for_dash <= 2.0 {
            countdown_label_for_dash.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
            // 移除进度条设置
            
            // Add warning animation
            add_warning_animation_for_dash()
        } else if remaining_time_for_dash <= 4.0 {
            countdown_label_for_dash.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
            // 移除进度条设置
        } else {
            countdown_label_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            // 移除进度条设置
        }
    }
    
    private func add_warning_animation_for_dash() {
        let pulse_animation = CABasicAnimation(keyPath: "transform.scale")
        pulse_animation.duration = 0.3
        pulse_animation.fromValue = 1.0
        pulse_animation.toValue = 1.1
        pulse_animation.autoreverses = true
        pulse_animation.repeatCount = 1
        
        layer.add(pulse_animation, forKey: "pulse")
    }
    
    private func tile_exploded_for_dash() {
        countdown_timer_for_dash?.invalidate()
        countdown_timer_for_dash = nil
        
        // 直接通知代理游戏结束，不显示爆炸动画
        delegate?.tile_exploded_for_dash(self)
    }
    
    // MARK: - Actions for Dash
    @objc private func tile_tapped_for_dash() {
        guard remaining_time_for_dash > 0 else { return }
        
        // 立即停止倒计时
        countdown_timer_for_dash?.invalidate()
        countdown_timer_for_dash = nil
        
        // 立即通知代理，不等待动画
        delegate?.tile_tapped_for_dash(self)
        
        // 简单的消失动画
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
}
    // MARK: - Tile Type Enum for Dash
enum TileType {
    case tiao
    case tong
    case wan
    case random
}
