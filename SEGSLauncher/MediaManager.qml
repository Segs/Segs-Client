import QtQuick 2.1
import QtMultimedia 5.15

Item {
property alias startup_audio: startup_audio
property alias launch_audio: launch_audio

Audio {
    id: startup_audio
    source: "qrc:Resources/Audio/startup.wav"
    audioRole: Audio.SonificationRole
    volume: 0.5
}

Audio {
    id: launch_audio
    source: "qrc:Resources/Audio/launch.wav"
    audioRole: Audio.SonificationRole
    volume: 0.5
}
}
