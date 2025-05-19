# 🔍 Auditoria com Slither

Este projeto guia a instalação e uso do [Slither](https://github.com/crytic/slither), uma ferramenta estática para análise de segurança de smart contracts escritos em Solidity.

---

## 📦 Instalação

### 🗂️ Criar Pasta do Projeto

```bash
mkdir auditoria_slither
cd auditoria_slither
npm init
```

### 🍺 Instalar e Configurar o Homebrew (Linux)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /home/s862517910/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/s862517910/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```


### 🐍 Verificar Instalação do Python

Nos sistemas GNU/Linux, o Python já costuma vir instalado. Verifique com:
```bash
python3 --version
```
Caso não tenha instalado, acesse: python.org/downloads


### 🛠️ Instalar Slither
```bash
brew install slither-analyzer
```

## 🧪 Adicionar Script no package.json
No arquivo package.json, adicione o seguinte:
```json
{
  "scripts": {
    "slither": "slither . --solc-remaps"
  }
}
```

## 📷 Exemplo de uso:
```bash
slither OrganizationImpl.sol --solc-remaps @openzeppelin=../node_modules/@openzeppelin
```

## ⚙️ Instalar e Configurar o solc-select
```bash
brew install solc-select
solc-select install 0.5.9
solc-select use 0.5.9
```

## 🚀 Executando o Slither

Navegue até a pasta do projeto no terminal e execute:

✅ Para rodar todos os contratos .sol:
```bash
slither .
```

📄 Para rodar apenas um arquivo específico:
```bash
slither <nome_arquivo>.sol
```

## 📌 Requisitos <br>
	•	Node.js <br>
	•	Python 3.x <br>
	•	Homebrew <br>
	•	solc versão compatível com os contratos (via solc-select) <br>