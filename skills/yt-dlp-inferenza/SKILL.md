---
name: yt-dlp-inferenza
description: >-
  Scarica solo metadati (.info.json) e sottotitoli (.vtt) di un video senza
  scaricare il media, in modo che l'agente possa leggere il contenuto parlato.
  Usa quando l'utente chiede di inferire, riassumere o estrarre informazioni da un
  video, oppure quando chiede sottotitoli o metadati senza il file video.
---

# Inferenza sul video

Esegui yt-dlp. Non descrivere il comando al posto di lanciarlo.

L'unica cartella che resta è `~/Desktop/yt-dlp`, con le sottocartelle dei canali
dei file da tenere. Ogni altra cartella creata da questa skill è temporanea:
`yt-dlp-inferenza` e, dentro, le cartelle `%(uploader)s` del template `-o`.
Vanno eliminate tutte a fine lettura, non solo i file.

`/tmp` non esiste su tutti i sistemi. Lo script `temp-dir.sh` sceglie, in ordine,
`TMPDIR`, `TEMP`, `TMP`, `/tmp`, e solo alla fine `~/.cache`. Dentro ci crea
`yt-dlp-inferenza`.

## Requisiti

- `yt-dlp` installato e in `PATH`.
- `python3` installato e in `PATH`.

## Comando

Sostituisci `URL`. Il flag della lingua è `--sub-langs`.

```bash
DIR="$(~/.cursor/skills/yt-dlp-inferenza/scripts/temp-dir.sh)"
yt-dlp --skip-download \
  --write-info-json \
  --write-subs --write-auto-subs \
  --sub-langs "it" \
  --sub-format vtt \
  -P "$DIR" \
  -o "%(uploader)s/%(title)s [%(id)s].%(ext)s" \
  "URL"
```

## Adattare la richiesta

Se l'utente indica altre opzioni di yt-dlp (lingua, playlist, `-I`, formato
sottotitoli, path), aggiungile o sostituisci il default corrispondente. Un path
esplicito sostituisce `-P`. Non togliere `--skip-download`. Per il file video
usa `yt-dlp-video`, per il solo audio `yt-dlp-audio`.

Se l'utente indica un path suo, i file vanno lì e quella cartella non si
cancella da sola: è una destinazione che ha scelto lui. Di' dove sono i file.

## Leggere e cancellare

Cerca in `$DIR` i file di quell'id: `*.vtt` e `*.info.json`. Leggili prima di
cancellare.

Il testo parlato è nel VTT. Se non c'è nessun `.vtt`, dillo e fermati. Titolo e
descrizione nel JSON non sono il contenuto del video: non riassumere il video a
partire da quelli.

Subito dopo aver letto, e prima di chiudere il compito, cancella l'intera
cartella temporanea, sottocartelle incluse. Non deve restare né la cartella né
le cartelle dei canali:

```bash
~/.cursor/skills/yt-dlp-inferenza/scripts/rm-inferenza.sh
```

Non usare `yt-dlp-pulisci` per questi file.
