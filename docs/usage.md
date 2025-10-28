# 🧰 **git-upload-anything — Usage Guide**

### 1. Rendi lo script eseguibile

```bash
chmod +x git-upload-anything.sh
```

---

### 2. Carica una cartella

```bash
git-upload-anything --source ./examples/sample-project --repo MySampleRepo
```

---

### 3. Carica un file ZIP e pulisci dopo l’upload

```bash
git-upload-anything --source ./project.zip --repo MyProject --cleanup
```

---

### 4. Crea un repository privato

```bash
git-upload-anything --source ./folder --repo MyPrivateRepo --private
```
