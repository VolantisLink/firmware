# 说明

## 0x00 开发系统准备

操作系统： debian 10/11

```sh
sudo apt install -y automake gcc g++ git make rsync libncurses-dev
```

## 0x01 编译buildroot-2022.02.1

### 0x01-1 编译默认配置的镜像

系统包含了两个初始的buildroot配置文件：

- `buildroot-config.2022.02.1.minimal` -- 最小配置，编译的`iot-edge`可以运行。
- `buildroot-config.2022.02.1.python` -- 加入了`python-3.10`支持。

```sh
git clone https://github.com/VolantisLink/firmware.git
cd firmware
mkdir build
cd build
wget https://github.com/buildroot/buildroot/archive/refs/tags/2022.02.1.tar.gz
tar zxvf 2022.02.1.tar.gz
cd buildroot-2022.02.1
cp ../../config/buildroot-config.2022.02.1.minimal .config
mkdir -p output/build/image
make
cp output/images/uImage ../../burn/images
cd ../../  # 回到firmware根目录
```

### 0x01-2 定制软件包

执行以下命令可以加入定制的软件包：

```
make menuconfig

# 进入`Target packages`选择所需软件。
```

**注意：加入软件之后生成的`uImage`文件大小不能超过16M，否则系统会无法启动。**

## 0x02 烧录

### 0x02-1 烧录工具准备

```sh
cd burn

# 编译烧录工具
git clone https://gitee.com/OpenNuvoton/NUC980_NuWriter_CMD.git
cd NUC980_NuWriter_CMD
sudo apt-get install libusb-1.0-0-dev
autoconf
./configure
make
sudo make install

## 初始化烧录环境
cd ..
mkdir -p NONE/share
cp -r NUC980_NuWriter_CMD/nudata NONE/share
```

### 0x02-2 烧录uImage

```sh
cp ../build/buildroot-2022.02.1/output/images/uImage images
cp ../build/buildroot-2022.02.1/output/images/u-boot.bin images
sudo nuwriter run.ini
```
