# Cursor Skills — Archivio personale

Piccola raccolta di [Cursor Agent Skills](https://www.cursor.com/) per automatizzare
compiti ricorrenti da riga di comando. Tutte le skill sono pensate per essere
invocate dall’agente di Cursor tramite i relativi comandi slash (`/skill`).

## Indice

- [Requisiti](#requisiti)
- [Installazione](#installazione)
- [Skill disponibili](#skill-disponibili)
  - [`yt-dlp-audio`](#yt-dlp-audio)
  - [`yt-dlp-video`](#yt-dlp-video)
  - [`yt-dlp-inferenza`](#yt-dlp-inferenza)
  - [`yt-dlp-pulisci`](#yt-dlp-pulisci)
- [Aggiornare le skill](#aggiornare-le-skill)
- [Disinstallare](#disinstallare)
- [Disclaimer](#disclaimer)
- [Licenza](#licenza)

## Requisiti

- **Cursor** con i Cursor Agent Skills abilitati.
- **macOS, Linux o WSL/Git Bash su Windows**. Gli script sono in `bash`.
- **`yt-dlp`** installato e presente in `PATH`.
- **`ffmpeg`** richiesto da `yt-dlp-audio` e `yt-dlp-video`.
- **`python3`** richiesto da `yt-dlp-inferenza` e `yt-dlp-pulisci`.

Installare le dipendenze su macOS con Homebrew:

```bash
brew install yt-dlp ffmpeg python3
```

## Installazione

### 1. Clona la repo

```bash
git clone <URL-REPO-GITHUB> ~/cursor-skills
cd ~/cursor-skills
```

### 2. Installa le skill

```bash
./install.sh
```

Lo script copia ogni cartella dentro `skills/` in `~/.cursor/skills/`, che è la
cartella standard usata da Cursor per gli Agent Skills.

Se vuoi installarle in una cartella diversa:

```bash
SKILL_DIR="$HOME/.agents/skills" ./install.sh
```

### 3. Verifica

In Cursor dovresti poter usare i comandi:

```
/yt-dlp-audio URL
/yt-dlp-video URL
/yt-dlp-inferenza URL
/yt-dlp-pulisci
```

## Skill disponibili

### `yt-dlp-audio`

Scarica **solo l’audio** di un video YouTube (o di un’altra piattaforma supportata
da yt-dlp) in `~/Desktop/yt-dlp/audio/<canale>/`. Usala solo quando l’utente
chiede esplicitamente di scaricare l’audio.

#### Uso base

```bash
/yt-dlp-audio https://www.youtube.com/watch?v=...
```

#### Parametri dello script

Lo script sottostante accetta fino a 4 argomenti:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh <URL> [formato] [outdir] [qualita]
```

| Argomento | Default | Significato |
|-----------|---------|-------------|
| `URL` | — | link al video o playlist |
| `formato` | `best` | formato audio finale (`mp3`, `m4a`, `flac`, …) |
| `outdir` | `~/Desktop/yt-dlp/audio` | cartella di destinazione |
| `qualita` | `ba/b` | formato yt-dlp (`ba/b` = migliore, `wa/w` = minima) |

#### Esempi

Miglior audio, formato originale:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "https://www.youtube.com/watch?v=..."
```

Audio in MP3:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "URL" mp3
```

Qualità minima:

```bash
~/.cursor/skills/yt-dlp-audio/scripts/download.sh "URL" best ~/Desktop/yt-dlp/audio wa/w
```

### `yt-dlp-video`

Scarica il **video completo** (video + audio) in
`~/Desktop/yt-dlp/video/<canale>/`. Usala solo quando l’utente chiede
esplicitamente di scaricare il video.

#### Uso base

```bash
/yt-dlp-video https://www.youtube.com/watch?v=...
```

#### Parametri dello script

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh <URL> [altezza] [outdir]
```

| Argomento | Default | Significato |
|-----------|---------|-------------|
| `URL` | — | link al video o playlist |
| `altezza` | `best` | limite di altezza (`1080`, `720`, …) |
| `outdir` | `~/Desktop/yt-dlp/video` | cartella di destinazione |

#### Esempi

Miglior qualità disponibile:

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh "https://www.youtube.com/watch?v=..."
```

720p:

```bash
~/.cursor/skills/yt-dlp-video/scripts/download.sh "URL" 720
```

### `yt-dlp-inferenza`

Scarica solo **metadati e sottotitoli** di un video in una cartella temporanea,
permettendo all’agente di leggerne il contenuto senza scaricare il file video.
Dopo la lettura la cartella temporanea viene eliminata automaticamente.

#### Uso base

```bash
/yt-dlp-inferenza https://www.youtube.com/watch?v=...
```

#### Funzionamento

1. Crea una cartella temporanea in `TMPDIR`/`TEMP`/`TMP`/`/tmp` o in
   `~/.cache/yt-dlp-inferenza`.
2. Esegue `yt-dlp --skip-download` con sottotitoli italiani in formato VTT.
3. L’agente legge i file `.vtt` e `.info.json`.
4. Cancella l’intera cartella temporanea.

#### Personalizzare

Per altre lingue cambia `--sub-langs` dentro `SKILL.md` o passa direttamente le
opzioni a `yt-dlp` nel comando dell’agente.

### `yt-dlp-pulisci`

Cancella la cartella `~/Desktop/yt-dlp` e i suoi contenuti. Usala solo quando
l’utente chiede esplicitamente di eliminare i download.

#### Uso base

```bash
/yt-dlp-pulisci
```

#### Specificare un’altra cartella

```bash
/yt-dlp-pulisci ~/Desktop/yt-dlp
```

o direttamente:

```bash
~/.cursor/skills/yt-dlp-pulisci/scripts/pulisci.sh ~/Desktop/yt-dlp
```

#### Sicurezza

Lo script rifiuta di cancellare:
- la home (`~`);
- cartelle di sistema (`/`, `/Users`, `~/Library`, ecc.);
- `~/Downloads`, `~/Desktop` (la cartella intera, non la sottocartella `yt-dlp`),
  `~/Documents`, `~/Movies`, `~/Music`, `~/Pictures`;
- qualsiasi path che non contenga `yt-dlp` nel nome, a meno che non sia
  esattamente il default `~/Desktop/yt-dlp`.

## Aggiornare le skill

Dopo aver pullato gli aggiornamenti della repo, riesegui:

```bash
cd ~/cursor-skills
./install.sh
```

Lo script sovrascrive le skill esistenti in `~/.cursor/skills/`.

## Disinstallare

Per rimuovere tutte le skill installate:

```bash
rm -rf ~/.cursor/skills/yt-dlp-audio \
       ~/.cursor/skills/yt-dlp-video \
       ~/.cursor/skills/yt-dlp-inferenza \
       ~/.cursor/skills/yt-dlp-pulisci
```

## Disclaimer

Questi script sono strumenti di automazione personale. Scaricare contenuti da
YouTube o da altre piattaforme può violare i **Termini di Servizio** dei siti e
la normativa sul **copyright** del proprio paese. L’autore non si assume alcuna
responsabilità per l’uso che fai di questi strumenti. Usali solo per contenuti di
cui hai il diritto di scaricare una copia.

## Licenza

Distribuito sotto licenza MIT. Vedi il file [`LICENSE`](./LICENSE).
