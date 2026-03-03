# macos-bootstrap (T1921)

Bootstrap reproducible para macOS: dev + diseño + daily apps usando Homebrew Bundle.

## Requisitos
- macOS
- Acceso admin (para instalaciones)
- Conexión a internet

## Instalación rápida
1) Clona el repo o copia estos archivos a una carpeta:
- `Brewfile`
- `bootstrap.sh`

2) Ejecuta:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### ¿Qué hace?
- Instala Xcode Command Line Tools (si faltan)
- Instala Homebrew (si falta)
- Corre brew bundle usando tu Brewfile
- Configura mise en ~/.zshrc (si está instalado)

### Validación

```bash
brew --version
brew bundle check
gh --version
pnpm -v
node -v
/usr/libexec/java_home -V
java -version
```

### Nota sobre Node (mise vs nvm)

Este setup pude incluir ambos. Recomendación:
- Usa mise como runtime manager principal.
- Deja nvm solo si tienes proyectos legacy que lo requieran.

### App Store (opcional con mas)

Si quieres instalar apps del App Store (ej: Xcode) por CLI:

1. Agrega a Brewfile:

```ruby
brew "mas"
```

2. Logueate en la App Store:

3. Busca IDs:
```bash
mas search Xcode
```

4. Instala apps:
```bash
mas install <APP_ID>
```

### Mantenimiento

- Actualizar todo:
```bash
brew update && brew upgrade && brew cleanup
```
- Revisar si falta algo del Brewfile:
```bash
brew bundle check
```
