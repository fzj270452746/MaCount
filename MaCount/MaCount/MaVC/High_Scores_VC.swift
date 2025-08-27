import UIKit

class High_Scores_VC: UIViewController {
    
    // MARK: - Properties for Dash
    private var background_image_view_for_dash: UIImageView!
    private var overlay_view_for_dash: UIView!
    private var title_label_for_dash: UILabel!
    private var scores_table_view_for_dash: UITableView!
    private var back_button_for_dash: UIButton!
    private var clear_scores_button_for_dash: UIButton!
    
    private var high_scores_for_dash: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_ui_for_dash()
        setup_constraints_for_dash()
        load_high_scores_for_dash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load_high_scores_for_dash()
        scores_table_view_for_dash.reloadData()
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
        title_label_for_dash.text = "High Scores"
        title_label_for_dash.textColor = .white
        title_label_for_dash.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        title_label_for_dash.textAlignment = .center
        title_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(title_label_for_dash)
        
        // Scores Table View
        scores_table_view_for_dash = UITableView()
        scores_table_view_for_dash.backgroundColor = UIColor.clear
        scores_table_view_for_dash.separatorStyle = .none
        scores_table_view_for_dash.delegate = self
        scores_table_view_for_dash.dataSource = self
        scores_table_view_for_dash.register(Score_Cell.self, forCellReuseIdentifier: "ScoreCell")
        scores_table_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(scores_table_view_for_dash)
        
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
        
        // Clear Scores Button
        clear_scores_button_for_dash = UIButton(type: .system)
        clear_scores_button_for_dash.setTitle("Clear Scores", for: .normal)
        clear_scores_button_for_dash.setTitleColor(.white, for: .normal)
        clear_scores_button_for_dash.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        clear_scores_button_for_dash.backgroundColor = UIColor.systemOrange
        clear_scores_button_for_dash.layer.cornerRadius = 20
        clear_scores_button_for_dash.addTarget(self, action: #selector(clear_scores_tapped_for_dash), for: .touchUpInside)
        clear_scores_button_for_dash.translatesAutoresizingMaskIntoConstraints = false
        overlay_view_for_dash.addSubview(clear_scores_button_for_dash)
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
            
            // Scores Table View
            scores_table_view_for_dash.topAnchor.constraint(equalTo: title_label_for_dash.bottomAnchor, constant: 20),
            scores_table_view_for_dash.leadingAnchor.constraint(equalTo: overlay_view_for_dash.leadingAnchor, constant: 20),
            scores_table_view_for_dash.trailingAnchor.constraint(equalTo: overlay_view_for_dash.trailingAnchor, constant: -20),
            scores_table_view_for_dash.bottomAnchor.constraint(equalTo: clear_scores_button_for_dash.topAnchor, constant: -20),
            
            // Clear Scores Button
            clear_scores_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            clear_scores_button_for_dash.bottomAnchor.constraint(equalTo: back_button_for_dash.topAnchor, constant: -20),
            clear_scores_button_for_dash.widthAnchor.constraint(equalToConstant: 150),
            clear_scores_button_for_dash.heightAnchor.constraint(equalToConstant: 45),
            
            // Back Button
            back_button_for_dash.centerXAnchor.constraint(equalTo: overlay_view_for_dash.centerXAnchor),
            back_button_for_dash.bottomAnchor.constraint(equalTo: overlay_view_for_dash.bottomAnchor, constant: -20),
            back_button_for_dash.widthAnchor.constraint(equalToConstant: 120),
            back_button_for_dash.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func load_high_scores_for_dash() {
        high_scores_for_dash = Game_Stats_Manager.shared_for_dash.get_high_scores_for_dash()
    }
    
    // MARK: - Actions for Dash
    @objc private func back_button_tapped_for_dash() {
        dismiss(animated: true)
    }
    
    @objc private func clear_scores_tapped_for_dash() {
        let alert = UIAlertController(title: "Clear High Scores", message: "Are you sure you want to clear all high scores? This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.clear_all_scores_for_dash()
        })
        
        present(alert, animated: true)
    }
    
    private func clear_all_scores_for_dash() {
        Game_Stats_Manager.shared_for_dash.clear_high_scores_for_dash()
        high_scores_for_dash.removeAll()
        scores_table_view_for_dash.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for Dash
extension High_Scores_VC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(high_scores_for_dash.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! Score_Cell
        
        if high_scores_for_dash.isEmpty {
            cell.configure_for_dash(rank: 0, score: 0, is_empty: true)
        } else {
            let score = high_scores_for_dash[indexPath.row]
            cell.configure_for_dash(rank: indexPath.row + 1, score: score, is_empty: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Score Cell for Dash
class Score_Cell: UITableViewCell {
    
    private var rank_label_for_dash: UILabel!
    private var score_label_for_dash: UILabel!
    private var medal_image_view_for_dash: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup_cell_for_dash()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup_cell_for_dash()
    }
    
    private func setup_cell_for_dash() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Rank Label
        rank_label_for_dash = UILabel()
        rank_label_for_dash.textColor = .white
        rank_label_for_dash.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        rank_label_for_dash.textAlignment = .center
        rank_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rank_label_for_dash)
        
        // Medal Image View
        medal_image_view_for_dash = UIImageView()
        medal_image_view_for_dash.contentMode = .scaleAspectFit
        medal_image_view_for_dash.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(medal_image_view_for_dash)
        
        // Score Label
        score_label_for_dash = UILabel()
        score_label_for_dash.textColor = .white
        score_label_for_dash.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        score_label_for_dash.textAlignment = .right
        score_label_for_dash.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(score_label_for_dash)
        
        NSLayoutConstraint.activate([
            rank_label_for_dash.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rank_label_for_dash.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rank_label_for_dash.widthAnchor.constraint(equalToConstant: 50),
            
            medal_image_view_for_dash.leadingAnchor.constraint(equalTo: rank_label_for_dash.trailingAnchor, constant: 20),
            medal_image_view_for_dash.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            medal_image_view_for_dash.widthAnchor.constraint(equalToConstant: 30),
            medal_image_view_for_dash.heightAnchor.constraint(equalToConstant: 30),
            
            score_label_for_dash.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            score_label_for_dash.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            score_label_for_dash.leadingAnchor.constraint(equalTo: medal_image_view_for_dash.trailingAnchor, constant: 20)
        ])
    }
    
    func configure_for_dash(rank: Int, score: Int, is_empty: Bool) {
        if is_empty {
            rank_label_for_dash.text = "-"
            score_label_for_dash.text = "No scores yet"
            medal_image_view_for_dash.image = nil
            rank_label_for_dash.textColor = .systemGray
            score_label_for_dash.textColor = .systemGray
        } else {
            rank_label_for_dash.text = "#\(rank)"
            score_label_for_dash.text = "\(score)"
            rank_label_for_dash.textColor = .white
            score_label_for_dash.textColor = .white
            
            // Set medal image based on rank
            switch rank {
            case 1:
                medal_image_view_for_dash.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            case 2:
                medal_image_view_for_dash.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case 3:
                medal_image_view_for_dash.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemBrown, renderingMode: .alwaysOriginal)
            default:
                medal_image_view_for_dash.image = UIImage(systemName: "medal")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            }
        }
    }
}
