# Patch组件<a name="ZH-CN_TOPIC_0000001078264110"></a>

-   [简介](#section11660541593)
-   [特定芯片架构驱动补丁（比如Hi3516DV300）](#section1521510717399)
-   [目录](#section21571344112)
-   [使用](#section1393789267)
    -   [使用说明](#section1352114469620)

-   [以hi3516dv300开源开发板+ubuntu x86主机开发环境为例](#section19369206113115)
    -   [场景1：版本级编译原生方式](#section1025111193220)
    -   [场景2：单独编译修改后的内核](#section17446652173211)

-   [相关仓](#section27639463106)

## 简介<a name="section11660541593"></a>

OpenHarmony的Linux内核基于开源Linux内核LTS 4.19.y分支演进，为满足不同的内核场景诉求，针对性地合入CVE补丁  + OpenHarmony特性 + vendor厂商具体的板级芯片驱动补丁从而构成完整的内核基线。

Linux社区LTS 4.19.y分支信息请查看[kernel官网](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y)。

内核的Patch组成模块，在编译构建流程中，针对具体芯片平台，合入对应的架构驱动代码，进行编译对应的内核镜像。所有补丁来源均遵守GPL-2.0协议。

## 特定芯片架构驱动补丁（比如Hi3516DV300）<a name="section1521510717399"></a>

vendor厂商提供的特定芯片架构驱动代码：

hi3516dv300_small.patch: 在Hi3516DV300芯片上支持arm架构的内核启动（DTS等）及对应的drm/mmc等驱动的支持。

## 目录<a name="section21571344112"></a>

```
├── kernel.mk          # 支持Hi3516DV300等平台内核编译Makefile
├── kernel_module_build.sh          # 支持Hi3516DV300等平台内核及KO模块编译脚本
├── linux-4.19/hi3516dv300_small_patch # 4.19内核上Hi3516dv300开发板的补丁
    ├── hi3516dv300_small.patch   # 厂商Hisilicon对应的开源开发板Hi3516dv300相关的芯片patch
    ├── hdf.patch                 # Hi3516dv300开发板上支持HDF特性的patch
```

## 使用<a name="section1393789267"></a>

### 使用说明<a name="section1352114469620"></a>

如需使用上述patch，需要在内核代码完成对应芯片平台驱动补丁进行合入。

1.  合入芯片平台驱动补丁（参考kernel.mk）

    针对不同芯片平台合入对应的patch，以上述Hi3516DV300为例：

    ```
    patch -p1 < hdf.patch && patch -p1 < hi3516dv300_small.patch
    ```

    >![](public_sys-resources/icon-notice.gif) **须知：**   
    >* 由于OpenHarmony工程的编译构建流程中会拷贝kernel/linux-4.19的代码环境后进行打补丁动作，在使用如下场景1的OpenHarmony的版本级编译命令前，需要kernel/linux-4.19保持原代码环境。  
    >* 对应拷贝后的目录位于: out/KERNEL_OBJ/kernel/src_tmp/linux-4.19，需要在该目录下进行如下场景2的单独编译等开发操作。


## 以hi3516dv300开源开发板+ubuntu x86主机开发环境为例<a name="section19369206113115"></a>

### 场景1：版本级编译原生方式<a name="section1025111193220"></a>

使用工程的全量编译命令，编译生成uImage内核镜像

```
./build.sh --product-name Hi3516DV300 # 编译hi3516dv300的uImage内核镜像
```

### 场景2：单独编译修改后的内核<a name="section17446652173211"></a>

1.  准备工作

    准备编译环境，可以使用开源arm clang/gcc编译器，或者使用工程自带编译器。

    进入工程主目录配置环境变量：

    ```
    export TARGET_PRODUCT=Hi3516DV300 # HDF驱动需要
    export PATH=`pwd`/prebuilts/clang/host/linux-x86/clang-r353983c/bin:`pwd`/prebuilts/gcc/linux-x86/arm/gcc-linaro-7.5.0-arm-linux-gnueabi/bin/:$PATH # 配置编译环境
    MAKE_OPTIONES="ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- CC=clang HOSTCC=clang" # 使用工程项目自带的clang环境
    ```

2.  直接进入整编过的内核目录out/KERNEL_OBJ/kernel/src_tmp/linux-4.19下修改内核代码或config （OpenHarmony提供对应平台的defconfig供参考）。
3.  生成内核.config。

    ```
    make ${MAKE_OPTIONES} hi3516dv300_standard_defconfig # 使用自带的默认config 构建内核
    ```

4.  编译生成对应的内核Image。

    ```
    make ${MAKE_OPTIONES} -j32 uImage # 编译uImage内核镜像
    ```


## 相关仓<a name="section27639463106"></a>

<u>kernel\_linux\_patches</u>

<u>device\_hisilicon\_hi3516dv300</u>

