# __project_codename__

## Requirements

## Installation

### Linux

To install for example in your ~/.local/bin folder:
```bash
./install.sh --destination ~/.local/bin
```

To install system-wide:
```bash
sudo ./install.sh --destination /usr/local/bin
```

Change your configuration file in "${HOME}/.config/__project_codename__.conf" (see the example in the config folder).

### Windows (from PowerShell)

Ensure you have "C:\Users\${env:USERNAME}\AppData\Roaming\Python\Python${python_version}\Scripts\" in your Path environment variable.

  ```powershell
& $(where.exe pip).split()[0] install .
```

## Usage

  ```bash
__project_codename__.sh [--debug-level|-d CRITICAL|ERROR|WARNING|INFO|DEBUG|NOTSET] # Other parameters
```
