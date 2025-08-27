import UIKit
import CoreData

class Main_Game_VC: UIViewController {
    
    // MARK: - Properties for Dash
    private var game_timer_for_dash: Timer?
    private var score_for_dash: Int = 0
    private var lives_for_dash: Int = 3
    private var game_mode_for_dash: GameMode = .classic
    private var is_game_active_for_dash: Bool = false
    
    // MARK: - UI Elements for Dash
    private var background_image_view_for_dash: UIImageView!
    private var overlay_view_for_dash: UIView!
    private var score_label_for_dash: UILabel!
    private var lives_label_for_dash: UILabel!
    private var combo_label_for_dash: UILabel!
    private var game_area_view_for_dash: UIView!
    private var start_button_for_dash: UIButton!
    private var pause_button_for_dash: UIButton!
    private var settings_button_for_dash: UIButton!
    private var high_scores_button_for_dash: UIButton!
    private var game_over_view_for_dash: UIView!
    private var back_button_for_dash: UIButton! // 新增返回按钮
    private var difficulty_info_label_for_dash: UILabel! // 新增难度信息标签
    
    // MARK: - Game Elements for Dash
    private var mahjong_tiles_for_dash: [MahjongTileView] = []
    private var tile_spawn_timer_for_dash: Timer?
    private var current_level_for_dash: Int = 1
    private var tiles_cleared_for_dash: Int = 0
    private var combo_count_for_dash: Int = 0
    private var last_tap_time_for_dash: TimeInterval = 0
    
    // MARK: - Constants for Dash
    private let tile_width_for_dash: CGFloat = 80 // 麻将图片宽度
    private let tile_height_for_dash: CGFloat = 100 // 麻将图片高度（增加20像素）
    private let min_tiles_for_dash: Int = 6
    private let max_tiles_for_dash: Int = 12
    private let base_countdown_for_dash: TimeInterval = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ui_for_dash()
        setup_constraints_for_dash()
        setup_game_for_dash()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新所有渐变层的frame
        update_gradient_layers_frame_for_dash()
        
