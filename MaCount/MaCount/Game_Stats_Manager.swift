import Foundation

class Game_Stats_Manager {
    
    // MARK: - Singleton for Dash
    static let shared_for_dash = Game_Stats_Manager()
    
    private init() {}
    
    // MARK: - UserDefaults Keys for Dash
    private let high_scores_key_for_dash = "HighScores"
    private let total_games_key_for_dash = "TotalGames"
    private let total_score_key_for_dash = "TotalScore"
    private let best_combo_key_for_dash = "BestCombo"
    private let total_tiles_cleared_key_for_dash = "TotalTilesCleared"
    private let game_mode_preference_key_for_dash = "GameModePreference"
    private let difficulty_preference_key_for_dash = "DifficultyPreference"
    
    // MARK: - High Scores Methods for Dash
    func save_score_for_dash(_ score: Int) {
        var scores = get_high_scores_for_dash()
        scores.append(score)
        scores.sort(by: >)
        scores = Array(scores.prefix(10)) // Keep top 10
        
        UserDefaults.standard.set(scores, forKey: high_scores_key_for_dash)
    }
    
    func get_high_scores_for_dash() -> [Int] {
        return UserDefaults.standard.array(forKey: high_scores_key_for_dash) as? [Int] ?? []
    }
    
    func clear_high_scores_for_dash() {
        UserDefaults.standard.removeObject(forKey: high_scores_key_for_dash)
    }
    
    // MARK: - Game Statistics Methods for Dash
    func update_game_stats_for_dash(score: Int, combo: Int, tiles_cleared: Int) {
        let total_games = get_total_games_for_dash() + 1
        let total_score = get_total_score_for_dash() + score
        let best_combo = max(get_best_combo_for_dash(), combo)
        let total_tiles = get_total_tiles_cleared_for_dash() + tiles_cleared
        
        UserDefaults.standard.set(total_games, forKey: total_games_key_for_dash)
        UserDefaults.standard.set(total_score, forKey: total_score_key_for_dash)
        UserDefaults.standard.set(best_combo, forKey: best_combo_key_for_dash)
        UserDefaults.standard.set(total_tiles, forKey: total_tiles_cleared_key_for_dash)
    }
    
    func get_total_games_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: total_games_key_for_dash)
    }
    
    func get_total_score_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: total_score_key_for_dash)
    }
    
    func get_best_combo_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: best_combo_key_for_dash)
    }
    
    func get_total_tiles_cleared_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: total_tiles_cleared_key_for_dash)
    }
    
    func get_average_score_for_dash() -> Double {
        let total_games = get_total_games_for_dash()
        let total_score = get_total_score_for_dash()
        
        if total_games > 0 {
            return Double(total_score) / Double(total_games)
        }
        return 0.0
    }
    
    // MARK: - Preferences Methods for Dash
    func save_game_mode_for_dash(_ mode: Int) {
        UserDefaults.standard.set(mode, forKey: game_mode_preference_key_for_dash)
    }
    
    func get_game_mode_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: game_mode_preference_key_for_dash)
    }
    
    func save_difficulty_for_dash(_ difficulty: Int) {
        UserDefaults.standard.set(difficulty, forKey: difficulty_preference_key_for_dash)
    }
    
    func get_difficulty_for_dash() -> Int {
        return UserDefaults.standard.integer(forKey: difficulty_preference_key_for_dash)
    }
    
    // MARK: - Statistics Summary for Dash
    func get_stats_summary_for_dash() -> [String: Any] {
        return [
            "Total Games": get_total_games_for_dash(),
            "Total Score": get_total_score_for_dash(),
            "Average Score": String(format: "%.1f", get_average_score_for_dash()),
            "Best Combo": get_best_combo_for_dash(),
            "Total Tiles Cleared": get_total_tiles_cleared_for_dash(),
            "High Score": get_high_scores_for_dash().first ?? 0
        ]
    }
    
    // MARK: - Reset Methods for Dash
    func reset_all_stats_for_dash() {
        UserDefaults.standard.removeObject(forKey: total_games_key_for_dash)
        UserDefaults.standard.removeObject(forKey: total_score_key_for_dash)
        UserDefaults.standard.removeObject(forKey: best_combo_key_for_dash)
        UserDefaults.standard.removeObject(forKey: total_tiles_cleared_key_for_dash)
    }
    
    func reset_all_data_for_dash() {
        reset_all_stats_for_dash()
        clear_high_scores_for_dash()
        UserDefaults.standard.removeObject(forKey: game_mode_preference_key_for_dash)
        UserDefaults.standard.removeObject(forKey: difficulty_preference_key_for_dash)
    }
}
