---
name: yt-dlp-audio
description: >-
  Scarica solo l'audio di un video con yt-dlp. Da usare solo quando l'utente
  chiede esplicitamente di scaricare o salvare l'audio (scarica l'audio,
  solo audio, mp3, estrai audio). Non usarlo per leggere il contenuto di un
  video: per quello c'è yt-dlp-inferenza.
---

# Scaricare audio

Usa questa skill solo se l'utente ha chiesto esplicitamente il file audio.

I file persistenti vanno in `~/Desktop/yt-dlp/audio/<canale>/`. Quella è la
cartella di destinazione predefinita. Se l'utente indica un altro path, usa
quello e non cancellarlo. Non creare altre cartelle e non usare la cartella
temporanea dell'inferenza.

## Requisiti

- `yt-dlp` installato e in `PATH`.
- `ffmpeg` installato e in `PATH`.

## Comando base

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "URL"
```

## Parametri

Il script accetta fino a 4 argomenti:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh <URL> [formato] [outdir] [qualita]
```

| Argomento | Default | Significato |
|-----------|---------|-------------|
| `URL` | — | link al video o playlist |
| `formato` | `best` | formato audio finale (`mp3`, `m4a`, `flac`, `opus`, …) |
| `outdir` | `~/Desktop/yt-dlp` | cartella di destinazione |
| `qualita` | `ba/b` | formato yt-dlp (`ba/b` = migliore, `wa/w` = minima) |

## Esempi

Miglior audio, formato originale:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "https://www.youtube.com/watch?v=..."
```

Solo audio in MP3:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "URL" mp3
```

Qualità minima:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "URL" best ~/Desktop/yt-dlp wa/w
```

## Adattare la richiesta

Se l'utente chiede un formato (`mp3`, `m4a`, `flac`), una qualità, playlist,
`-I`, cookie o un path, sostituisci il default corrispondente passando gli
argomenti allo script, oppure modifica direttamente il comando. Un path esplicito
sostituisce `outdir`. Non scaricare il video insieme all'audio.

Al termine indica il path del file scaricato. Non cancellare la cartella:
lo fa `yt-dlp-pulisci` quando l'utente lo chiede.
