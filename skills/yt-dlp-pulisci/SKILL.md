---
name: yt-dlp-pulisci
description: >-
  Cancella la cartella dei download yt-dlp (default ~/Desktop/yt-dlp). Da usare
  solo quando l'utente chiede esplicitamente di cancellare, pulire o rimuovere i
  file scaricati con yt-dlp-audio o yt-dlp-video. Non usarlo per i file
  temporanei di yt-dlp-inferenza: quelli li gestisce yt-dlp-inferenza stesso.
---

# Cancellare i download

Cancella `~/Desktop/yt-dlp`, la cartella dei video e degli audio chiesti
dall'utente. I file dell'inferenza stanno altrove e li rimuove
`yt-dlp-inferenza`.

## Requisiti

- `python3` installato e in `PATH` (serve per calcolare i path assoluti).

## Comando base

Esegui lo script. Non costruire un `rm` a mano.

```bash
~/.cursor/skills/yt-dlp-pulisci/scripts/pulisci.sh
```

Lo script rimuove `~/Desktop/yt-dlp`. Se la cartella non c'è, non è un errore.

## Specificare un altro path

Se l'utente ha indicato un altro path e chiede di cancellare quello, passalo
allo script. Lo script rifiuta la home, le cartelle di sistema, `Download`,
`Desktop` (la cartella intera), `Documenti` e ogni percorso che non contiene
`yt-dlp`, a meno che non sia esattamente il default.

```bash
~/.cursor/skills/yt-dlp-pulisci/scripts/pulisci.sh "$HOME/Desktop/yt-dlp"
```

## Dry run

Per vedere cosa verrebbe cancellato senza farlo:

```bash
~/.cursor/skills/yt-dlp-pulisci/scripts/pulisci.sh --dry-run
```

Lancialo solo se l'utente chiede di cancellare quei download. Conferma il path
cancellato, o il motivo del rifiuto.
