# MSYS2

## 参考

[https://www.kkaneko.jp/tools/win/windows_msys2dev.html](https://www.kkaneko.jp/tools/win/windows_msys2dev.html)

## MSYS2 

```bash
pacman -Syu
pacman -Syu make autoconf clang
pacman -Syu mingw-w64-x86_64-clang

cd /c/Repositories/systemc/objdir
export CXX=clang++
../configure --prefix=/c/Repositories/systemc/build/systemc-2.3.3

```
## MSYS2 へインストールしたコマンドのパス設定

```cmd
set PATH="C:\msys64\usr\bin";%PATH%;
C:\msys64\mingw64\bin
```

https://qiita.com/kojiohta/items/fb6c307365d1db388acc

```bash
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
cd /usr/bin
sudo ln -s clang-15 clang
sudo ln -s clang++-15 clang++
```
