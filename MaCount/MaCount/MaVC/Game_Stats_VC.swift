import UIKit

class Game_Stats_VC: UIViewController {
    
    // MARK: - Properties for Dash
    private var background_image_view_for_dash: UIImageView!
    private var overlay_view_for_dash: UIView!
    private var title_label_for_dash: UILabel!
    private var stats_scroll_view_for_dash: UIScrollView!
    private var stats_content_view_for_dash: UIView!
    private var back_button_for_dash: UIButton!
    private var reset_stats_button_for_dash: UIButton!
    
    private var stats_data_for_dash: [String: Any] = [:]
    
    // MARK: - Initialization for Dash
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // 初始化默认统计数据
        stats_data_for_dash = [
            "Total Games": 0,
            "Total Score": 0,
            "Average Score": "0.0",
            "Best Combo": 0,
            "Total Tiles Cleared": 0,
            "High Score": 0
        ]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // 初始化默认统计数据
        stats_data_for_dash = [
            "Total Games": 0,
            "Total Score": 0,
            "Average Score": "0.0",
            "Best Combo": 0,
            "Total Tiles Cleared": 0,
            "High Score": 0
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ui_for_dash()
        setup_constraints_for_dash()
        load_stats_for_dash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load_stats_for_dash()
        setup_stats_content_for_dash()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 确保在布局完成后更新内容
        DispatchQueue.main.async {
            self.setup_stats_content_for_dash()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 确保在视图完全显示后加载数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.load_stats_for_dash()
            self.setup_stats_content_for_dash()
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
        overlay_view_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay_view_for_dash.layer.cornerRadius = 20
        overlay_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay_view_for_dash)
        
        // Title Label
        title_label_for_dash = UILabel()
        title_label_for_dash.text = "Game Statistics"
        title_label_for_dash.textColor = .white
        title_label_for_dash.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        title_label_for_dash.textAlignment = .center
        title_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(title_label_for_dash)
        
        // Stats Scroll View
        stats_scroll_view_for_dash = UIScrollView()
        stats_scroll_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(stats_scroll_view_for_dash)
        
        // Stats Content View
        stats_content_view_for_dash = UIView()
        stats_content_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        stats_scroll_view_for_dash.addSubview(stats_content_view_for_dash)
        
        // Back Button
        back_button_for_dash = UIButton(type: .system)
        back_button_for_dash.setTitle("Back", for: .normal)
        back_button_for_dash.setTitleColor(.white, for: .normal)
        back_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        back_button_for_dash.backgroundColor = UIColor.systemRed
        back_button_for_dash.layer.cornerRadius = 20
        back_button_for_dash.addTarget(self, action: #selector(back_button_tapped_for_dash), for: .touchUpInside)
        back_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(back_button_for_dash)
        
        // Reset Stats Button
        reset_stats_button_for_dash = UIButton(type: .system)
        reset_stats_button_for_dash.setTitle("Reset Stats", for: .normal)
        reset_stats_button_for_dash.setTitleColor(.white, for: .normal)
        reset_stats_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reset_stats_button_for_dash.backgroundColor = UIColor.systemOrange
        reset_stats_button_for_dash.layer.cornerRadius = 20
        reset_stats_button_for_dash.addTarget(self, action: #selector(reset_stats_tapped_for_dash), for: .touchUpInside)
        reset_stats_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(reset_stats_button_for_dash)
    }
    
    private func setup_constraints_for_dash() {
        NSLayoutConstraint.activate([
            // Background Image
            background_image_view_for_dash.topAnchor.constraint(equalTo: view.topAnchor),
            background_image_view_for_dash.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background_image_view_for_dash.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background_image_view_for_dash.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Overlay View
            overlay_view_for_dash.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            overlay_view_for_dash.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overlay_view_for_dash.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overlay_view_for_dash.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Title Label
            title_label_for_dash.topAnchor.constraint(equalTo: overlay_view_for_dash.topAnchor, constant: 20),
            title_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            
            // Stats Scroll View
            stats_scroll_view_for_dash.topAnchor.constraint(equalTo: title_label_for_dash.bottomAnchor, constant: 20),
            stats_scroll_view_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            stats_scroll_view_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -20),
            stats_scroll_view_for_dash.bottomAnchor.constraint(equalTo: reset_stats_button_for_dash.topAnchor, constant: -20),
            
            // Stats Content View
            stats_content_view_for_dash.topAnchor.constraint(equalTo: stats_scroll_view_for_dash.topAnchor),
            stats_content_view_for_dash.leadingAnchor.constraint(equalTo: stats_scroll_view_for_dash.leadingAnchor),
            stats_content_view_for_dash.trailingAnchor.constraint(equalTo: stats_scroll_view_for_dash.trailingAnchor),
            stats_content_view_for_dash.bottomAnchor.constraint(equalTo: stats_scroll_view_for_dash.bottomAnchor),
            stats_content_view_for_dash.widthAnchor.constraint(equalTo: stats_scroll_view_for_dash.widthAnchor),
            
            // Reset Stats Button
            reset_stats_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            reset_stats_button_for_dash.bottomAnchor.constraint(equalTo: back_button_for_dash.topAnchor, constant: -20),
            reset_stats_button_for_dash.widthAnchor.constraint(equalToConstant: 150),
            reset_stats_button_for_dash.heightAnchor.constraint(equalToConstant: 45),
            
            // Back Button
            back_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            back_button_for_dash.bottomAnchor.constraint(equalTo: overlay_view_for_dash.bottomAnchor, constant: -20),
            back_button_for_dash.widthAnchor.constraint(equalToConstant: 120),
            back_button_for_dash.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func load_stats_for_dash() {
        // 安全地加载统计数据
        do {
            stats_data_for_dash = Game_Stats_Manager.shared_for_dash.get_stats_summary_for_dash()
        } catch {
            // 如果加载失败，使用默认值
            stats_data_for_dash = [
                "Total Games": 0,
                "Total Score": 0,
                "Average Score": "0.0",
                "Best Combo": 0,
                "Total Tiles Cleared": 0,
                "High Score": 0
            ]
        }
    }
    
    private func setup_stats_content_for_dash() {
        // Clear existing content
        stats_content_view_for_dash.subviews.forEach { $0.removeFromSuperview() }
        
        var y_offset: CGFloat = 0
        
        // Create stat items
        let stat_items = [
            ("Total Games", "\(stats_data_for_dash["Total Games"] ?? 0)", UIColor.systemBlue),
            ("Total Score", "\(stats_data_for_dash["Total Score"] ?? 0)", UIColor.systemGreen),
            ("Average Score", "\(stats_data_for_dash["Average Score"] ?? "0.0")", UIColor.systemYellow),
            ("Best Combo", "\(stats_data_for_dash["Best Combo"] ?? 0)", UIColor.systemOrange),
            ("Total Tiles Cleared", "\(stats_data_for_dash["Total Tiles Cleared"] ?? 0)", UIColor.systemPurple),
            ("High Score", "\(stats_data_for_dash["High Score"] ?? 0)", UIColor.systemRed)
        ]
        
        for (title, value, color) in stat_items {
            let stat_view = create_stat_item_for_dash(title: title, value: value, color: color, y_offset: &y_offset)
            stats_content_view_for_dash.addSubview(stat_view)
        }
        
        // Set content view height - 修复约束问题
        if let height_constraint = stats_content_view_for_dash.constraints.first(where: { $0.firstAttribute == .height }) {
            height_constraint.constant = y_offset + 20
        } else {
            let height_constraint = stats_content_view_for_dash.heightAnchor.constraint(equalToConstant: y_offset + 20)
            height_constraint.isActive = true
        }
    }
    
    private func create_stat_item_for_dash(title: String, value: String, color: UIColor, y_offset: inout CGFloat) -> UIView {
        let container_view = UIView()
        container_view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container_view.layer.cornerRadius = 15
        container_view.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        let title_label = UILabel()
        title_label.text = title
        title_label.textColor = .white
        title_label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        title_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(title_label)
        
        // Value Label
        let value_label = UILabel()
        value_label.text = value
        value_label.textColor = color
        value_label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        value_label.textAlignment = .right
        value_label.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(value_label)
        
        // Icon View
        let icon_view = UIView()
        icon_view.backgroundColor = color
        icon_view.layer.cornerRadius = 8
        icon_view.translatesAutoresizingMaskIntoConstraints = false
        container_view.addSubview(icon_view)
        
        // 安全地设置约束
        NSLayoutConstraint.activate([
            container_view.topAnchor.constraint(equalTo: stats_content_view_for_dash.topAnchor, constant: y_offset),
            container_view.leadingAnchor.constraint(equalTo: stats_content_view_for_dash.leadingAnchor, constant: 10),
            container_view.trailingAnchor.constraint(equalTo: stats_content_view_for_dash.trailingAnchor, constant: -10),
            container_view.heightAnchor.constraint(equalToConstant: 60),
            
            icon_view.leadingAnchor.constraint(equalTo: container_view.leadingAnchor, constant: 15),
            icon_view.centerYAnchor.constraint(equalTo: container_view.centerYAnchor),
            icon_view.widthAnchor.constraint(equalToConstant: 16),
            icon_view.heightAnchor.constraint(equalToConstant: 16),
            
            title_label.leadingAnchor.constraint(equalTo: icon_view.trailingAnchor, constant: 15),
            title_label.centerYAnchor.constraint(equalTo: container_view.centerYAnchor),
            title_label.trailingAnchor.constraint(equalTo: value_label.leadingAnchor, constant: -15),
            
            value_label.trailingAnchor.constraint(equalTo: container_view.trailingAnchor, constant: -15),
            value_label.centerYAnchor.constraint(equalTo: container_view.centerYAnchor),
            value_label.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        y_offset += 70
        return container_view
    }
    
    // MARK: - Actions for Dash
    @objc private func back_button_tapped_for_dash() {
        dismiss(animated: true)
    }
    
    @objc private func reset_stats_tapped_for_dash() {
        let alert = UIAlertController(title: "Reset Statistics", message: "Are you sure you want to reset all game statistics? This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.reset_all_stats_for_dash()
        })
        
        present(alert, animated: true)
    }
    
    private func reset_all_stats_for_dash() {
        Game_Stats_Manager.shared_for_dash.reset_all_stats_for_dash()
        load_stats_for_dash()
        setup_stats_content_for_dash()
        
        // Show confirmation
        let confirmation_alert = UIAlertController(title: "Statistics Reset", message: "All game statistics have been reset successfully.", preferredStyle: .alert)
        confirmation_alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(confirmation_alert, animated: true)
    }
}