        // 如果游戏正在进行中，确保麻将图片在正确的位置
        if is_game_active_for_dash && mahjong_tiles_for_dash.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.spawn_initial_tiles_for_dash()
            }
        }
    }
    
    private func update_gradient_layers_frame_for_dash() {
        // 更新Start按钮的渐变层
        if let start_gradient_layer = start_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            start_gradient_layer.frame = start_button_for_dash.bounds
        }
        
        // 更新Pause按钮的渐变层
        if let pause_gradient_layer = pause_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            pause_gradient_layer.frame = pause_button_for_dash.bounds
        }
        
        // 更新High Scores按钮的渐变层
        if let high_scores_gradient_layer = high_scores_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            high_scores_gradient_layer.frame = high_scores_button_for_dash.bounds
        }
        
        // 更新Settings按钮的渐变层
        if let settings_gradient_layer = settings_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            settings_gradient_layer.frame = settings_button_for_dash.bounds
        }
        
        // 更新Back按钮的渐变层
        if let back_gradient_layer = back_button_for_dash.layer.sublayers?.first as? CAGradientLayer {
            back_gradient_layer.frame = back_button_for_dash.bounds
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
        overlay_view_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlay_view_for_dash.layer.cornerRadius = 20
        overlay_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay_view_for_dash)
        
        // Score Label
        score_label_for_dash = UILabel()
        score_label_for_dash.text = "Score: 0"
        score_label_for_dash.textColor = .white
        score_label_for_dash.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        score_label_for_dash.textAlignment = .center
        score_label_for_dash.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        score_label_for_dash.layer.cornerRadius = 4 // 设置圆角为4
        score_label_for_dash.layer.masksToBounds = true // 确保圆角效果显示
        score_label_for_dash.layer.shadowColor = UIColor.black.cgColor
        score_label_for_dash.layer.shadowOffset = CGSize(width: 1, height: 1)
        score_label_for_dash.layer.shadowOpacity = 0.4
        score_label_for_dash.layer.shadowRadius = 3
        score_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(score_label_for_dash)
        
        // Lives Label
        lives_label_for_dash = UILabel()
        lives_label_for_dash.text = "Lives: 3 | Level: 1"
        lives_label_for_dash.textColor = .white
        lives_label_for_dash.font = UIFont.systemFont(ofSize: 18, weight: .semibold) // 稍微减小字体以适应更多内容
        lives_label_for_dash.textAlignment = .center
        lives_label_for_dash.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        lives_label_for_dash.layer.cornerRadius = 4 // 设置圆角为4
        lives_label_for_dash.layer.masksToBounds = true // 确保圆角效果显示
        lives_label_for_dash.layer.shadowColor = UIColor.black.cgColor
        lives_label_for_dash.layer.shadowOffset = CGSize(width: 1, height: 1)
        lives_label_for_dash.layer.shadowOpacity = 0.4
        lives_label_for_dash.layer.shadowRadius = 3
        lives_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(lives_label_for_dash)
        
        // Combo Label
        combo_label_for_dash = UILabel()
        combo_label_for_dash.text = "Combo: 0"
        combo_label_for_dash.textColor = .white
        combo_label_for_dash.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        combo_label_for_dash.textAlignment = .center
        combo_label_for_dash.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        combo_label_for_dash.layer.cornerRadius = 4 // 设置圆角为4
        combo_label_for_dash.layer.masksToBounds = true // 确保圆角效果显示
        combo_label_for_dash.layer.shadowColor = UIColor.black.cgColor
        combo_label_for_dash.layer.shadowOffset = CGSize(width: 1, height: 1)
        combo_label_for_dash.layer.shadowOpacity = 0.3
        combo_label_for_dash.layer.shadowRadius = 2
        combo_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(combo_label_for_dash)
        
        // Game Area
        game_area_view_for_dash = UIView()
        game_area_view_for_dash.backgroundColor = UIColor.red.withAlphaComponent(0.1) // 添加半透明背景色以便调试
        game_area_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(game_area_view_for_dash)
        
        // Start Button
        start_button_for_dash = UIButton(type: .system)
        start_button_for_dash.setTitle("Start Game", for: .normal)
        start_button_for_dash.setTitleColor(.white, for: .normal)
        start_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        // 创建渐变背景
        let start_gradient_layer = CAGradientLayer()
        start_gradient_layer.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor
        ]
        start_gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        start_gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        start_gradient_layer.cornerRadius = 25
        
        start_button_for_dash.layer.insertSublayer(start_gradient_layer, at: 0)
        start_button_for_dash.layer.cornerRadius = 25
        start_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        start_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 3)
        start_button_for_dash.layer.shadowOpacity = 0.3
        start_button_for_dash.layer.shadowRadius = 6
        
        start_button_for_dash.addTarget(self, action: #selector(start_game_for_dash), for: .touchUpInside)
        start_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(start_button_for_dash)
        
        // Pause Button
        pause_button_for_dash = UIButton(type: .system)
        pause_button_for_dash.setTitle("Pause", for: .normal)
        pause_button_for_dash.setTitleColor(.white, for: .normal)
        pause_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        // 创建渐变背景
        let pause_gradient_layer = CAGradientLayer()
        pause_gradient_layer.colors = [
            UIColor.systemOrange.cgColor,
            UIColor.systemRed.cgColor
        ]
        pause_gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        pause_gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        pause_gradient_layer.cornerRadius = 20
        
        pause_button_for_dash.layer.insertSublayer(pause_gradient_layer, at: 0)
        pause_button_for_dash.layer.cornerRadius = 20
        pause_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        pause_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 2)
        pause_button_for_dash.layer.shadowOpacity = 0.3
        pause_button_for_dash.layer.shadowRadius = 4
        
        pause_button_for_dash.isHidden = true
        pause_button_for_dash.addTarget(self, action: #selector(pause_game_for_dash), for: .touchUpInside)
        pause_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(pause_button_for_dash)
        
        // High Scores Button
        high_scores_button_for_dash = UIButton(type: .system)
        high_scores_button_for_dash.setTitle("🏆", for: .normal)
        high_scores_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        // 创建渐变背景
        let high_scores_gradient_layer = CAGradientLayer()
        high_scores_gradient_layer.colors = [
            UIColor.systemYellow.cgColor,
            UIColor.systemOrange.cgColor
        ]
        high_scores_gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        high_scores_gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        high_scores_gradient_layer.cornerRadius = 20
        
        high_scores_button_for_dash.layer.insertSublayer(high_scores_gradient_layer, at: 0)
        high_scores_button_for_dash.layer.cornerRadius = 20
        high_scores_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        high_scores_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 2)
        high_scores_button_for_dash.layer.shadowOpacity = 0.3
        high_scores_button_for_dash.layer.shadowRadius = 4
        
        high_scores_button_for_dash.addTarget(self, action: #selector(open_high_scores_for_dash), for: .touchUpInside)
        high_scores_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(high_scores_button_for_dash)
        
        // Settings Button
        settings_button_for_dash = UIButton(type: .system)
        settings_button_for_dash.setTitle("⚙️", for: .normal)
        settings_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        // 创建渐变背景
        let settings_gradient_layer = CAGradientLayer()
        settings_gradient_layer.colors = [
            UIColor.systemGray.cgColor,
            UIColor.systemGray2.cgColor
        ]
        settings_gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        settings_gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        settings_gradient_layer.cornerRadius = 20
        
        settings_button_for_dash.layer.insertSublayer(settings_gradient_layer, at: 0)
        settings_button_for_dash.layer.cornerRadius = 20
        settings_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        settings_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 2)
        settings_button_for_dash.layer.shadowOpacity = 0.3
        settings_button_for_dash.layer.shadowRadius = 4
        
        settings_button_for_dash.addTarget(self, action: #selector(open_settings_for_dash), for: .touchUpInside)
        settings_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(settings_button_for_dash)
        
        // Back Button
        back_button_for_dash = UIButton(type: .system)
        back_button_for_dash.setTitle("←", for: .normal)
        back_button_for_dash.setTitleColor(.white, for: .normal)
        back_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        // 创建渐变背景
        let back_gradient_layer = CAGradientLayer()
        back_gradient_layer.colors = [
            UIColor.systemGray.cgColor,
            UIColor.systemGray2.cgColor
        ]
        back_gradient_layer.startPoint = CGPoint(x: 0, y: 0)
        back_gradient_layer.endPoint = CGPoint(x: 1, y: 1)
        back_gradient_layer.cornerRadius = 20
        
        back_button_for_dash.layer.insertSublayer(back_gradient_layer, at: 0)
        back_button_for_dash.layer.cornerRadius = 20
        back_button_for_dash.layer.shadowColor = UIColor.black.cgColor
        back_button_for_dash.layer.shadowOffset = CGSize(width: 0, height: 2)
        back_button_for_dash.layer.shadowOpacity = 0.3
        back_button_for_dash.layer.shadowRadius = 4
        
        back_button_for_dash.addTarget(self, action: #selector(go_back_for_dash), for: .touchUpInside)
        back_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(back_button_for_dash)
        
        // Game Over View
        game_over_view_for_dash = UIView()
        game_over_view_for_dash.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        game_over_view_for_dash.layer.cornerRadius = 20
        game_over_view_for_dash.isHidden = true
        game_over_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(game_over_view_for_dash)
        
        // Difficulty Info Label
        difficulty_info_label_for_dash = UILabel()
        difficulty_info_label_for_dash.text = "Difficulty: Normal | Countdown: 4.0-6.0s"
        difficulty_info_label_for_dash.textColor = .white
        difficulty_info_label_for_dash.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        difficulty_info_label_for_dash.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.7)
        difficulty_info_label_for_dash.layer.cornerRadius = 4 // 设置圆角为4
        difficulty_info_label_for_dash.layer.masksToBounds = true // 确保圆角效果显示
        difficulty_info_label_for_dash.textAlignment = .center
        difficulty_info_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(difficulty_info_label_for_dash)
        
        setup_game_over_ui_for_dash()
    }
    
    private func setup_game_over_ui_for_dash() {
        let final_score_label = UILabel()
        final_score_label.text = "Game Over!"
        final_score_label.textColor = .white
        final_score_label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        final_score_label.textAlignment = .center
        final_score_label.translatesAutoresizingMaskIntoConstraints = false
        game_over_view_for_dash.addSubview(final_score_label)
        
        let score_value_label = UILabel()
        score_value_label.text = "Final Score: 0"
        score_value_label.textColor = .white
        score_value_label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        score_value_label.textAlignment = .center
        score_value_label.translatesAutoresizingMaskIntoConstraints = false
        game_over_view_for_dash.addSubview(score_value_label)
        
        let stats_label = UILabel()
        stats_label.text = "Tiles Cleared: 0 | Best Combo: 0"
        stats_label.textColor = .systemYellow
        stats_label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        stats_label.textAlignment = .center
        stats_label.translatesAutoresizingMaskIntoConstraints = false
        game_over_view_for_dash.addSubview(stats_label)
        
        let restart_button = UIButton(type: .system)
        restart_button.setTitle("Play Again", for: .normal)
        restart_button.setTitleColor(.white, for: .normal)
        restart_button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        restart_button.backgroundColor = UIColor.systemGreen
        restart_button.layer.cornerRadius = 20
        restart_button.addTarget(self, action: #selector(restart_game_for_dash), for: .touchUpInside)
        restart_button.translatesAutoresizingMaskIntoConstraints = false
        game_over_view_for_dash.addSubview(restart_button)
        
        NSLayoutConstraint.activate([
            final_score_label.centerXAnchor.constraint(equalTo: game_over_view_for_dash.centerXAnchor),
            final_score_label.topAnchor.constraint(equalTo: game_over_view_for_dash.topAnchor, constant: 30),
            
            score_value_label.centerXAnchor.constraint(equalTo: game_over_view_for_dash.centerXAnchor),
            score_value_label.topAnchor.constraint(equalTo: final_score_label.bottomAnchor, constant: 20),
            
            stats_label.centerXAnchor.constraint(equalTo: game_over_view_for_dash.centerXAnchor),
            stats_label.topAnchor.constraint(equalTo: score_value_label.bottomAnchor, constant: 15),
            stats_label.leadingAnchor.constraint(equalTo: game_over_view_for_dash.leadingAnchor, constant: 20),
            stats_label.trailingAnchor.constraint(equalTo: game_over_view_for_dash.trailingAnchor, constant: -20),
            
            restart_button.centerXAnchor.constraint(equalTo: game_over_view_for_dash.centerXAnchor),
            restart_button.topAnchor.constraint(equalTo: stats_label.bottomAnchor, constant: 25),
            restart_button.widthAnchor.constraint(equalToConstant: 150),
            restart_button.heightAnchor.constraint(equalToConstant: 50)
        ])
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
            
            // Score Label
            score_label_for_dash.topAnchor.constraint(equalTo: overlay_view_for_dash.topAnchor, constant: 60),
            score_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            score_label_for_dash.widthAnchor.constraint(equalToConstant: 160), // 从150增加到160
            score_label_for_dash.heightAnchor.constraint(equalToConstant: 30),
            
            // Lives Label
            lives_label_for_dash.topAnchor.constraint(equalTo: score_label_for_dash.bottomAnchor, constant: 10),
            lives_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            lives_label_for_dash.widthAnchor.constraint(equalToConstant: 200), // 添加宽度约束
            lives_label_for_dash.heightAnchor.constraint(equalToConstant: 30), // 添加高度约束
            
            // Combo Label
            combo_label_for_dash.topAnchor.constraint(equalTo: lives_label_for_dash.bottomAnchor, constant: 10),
            combo_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            combo_label_for_dash.widthAnchor.constraint(equalToConstant: 150), // 添加宽度约束
            combo_label_for_dash.heightAnchor.constraint(equalToConstant: 25), // 添加高度约束
            
            // Game Area
            game_area_view_for_dash.topAnchor.constraint(equalTo: combo_label_for_dash.bottomAnchor, constant: 20),
            game_area_view_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            game_area_view_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -20),
            game_area_view_for_dash.bottomAnchor.constraint(equalTo: start_button_for_dash.topAnchor, constant: -20),
            
            // Start Button
            start_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            start_button_for_dash.bottomAnchor.constraint(equalTo: settings_button_for_dash.topAnchor, constant: -20),
            start_button_for_dash.widthAnchor.constraint(equalToConstant: 200),
            start_button_for_dash.heightAnchor.constraint(equalToConstant: 50),
            
            // Pause Button
            pause_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            pause_button_for_dash.bottomAnchor.constraint(equalTo: settings_button_for_dash.topAnchor, constant: -20),
            pause_button_for_dash.widthAnchor.constraint(equalToConstant: 120),
            pause_button_for_dash.heightAnchor.constraint(equalToConstant: 40),
            
            // High Scores Button
            high_scores_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor, constant: -40),
            high_scores_button_for_dash.bottomAnchor.constraint(equalTo: overlay_view_for_dash.bottomAnchor, constant: -20),
            high_scores_button_for_dash.widthAnchor.constraint(equalToConstant: 50),
            high_scores_button_for_dash.heightAnchor.constraint(equalToConstant: 50),
            
            // Settings Button
            settings_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor, constant: 40),
            settings_button_for_dash.bottomAnchor.constraint(equalTo: overlay_view_for_dash.bottomAnchor, constant: -20),
            settings_button_for_dash.widthAnchor.constraint(equalToConstant: 50),
            settings_button_for_dash.heightAnchor.constraint(equalToConstant: 50),
            
            // Back Button
            back_button_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            back_button_for_dash.topAnchor.constraint(equalTo: overlay_view_for_dash.topAnchor, constant: 20),
            back_button_for_dash.widthAnchor.constraint(equalToConstant: 50),
            back_button_for_dash.heightAnchor.constraint(equalToConstant: 50),
            
            // Difficulty Info Label
            difficulty_info_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            difficulty_info_label_for_dash.topAnchor.constraint(equalTo: combo_label_for_dash.bottomAnchor, constant: 15),
            difficulty_info_label_for_dash.widthAnchor.constraint(equalToConstant: 280),
            difficulty_info_label_for_dash.heightAnchor.constraint(equalToConstant: 25),
            
            // Game Over View
            game_over_view_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            game_over_view_for_dash.centerYAnchor.constraint(equalTo: overlay_view_for_dash.centerYAnchor),
            game_over_view_for_dash.widthAnchor.constraint(equalToConstant: 300),
            game_over_view_for_dash.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setup_game_for_dash() {
        // 确保游戏完全停止
        is_game_active_for_dash = false
        
        // 停止并清理所有定时器
        stop_tile_spawn_timer_for_dash()
        game_timer_for_dash?.invalidate()
        game_timer_for_dash = nil
        
        // 清理所有现有的麻将牌
        clear_all_tiles_for_dash()
        
        // Initialize game state
        score_for_dash = 0
        lives_for_dash = 3
        current_level_for_dash = 1
        tiles_cleared_for_dash = 0
        combo_count_for_dash = 0
        last_tap_time_for_dash = 0
        
        // 初始化难度信息标签
        difficulty_info_label_for_dash.text = "Difficulty: Normal | Countdown: 4.0-6.0s"
        
        // 重置UI状态
        start_button_for_dash.isHidden = false
        pause_button_for_dash.isHidden = true
        game_over_view_for_dash.isHidden = true
        
        update_ui_for_dash()
    }
    
    // MARK: - Game Logic Methods for Dash
    @objc private func start_game_for_dash() {
        // 防止重复开始游戏
        if is_game_active_for_dash {
            return
        }
        
        is_game_active_for_dash = true
        start_button_for_dash.isHidden = true
        pause_button_for_dash.isHidden = false
        game_over_view_for_dash.isHidden = true
        
        // 延迟生成麻将图片，确保布局完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.spawn_initial_tiles_for_dash()
        }
        start_tile_spawn_timer_for_dash()
    }
    
    @objc private func pause_game_for_dash() {
        is_game_active_for_dash = false
        start_button_for_dash.isHidden = false
        pause_button_for_dash.isHidden = true
        
        stop_tile_spawn_timer_for_dash()
        pause_all_tiles_for_dash()
        
        // Reset combo when pausing
        combo_count_for_dash = 0
        update_ui_for_dash()
    }
    
    @objc private func restart_game_for_dash() {
        // 完全停止当前游戏状态
        stop_current_game_completely_for_dash()
        // 重新设置游戏
        setup_game_for_dash()
        // 开始新游戏
        start_game_for_dash()
    }
    
    @objc private func open_high_scores_for_dash() {
        let high_scores_vc = High_Scores_VC()
        high_scores_vc.modalPresentationStyle = .fullScreen
        present(high_scores_vc, animated: true)
    }
    
    @objc private func open_settings_for_dash() {
        let settings_vc = Settings_VC()
        settings_vc.modalPresentationStyle = .fullScreen
        present(settings_vc, animated: true)
    }
    
    @objc private func go_back_for_dash() {
        dismiss(animated: true, completion: nil)
    }
    
    private func spawn_initial_tiles_for_dash() {
        // 安全检查：只有当游戏活跃时才生成麻将牌
        guard is_game_active_for_dash else {
            return
        }
        
        // 始终显示3x3网格的9张麻将图片
        let tile_count = 9
        
        // 清空现有麻将图片数组（先停止它们的倒计时）
        for tile in self.mahjong_tiles_for_dash {
            tile.stop_countdown_for_dash()
            tile.removeFromSuperview()
        }
        self.mahjong_tiles_for_dash.removeAll()
        
        // 强制刷新游戏区域的布局
        self.game_area_view_for_dash.layoutIfNeeded()
        
        // 等待布局完成后进行精确定位
        DispatchQueue.main.async {
            let game_area_bounds = self.game_area_view_for_dash.bounds
            
            // 确保游戏区域有足够的空间
            guard game_area_bounds.width > 0, game_area_bounds.height > 0 else {
                // 如果游戏区域还没有布局完成，延迟执行（但要检查游戏是否仍然活跃）
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if self.is_game_active_for_dash {
                        self.spawn_initial_tiles_for_dash()
                    }
                }
                return
            }
            
        
            // 3x3网格布局计算 - 确保完全居中
            let total_width = self.tile_width_for_dash * 3
            let total_height = self.tile_height_for_dash * 3
            
            // 计算起始位置，确保网格在游戏区域中完全居中
            let start_x = (game_area_bounds.width - total_width) / 2
            let start_y = (game_area_bounds.height - total_height) / 2
            
            // 按照3x3网格的顺序生成麻将图片
            for i in 0..<tile_count {
                let grid_x = i % 3
                let grid_y = i / 3
                
                let tile = MahjongTileView(width: self.tile_width_for_dash, height: self.tile_height_for_dash)
                tile.delegate = self
                
                // 精确计算每个麻将图片的位置
                let x = start_x + CGFloat(grid_x) * self.tile_width_for_dash
                let y = start_y + CGFloat(grid_y) * self.tile_height_for_dash
                                
                tile.frame = CGRect(x: x, y: y, width: self.tile_width_for_dash, height: self.tile_height_for_dash)
                
                self.game_area_view_for_dash.addSubview(tile)
                self.mahjong_tiles_for_dash.append(tile)
                
                tile.start_countdown_for_dash(duration: self.calculate_tile_duration_for_dash())
            }
        }
    }
    
    private func spawn_tile_for_dash() {
        let tile = MahjongTileView()
        tile.delegate = self
        
        // Wait for layout to complete before positioning
        DispatchQueue.main.async {
            let game_area_bounds = self.game_area_view_for_dash.bounds
            
            // 确保游戏区域有足够的空间
            guard game_area_bounds.width > 0, game_area_bounds.height > 0 else {
                return
            }
            
            // 3x3网格布局计算 - 确保完全居中
            let total_width = self.tile_width_for_dash * 3
            let total_height = self.tile_height_for_dash * 3
            
            // 计算起始位置，确保网格在游戏区域中完全居中
            let start_x = (game_area_bounds.width - total_width) / 2
            let start_y = (game_area_bounds.height - total_height) / 2
            
            // 为每个麻将图片分配一个固定的网格位置
            let current_tile_index = self.mahjong_tiles_for_dash.count
            let grid_x = current_tile_index % 3
            let grid_y = current_tile_index / 3
            
            let tile = MahjongTileView(width: self.tile_width_for_dash, height: self.tile_height_for_dash)
            tile.delegate = self
            
            // 精确计算每个麻将图片的位置
            let x = start_x + CGFloat(grid_x) * self.tile_width_for_dash
            let y = start_y + CGFloat(grid_y) * self.tile_height_for_dash
            
            tile.frame = CGRect(x: x, y: y, width: self.tile_width_for_dash, height: self.tile_height_for_dash)
            
            self.game_area_view_for_dash.addSubview(tile)
            self.mahjong_tiles_for_dash.append(tile)
            
            tile.start_countdown_for_dash(duration: self.calculate_tile_duration_for_dash())
        }
    }
    
    private func start_tile_spawn_timer_for_dash() {
        // 先停止现有定时器，防止重复创建
        stop_tile_spawn_timer_for_dash()
        
        // 注释掉定时器，防止游戏进行时增加新的麻将图片
        // tile_spawn_timer_for_dash = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
        //     self?.spawn_tile_for_dash()
        // }
    }
    
    private func stop_tile_spawn_timer_for_dash() {
        tile_spawn_timer_for_dash?.invalidate()
        tile_spawn_timer_for_dash = nil
    }
    
    private func pause_all_tiles_for_dash() {
        for tile in mahjong_tiles_for_dash {
            tile.pause_countdown_for_dash()
        }
    }
    
    private func clear_all_tiles_for_dash() {
        // 先停止所有麻将牌的倒计时
        for tile in mahjong_tiles_for_dash {
            tile.stop_countdown_for_dash() // 需要添加这个方法
            tile.removeFromSuperview()
        }
        mahjong_tiles_for_dash.removeAll()
    }
    
    // 新增：完全停止当前游戏的所有状态
    private func stop_current_game_completely_for_dash() {
        // 1. 设置游戏为非活跃状态
        is_game_active_for_dash = false
        
        // 2. 停止所有定时器
        stop_tile_spawn_timer_for_dash()
        game_timer_for_dash?.invalidate()
        game_timer_for_dash = nil
        
        // 3. 清理所有麻将牌（包括它们的定时器）
        clear_all_tiles_for_dash()
        
        // 4. 重置UI状态
        start_button_for_dash.isHidden = false
        pause_button_for_dash.isHidden = true
        game_over_view_for_dash.isHidden = true
        
        // 5. 强制清理可能残留的视图
        game_area_view_for_dash.subviews.forEach { subview in
            if subview is MahjongTileView {
                (subview as? MahjongTileView)?.stop_countdown_for_dash()
                subview.removeFromSuperview()
            }
        }
    }
    
    private func update_ui_for_dash() {
        score_label_for_dash.text = "Score: \(score_for_dash)"
        lives_label_for_dash.text = "Lives: \(lives_for_dash) | Level: \(current_level_for_dash)"
        combo_label_for_dash.text = "Combo: \(combo_count_for_dash)"
        
        // 更新难度信息，显示当前等级的倒计时范围
        let difficulty_text = get_difficulty_text_for_dash()
        let (min_duration, max_duration) = get_current_duration_range_for_dash()
        difficulty_info_label_for_dash.text = "Difficulty: \(difficulty_text) | Countdown: \(String(format: "%.1f", min_duration))-\(String(format: "%.1f", max_duration))s"
    }
    
    private func game_over_for_dash() {
        // 使用完整的游戏停止方法，确保所有状态都被清理
        stop_current_game_completely_for_dash()
        
        // Update game over view
        if let score_label = game_over_view_for_dash.subviews.first(where: { $0 is UILabel && ($0 as? UILabel)?.text?.contains("Final Score") == true }) as? UILabel {
            score_label.text = "Final Score: \(score_for_dash)"
        }
        
        if let stats_label = game_over_view_for_dash.subviews.first(where: { $0 is UILabel && ($0 as? UILabel)?.text?.contains("Tiles Cleared") == true }) as? UILabel {
            stats_label.text = "Tiles Cleared: \(tiles_cleared_for_dash) | Best Combo: \(combo_count_for_dash)"
        }
        
        // 显示游戏结束界面
        game_over_view_for_dash.isHidden = false
        
        // Save score
        save_score_for_dash()
    }
    
    private func save_score_for_dash() {
        // Save score and update statistics
        Game_Stats_Manager.shared_for_dash.save_score_for_dash(score_for_dash)
        Game_Stats_Manager.shared_for_dash.update_game_stats_for_dash(
            score: score_for_dash,
            combo: combo_count_for_dash,
            tiles_cleared: tiles_cleared_for_dash
        )
    }
    
    private func calculate_tile_duration_for_dash() -> TimeInterval {
        // 基础倒计时时间范围
        let base_min_duration: TimeInterval = 4.0
        let base_max_duration: TimeInterval = 6.0
        
        // 每级减少0.5秒的范围
        let level_reduction = Double(current_level_for_dash - 1) * 0.5
        
        // 计算当前等级下的倒计时范围
        let current_min_duration = max(base_min_duration - level_reduction, 1.5) // 最少1.5秒
        let current_max_duration = max(base_max_duration - level_reduction, 2.5) // 最少2.5秒
        
        // 在范围内随机选择倒计时时间
        let random_duration = Double.random(in: current_min_duration...current_max_duration)
        
        return random_duration
    }
    
    private func get_difficulty_text_for_dash() -> String {
        switch current_level_for_dash {
        case 1:
            return "Normal"
        case 2:
            return "Easy"
        case 3:
            return "Medium"
        case 4:
            return "Hard"
        case 5:
            return "Expert"
        case 6:
            return "Master"
        case 7:
            return "Legend"
        case 8:
            return "God"
        default:
            return "Impossible"
        }
    }
    
    private func get_current_duration_range_for_dash() -> (TimeInterval, TimeInterval) {
        // 基础倒计时时间范围
        let base_min_duration: TimeInterval = 4.0
        let base_max_duration: TimeInterval = 6.0
        
        // 每级减少0.5秒的范围
        let level_reduction = Double(current_level_for_dash - 1) * 0.5
        
        // 计算当前等级下的倒计时范围
        let current_min_duration = max(base_min_duration - level_reduction, 1.5) // 最少1.5秒
        let current_max_duration = max(base_max_duration - level_reduction, 2.5) // 最少2.5秒
        
        return (current_min_duration, current_max_duration)
    }
}

