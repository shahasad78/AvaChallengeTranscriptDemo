//
// Created by Richard Martinez on 8/8/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

var appHasMicStatus = false

enum AudioStatus: Int {
    case stopped
    case playing
    case recording

    func audioName() -> String {
        let audioNames = [
            "Audio: Stopped",
            "Audio: Playing",
            "Audio: Recording"
        ]
        return audioNames[self.rawValue]
    }

    var description: String {
       return audioName()
    }
}