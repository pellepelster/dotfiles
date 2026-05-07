## Bootstrap

### Install prerequisites

```shell
sudo apt update -y && sudo apt install -y curl
sudo install -dm 755 /etc/apt/keyrings
curl -fSs https://mise.en.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.en.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update -y
sudo apt install -y mise git
```

### Bootstrap secrets
```shell
mkdir -p ~/git
cd git
git clone https://github.com/pellepelster/dotfiles.git
cd dotfiles

eval $(mise backup:bootstrap:env)
mise bootstrap:secrets

git remote remove origin
git remote add origin git@github.com:pellepelster/dotfiles.git
```

### Bootstrap

```shell
mise setup:apps
mise setup:git
mise setup:docker
```