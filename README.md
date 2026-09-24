# Skill yt-dlp

Raccolta personale di [Agent Skills](https://agentskills.io/) per scaricare audio
e video con yt-dlp, leggere i sottotitoli di un URL e cancellare i download.
Le skill stanno nel checkout: gli agenti le vedono tramite symlink.

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

- **Un agente che legge le Agent Skills**: Claude Code (`~/.claude/skills`),
  Cursor, Codex e OpenCode (`~/.agents/skills`). OpenCode legge entrambe le
  cartelle, quindi può elencare ogni skill due volte.
- **macOS, Linux o WSL/Git Bash su Windows**. Gli script sono in `bash`.
  I symlink dell’installer funzionano su macOS, Linux e WSL.
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
git clone <URL-REPO-GITHUB> ~/yt-dlp-skills
cd ~/yt-dlp-skills
```

### 2. Collega le skill

```bash
./scripts/link-skills.sh
```

Lo script crea un symlink per ogni skill in `~/.claude/skills` e in
`~/.agents/skills`, puntando a questo checkout. Un `git pull` aggiorna i file
già collegati. Rilancia lo script quando aggiungi una skill, o per togliere
le copie vecchie in `~/.cursor/skills`.

Se in una destinazione esiste già una cartella vera con lo stesso nome, lo
script la sostituisce con il symlink. Le skill di altre repo, in quelle
cartelle, restano. I symlink di skill rimosse da questo repo restano anche
loro: cancellali a mano.

Lo script rimuove poi, solo in `~/.cursor/skills`, queste quattro voci
(`yt-dlp-audio`, `yt-dlp-video`, `yt-dlp-inferenza`, `yt-dlp-pulisci`), che
erano copie del vecchio installer. Il resto di `~/.cursor/skills` non si tocca.
I link vengono creati prima: se un collegamento fallisce, quelle copie restano.

### 3. Verifica

Nell’agente dovresti poter usare i comandi:

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

I comandi degli script sono relativi alla cartella della skill (`SKILL.md`).
L’agente li esegue con il path assoluto di quello script.

Lo script sottostante accetta fino a 4 argomenti:

```bash
scripts/download.sh <URL> [formato] [outdir] [qualita]
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
scripts/download.sh "https://www.youtube.com/watch?v=..."
```

Audio in MP3:

```bash
scripts/download.sh "URL" mp3
```

Qualità minima:

```bash
scripts/download.sh "URL" best ~/Desktop/yt-dlp/audio wa/w
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

I comandi sono relativi alla cartella della skill. L’agente li esegue con il
path assoluto dello script.

```bash
scripts/download.sh <URL> [altezza] [outdir]
```

| Argomento | Default | Significato |
|-----------|---------|-------------|
| `URL` | — | link al video o playlist |
| `altezza` | `best` | limite di altezza (`1080`, `720`, …) |
| `outdir` | `~/Desktop/yt-dlp/video` | cartella di destinazione |

#### Esempi

Miglior qualità disponibile:

```bash
scripts/download.sh "https://www.youtube.com/watch?v=..."
```

720p:

```bash
scripts/download.sh "URL" 720
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

o direttamente, dalla cartella della skill:

```bash
scripts/pulisci.sh ~/Desktop/yt-dlp
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

I symlink puntano al checkout: dopo un `git pull` gli agenti leggono già i
file nuovi. Rilancia il collegamento se hai aggiunto una skill:

```bash
cd ~/yt-dlp-skills
./scripts/link-skills.sh
```

## Disinstallare

Rimuovi i symlink nelle due destinazioni. Questo non cancella il checkout.

```bash
rm ~/.claude/skills/yt-dlp-audio \
   ~/.claude/skills/yt-dlp-video \
   ~/.claude/skills/yt-dlp-inferenza \
   ~/.claude/skills/yt-dlp-pulisci \
   ~/.agents/skills/yt-dlp-audio \
   ~/.agents/skills/yt-dlp-video \
   ~/.agents/skills/yt-dlp-inferenza \
   ~/.agents/skills/yt-dlp-pulisci
```

## Disclaimer

Questi script sono strumenti di automazione personale. Scaricare contenuti da
YouTube o da altre piattaforme può violare i **Termini di Servizio** dei siti e
la normativa sul **copyright** del proprio paese. L’autore non si assume alcuna
responsabilità per l’uso che fai di questi strumenti. Usali solo per contenuti di
cui hai il diritto di scaricare una copia.

## Licenza

Distribuito sotto licenza MIT. Vedi il file [`LICENSE`](./LICENSE).