// MARK: - MahjongTileViewDelegate for Dash
extension Main_Game_VC: MahjongTileViewDelegate {
    func tile_tapped_for_dash(_ tile: MahjongTileView) {
        guard is_game_active_for_dash else { return }
        
        // Success - remove tile and add score
        if let index = mahjong_tiles_for_dash.firstIndex(of: tile) {
            // 立即从数组中移除，避免重复处理
            mahjong_tiles_for_dash.remove(at: index)
            
            tiles_cleared_for_dash += 1
            
            // Calculate combo and score
            let current_time = CACurrentMediaTime()
            let time_since_last_tap = current_time - last_tap_time_for_dash
            
            if time_since_last_tap < 1.0 { // Within 1 second for combo
                combo_count_for_dash += 1
                let combo_bonus = min(combo_count_for_dash * 5, 50) // Max 50 bonus points
                score_for_dash += 10 + combo_bonus
            } else {
                combo_count_for_dash = 1
                score_for_dash += 10
            }
            
            last_tap_time_for_dash = current_time
            
            // Extend time for other tiles
            for remaining_tile in mahjong_tiles_for_dash {
                remaining_tile.extend_time_for_dash(by: 0.5)
            }
            
            // Check if level should increase
            if tiles_cleared_for_dash % 3 == 0 && tiles_cleared_for_dash > 0 {
                current_level_for_dash += 1
                // 移除Level UP提示动画，直接更新UI
                update_ui_for_dash()
            }
            
            update_ui_for_dash()
        }
    }
    
    func tile_exploded_for_dash(_ tile: MahjongTileView) {
        guard is_game_active_for_dash else { return }
        
        if game_mode_for_dash == .classic {
            // Classic mode - game over
            game_over_for_dash()
        } else {
            // Survival mode - lose a life
            lives_for_dash -= 1
            update_ui_for_dash()
            
            if lives_for_dash <= 0 {
                game_over_for_dash()
            }
        }
    }
}

// MARK: - Game Mode Enum for Dash
enum GameMode {
    case classic
    case survival
}
