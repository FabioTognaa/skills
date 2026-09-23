---
name: yt-dlp-video
description: >-
  Scarica un video con yt-dlp alla miglior qualità disponibile. Da usare solo
  quando l'utente chiede esplicitamente di scaricare o salvare un video
  (scarica il video, download video). Non usarlo per leggere il contenuto di un
  video: per quello c'è yt-dlp-inferenza.
---

# Scaricare video

Usa questa skill solo se l'utente ha chiesto esplicitamente il file video.

I file persistenti vanno in `~/Desktop/yt-dlp`, anche nelle sottocartelle per
canale create dal template `-o`. Quella è l'unica cartella di destinazione
predefinita. Se l'utente indica un altro path, usa quello e non cancellarlo.
Non creare altre cartelle e non usare la cartella temporanea dell'inferenza.

## Requisiti

- `yt-dlp` installato e in `PATH`.
- `ffmpeg` installato e in `PATH`.

## Comando base

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh "URL"
```

## Parametri

Il script accetta fino a 3 argomenti:

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh <URL> [altezza] [outdir]
```

| Argomento | Default | Significato |
|-----------|---------|-------------|
| `URL` | — | link al video o playlist |
| `altezza` | `best` | limite di altezza (`1080`, `720`, `480`, …) |
| `outdir` | `~/Desktop/yt-dlp` | cartella di destinazione |

## Esempi

Miglior qualità disponibile:

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh "https://www.youtube.com/watch?v=..."
```

720p:

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh "URL" 720
```

## Adattare la richiesta

Se l'utente indica formato, altezza, container, sottotitoli, playlist, `-I`,
velocità, cookie o un path, applica quelle opzioni al posto del default
corrispondente. Un path esplicito sostituisce `outdir`. Non aggiungere `-x`:
l'audio solo è compito di `yt-dlp-audio`.

Al termine indica il path del file scaricato. Non cancellare la cartella:
lo fa `yt-dlp-pulisci` quando l'utente lo chiede.
