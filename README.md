## Bootstrap

### Install prerequisites

```shell
sudo add-apt-repository -y ppa:jdxcode/mise
sudo apt update -y
sudo apt install -y mise
```

### Bootstrap secrets
```shell
mkdir -p ~/git
cd git
git clone https://github.com/pellepelster/dotfiles.git
cd dotfiles

eval $(mise backup:bootstrap:env)
mise bootstrap
```

git remote remove origin
git remote add origin git@github.com:pellepelster/dotfiles.git