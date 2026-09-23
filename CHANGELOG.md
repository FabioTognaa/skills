# Changelog

Tutte le modifiche importanti a questo progetto saranno documentate in questo file.

Il formato è basato su [Keep a Changelog](https://keepachangelog.com/it/1.1.0/),
e questo progetto aderisce a [Semantic Versioning](https://semver.org/lang/it/).

## [Unreleased]

### Changed
- `yt-dlp-audio` e `yt-dlp-video`: destinazioni predefinite separate in
  `~/Desktop/yt-dlp/audio/` e `~/Desktop/yt-dlp/video/` per evitare che
  download multipli dello stesso video si sovrascrivano.

## [0.1.0] - 2026-09-23

### Added
- Skill iniziali: `yt-dlp-audio`, `yt-dlp-video`, `yt-dlp-inferenza`, `yt-dlp-pulisci`.
- Script helper con controlli minimi sulle dipendenze (`yt-dlp`, `ffmpeg`, `python3`).
- Validazione path in `yt-dlp-pulisci` per evitare cancellazioni pericolose.
- Cartella di destinazione predefinita coerente: `~/Desktop/yt-dlp`.
- `README.md` con installazione e tutorial per ogni comando.
- Licenza MIT.
