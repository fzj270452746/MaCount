import UIKit

class Settings_VC: UIViewController {
    
    // MARK: - Properties for Dash
    private var background_image_view_for_dash: UIImageView!
    private var overlay_view_for_dash: UIView!
    private var title_label_for_dash: UILabel!
    private var game_mode_label_for_dash: UILabel!
    private var game_mode_segment_for_dash: UISegmentedControl!
    private var difficulty_segment_for_dash: UISegmentedControl!
    private var difficulty_label_for_dash: UILabel!
    private var back_button_for_dash: UIButton!
    private var help_button_for_dash: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ui_for_dash()
        setup_constraints_for_dash()
        load_settings_for_dash()
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
        title_label_for_dash.text = "Settings"
        title_label_for_dash.textColor = .white
        title_label_for_dash.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        title_label_for_dash.textAlignment = .center
        title_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(title_label_for_dash)
        
        // Game Mode Selection
        game_mode_label_for_dash = UILabel()
        game_mode_label_for_dash.text = "Game Mode:"
        game_mode_label_for_dash.textColor = .white
        game_mode_label_for_dash.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        game_mode_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(game_mode_label_for_dash)
        
        game_mode_segment_for_dash = UISegmentedControl(items: ["Classic", "Survival"])
        game_mode_segment_for_dash.selectedSegmentIndex = 0
        game_mode_segment_for_dash.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        game_mode_segment_for_dash.selectedSegmentTintColor = .systemBlue
        game_mode_segment_for_dash.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        game_mode_segment_for_dash.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        game_mode_segment_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(game_mode_segment_for_dash)
        
        // Difficulty Selection
        difficulty_label_for_dash = UILabel()
        difficulty_label_for_dash.text = "Difficulty:"
        difficulty_label_for_dash.textColor = .white
        difficulty_label_for_dash.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        difficulty_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(difficulty_label_for_dash)
        
        difficulty_segment_for_dash = UISegmentedControl(items: ["Easy", "Normal", "Hard"])
        difficulty_segment_for_dash.selectedSegmentIndex = 1
        difficulty_segment_for_dash.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        difficulty_segment_for_dash.selectedSegmentTintColor = .systemBlue
        difficulty_segment_for_dash.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        difficulty_segment_for_dash.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        difficulty_segment_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(difficulty_segment_for_dash)
        
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
        
        // Help Button
        help_button_for_dash = UIButton(type: .system)
        help_button_for_dash.setTitle("How to Play", for: .normal)
        help_button_for_dash.setTitleColor(.white, for: .normal)
        help_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        help_button_for_dash.backgroundColor = UIColor.systemBlue
        help_button_for_dash.layer.cornerRadius = 20
        help_button_for_dash.addTarget(self, action: #selector(help_button_tapped_for_dash), for: .touchUpInside)
        help_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(help_button_for_dash)
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
            title_label_for_dash.topAnchor.constraint(equalTo: overlay_view_for_dash.topAnchor, constant: 30),
            title_label_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            
            // Game Mode
            game_mode_label_for_dash.topAnchor.constraint(equalTo: title_label_for_dash.bottomAnchor, constant: 40),
            game_mode_label_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 30),
            
            game_mode_segment_for_dash.centerYAnchor.constraint(equalTo: game_mode_label_for_dash.centerYAnchor),
            game_mode_segment_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -30),
            game_mode_segment_for_dash.widthAnchor.constraint(equalToConstant: 200),
            
            // Difficulty
            difficulty_label_for_dash.topAnchor.constraint(equalTo: game_mode_label_for_dash.bottomAnchor, constant: 30),
            difficulty_label_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 30),
            
            difficulty_segment_for_dash.centerYAnchor.constraint(equalTo: difficulty_label_for_dash.centerYAnchor),
            difficulty_segment_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -30),
            difficulty_segment_for_dash.widthAnchor.constraint(equalToConstant: 200),
            
            // Help Button
            help_button_for_dash.topAnchor.constraint(equalTo: difficulty_label_for_dash.bottomAnchor, constant: 40),
            help_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            help_button_for_dash.widthAnchor.constraint(equalToConstant: 150),
            help_button_for_dash.heightAnchor.constraint(equalToConstant: 45),
            
            // Back Button
            back_button_for_dash.topAnchor.constraint(equalTo: help_button_for_dash.bottomAnchor, constant: 20),
            back_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            back_button_for_dash.widthAnchor.constraint(equalToConstant: 120),
            back_button_for_dash.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func load_settings_for_dash() {
        // Load saved settings from Game Stats Manager
        let game_mode = Game_Stats_Manager.shared_for_dash.get_game_mode_for_dash()
        let difficulty = Game_Stats_Manager.shared_for_dash.get_difficulty_for_dash()
        
        game_mode_segment_for_dash.selectedSegmentIndex = game_mode
        difficulty_segment_for_dash.selectedSegmentIndex = difficulty
    }
    
    private func save_settings_for_dash() {
        // Save settings to Game Stats Manager and UserDefaults
        Game_Stats_Manager.shared_for_dash.save_game_mode_for_dash(game_mode_segment_for_dash.selectedSegmentIndex)
        Game_Stats_Manager.shared_for_dash.save_difficulty_for_dash(difficulty_segment_for_dash.selectedSegmentIndex)
    }
    
    // MARK: - Actions for Dash
    @objc private func back_button_tapped_for_dash() {
        save_settings_for_dash()
        dismiss(animated: true)
    }
    
    @objc private func help_button_tapped_for_dash() {
        // 直接在设置页面显示游戏说明弹窗
        let alert = UIAlertController(title: "Mahjong Countdown - How to Play", message: nil, preferredStyle: .alert)
        
        // 设置消息内容
        let message = """
        
        🎮 GAME OVERVIEW
        Mahjong Countdown is a fast-paced reaction game featuring traditional mahjong tiles. You must tap tiles before their countdown timers expire.
        
        🎯 HOW TO PLAY
        1. Mahjong tiles appear in a 3x3 grid
        2. Each tile has a different random countdown (4-6 seconds initially)
        3. Tap tiles before their timers reach zero to clear them
        4. Successfully cleared tiles award points and increase your combo
        5. Game difficulty increases with each level
        6. Clear 3 tiles to advance to the next level
        
        🎲 GAME MODES
        • Classic Mode: One mistake ends the game
        • Survival Mode: You have 3 lives
        
        📊 SCORING & PROGRESSION
        • Each successful tile clear: 10 points
        • Combo multiplier: Chain multiple clears for bonus points
        • Level progression: Clear 3 tiles to advance
        • Difficulty scaling: Countdown times decrease by 0.5s per level
        
        🎯 PRO TIPS
        • Focus on tiles with shortest time remaining
        • Use peripheral vision to monitor all tiles
        • Stay calm and focused
        • Practice regularly to improve reaction time
        """
        
        alert.message = message
        
        // 添加按钮
        alert.addAction(UIAlertAction(title: "Got it!", style: .default))
        
        // 显示弹窗
        present(alert, animated: true)
    }
}
