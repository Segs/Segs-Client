import QtQuick
import QtMultimedia

Item {
property alias startup_audio: startup_audio
property alias launch_audio: launch_audio

MediaPlayer {
    id: startup_audio
    source: "qrc:/Resources/Audio/startup.wav"
    audioOutput: AudioOutput { volume: 0.5 }
}

MediaPlayer {
    id: launch_audio
    source: "qrc:/Resources/Audio/launch.wav"
    audioOutput: AudioOutput { volume: 0.5 }
}
}
