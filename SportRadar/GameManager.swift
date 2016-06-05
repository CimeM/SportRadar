//
//  GameManager.swift
//  SportRadar
//
//  Created by Martin Cimerman on 05/06/16.
//  Copyright © 2016 Martin Cimerman. All rights reserved.
//

import Foundation

struct GameManager {
    
     var scoreTeam1 = 0
     var scoreTeam2 = 0

    mutating func setScore(team1Score: Int, team2Score: Int)  {
        self.scoreTeam1 = team1Score
        self.scoreTeam2 = team2Score
    }
    
    
}