# git-upload-anything

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**git-upload-anything** è un potente script Bash progettato per automatizzare il processo di caricamento di directory locali o file zip in un nuovo repository GitHub. Semplifica la creazione di repository, l'inizializzazione di Git e il push del tuo codice, rendendo l'upload su GitHub più rapido e senza sforzo.

Con questo strumento, chiunque può:
*   Installare lo script con facilità tramite `install.sh`.
*   Caricare rapidamente progetti su GitHub.
*   Consultare documentazione ed esempi pronti all'uso.

## 🚀 Caratteristiche

*   **Caricamento Flessibile:** Supporta il caricamento di intere directory o file zip compressi.
*   **Creazione Automatica Repository:** Crea automaticamente un nuovo repository GitHub.
*   **Visibilità Configurable:** Permette di scegliere tra repository pubblici o privati.
*   **Gestione Dipendenze:** Rileva e, se possibile, installa automaticamente le dipendenze mancanti (come `git`, `curl`, `unzip`, `gh`).
*   **Autenticazione GitHub CLI:** Inizia il processo di autenticazione di GitHub CLI (`gh`) se non già autenticato.
*   **Cleanup Automatico:** Opzione per rimuovere i file temporanei dopo un caricamento riuscito.
*   **Interfaccia CLI Intuitiva:** Semplici flag da riga di comando per un'automazione efficiente.

## 🔧 Requisiti

Per eseguire `git-upload-anything`, sono necessarie le seguenti dipendenze:

*   `bash`
*   `curl`
*   `unzip`
*   `git`
*   `gh` (GitHub CLI) - Se non presente, lo script tenterà di installarlo automaticamente su sistemi supportati (come con `brew`) o ti guiderà all'installazione manuale.

Lo script è stato testato con successo su:
*   Termux
*   Ubuntu/Debian
  
todo:
*   Arch
*   macOS

## ⚙️ Installazione

Per installare `git-upload-anything` a livello di sistema, esegui i seguenti comandi:

```bash
chmod +x install.sh
sudo ./install.sh
```

Questo copierà lo script eseguibile in `/usr/local/bin/git-upload-anything`, rendendolo disponibile da qualsiasi posizione nel tuo terminale.

## 💡 Utilizzo

Dopo l'installazione, puoi eseguire lo script chiamandolo semplicemente `git-upload-anything`.

### Sintassi Generale

```bash
git-upload-anything --source <path> --repo <name> [OPTIONS]
```

### Flag CLI

| Flag        | Descrizione                                                                    |
| :---------- | :----------------------------------------------------------------------------- |
| `--source`  | Percorso della cartella o del file zip da caricare.                            |
| `--repo`    | Nome del repository da creare su GitHub.                                       |
| `--private` | Rende il repository privato (il valore predefinito è pubblico).                |
| `--cleanup` | Rimuove i file temporanei creati durante il processo di caricamento.           |
| `--help`    | Mostra il messaggio di aiuto ed esce.                                          |

### Esempi di Utilizzo

1.  **Caricare una cartella su un repository pubblico:**

    ```bash
    git-upload-anything --source ./examples/sample-project --repo MySampleRepo
    ```

2.  **Caricare un file zip su un repository privato e pulire i file temporanei:**

    ```bash
    git-upload-anything --source ./project.zip --repo MyProject --private --cleanup
    ```

3.  **Caricare una cartella e renderla privata:**

    ```bash
    git-upload-anything --source ./my_local_folder --repo MyPrivateApp --private
    ```

4.  **Visualizzare il messaggio di aiuto:**

    ```bash
    git-upload-anything --help
    ```

## 📂 Struttura del Repository

```
git-upload-anything/
├── README.md
├── LICENSE
├── git-upload-anything.sh
├── install.sh
├── .gitignore
├── examples/
│   └── sample-project.txt
└── docs/
    └── usage.md
```

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Per maggiori dettagli, consulta il file [LICENSE](LICENSE).
