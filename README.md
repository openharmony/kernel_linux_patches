# patches<a name="EN-US_TOPIC_0000001078264110"></a>

-   [Introduction](#section11660541593)
-   [Driver Patch of a Specific Chip \(for Example, hikey960\_patch\)](#section1521510717399)
-   [Directory Structure](#section21571344112)
-   [Usage](#section1393789267)
    -   [Usage Guidelines](#section1352114469620)

-   [Example of Development Using the Hi3516D V300 Board and Ubuntu x86 Server](#section19369206113115)
    -   [Scenario 1: building the native kernel at the version level](#section1025111193220)
    -   [Scenario 2: building the modified kernel separately](#section17446652173211)

-   [Example of Development Using the HiKey960 Board and Ubuntu x86 Server](#section129541683509)
    -   [Scenario 1: building the native kernel at the version level](#section1627202812341)
    -   [Scenario 2: building the modified kernel separately](#section179921412022)

-   [Repositories Involved](#section27639463106)

## Introduction<a name="section11660541593"></a>

The Linux kernel for OpenHarmony is built based on the open-source Linux kernel LTS 4.19.y release and forms a complete kernel baseline by merging the common vulnerabilities and exposures \(CVE\) patches, AOSP features, OpenHarmony features, and board-level chip driver patches provided by vendors to meet requirements in different scenarios.

For details about the Linux kernel LTS 4.19.y git tree, visit  [Linux kernel stable tree](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y).

During compilation and building, you can merge the driver code into a specific chip platform and compile the kernel image. All patches are licensed under GNU General Public License \(GPL\) 2.0.

## Driver Patch of a Specific Chip \(for Example,  **hikey960\_patch**\)<a name="section1521510717399"></a>

Driver code of a specific chip will be provided by a vendor.

Patches in the  **hikey960\_patch**  directory support basic module functions of the open-source HiKey960 board in the kernel 4.19 release, such as debugging services like normal reboot \(DTS\), adb USB port connection \(dwc3-hisi\), and display access \(GPU/DRM\).

## Directory Structure<a name="section21571344112"></a>

```
├── linux/patches/linux-4.19          # Kernel patches
    └── hikey960_patch                # Patch for the Linaro open-source HiKey960 board
    └── hi3516dv300_standard_patch    # Patch for the standard system of the HiSilicon open-source Hi3516D V300 board
    └── hi3516dv300_small_patch       # Patch for the small system of the HiSilicon open-source Hi3516D V300 board
```

## Usage<a name="section1393789267"></a>

### Usage Guidelines<a name="section1352114469620"></a>

You need to run the  **git**  command to merge the required kernel patches into the kernel code \(**kernel/linux-4.19**\).

1.  Merge the chip driver patch.

    Merge the corresponding patches for different chip platforms. The following uses HiKey960 as an example:

    ```
    git am ${KERNEL_PATCH}/hikey960_patch/*.patch
    ```

    >![](public_sys-resources/icon-notice.gif) **NOTICE:** 
    >Because patches are applied after the code environment of  **kernel/linux-4.19**  is copied during compilation and building of the OpenHarmony project, you must retain the original code environment of  **kernel/linux-4.19**  before running the OpenHarmony version-level build command.


## Example of Development Using the Hi3516D V300 Board and Ubuntu x86 Server<a name="section19369206113115"></a>

### Scenario 1: building the native kernel at the version level<a name="section1025111193220"></a>

Perform a full build for the project to generate the  **uImage**  kernel image.

```
./build.sh --product-name Hi3516DV300 # Build the uImage kernel image of the Hi3516D V300 board.
```

### Scenario 2: building the modified kernel separately<a name="section17446652173211"></a>

1.  Set up the build environment.

    You can use the open-source Arm Compiler armclang/GNU Compiler Collection \(GCC\) or the AOSP compiler delivered with the project.

    Enter the root directory of the project and configure environment variables:

    ```
    export PATH=`pwd`/third_party/aosp/10.0.0_r2/prebuilts/clang/host/linux-x86/clang-r353983c/bin:`pwd`/third_party/aosp/10.0.0_r2/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/:$PATH # Configure the build environment.
    MAKE_OPTIONES="ARCH=arm CROSS_COMPILE=arm-linux-androideabi- CLANG_TRIPLE=arm-linux-gnueabi LD=arm-linux-androideabi-ld.bfd CC=clang HOSTCC=clang" # Use Clang provided by the project.
    ```

2.  Modify the kernel code or kernel configuration \(**defconfig**  file provided by OpenHarmony can be used for reference\).
3.  Create a build directory and generate the  **.config**  file of the kernel.

    ```
    make ${MAKE_OPTIONES} hi3516dv300_emmc_smp_hos_l2_defconfig # Use the defconfig file to build the kernel.
    ```

4.  Build the kernel image.

    ```
    make ${MAKE_OPTIONES} -j32 uImage # Build the uImage kernel image.
    ```


## Example of Development Using the HiKey960 Board and Ubuntu x86 Server<a name="section129541683509"></a>

### Scenario 1: building the native kernel at the version level<a name="section1627202812341"></a>

If the kernel does not need to be modified, you can run the following command to build the version-level kernel image:

```
./build.sh --product-name hikey960 --export-para TARGET_KERNEL_USE:4.19 --build-target bootimage # Build the boot.img file for HiKey960.
```

### Scenario 2: building the modified kernel separately<a name="section179921412022"></a>

1.  Set up the build environment.

    The OpenHarmony kernel supports the arm64 Clang or GCC compiler. You can use the build environment provided by the build framework or run the following command to install an open-source cross compiler:

    ```
    sudo apt-get install gcc-aarch64-linux-gnu clang
    ```

2.  Modify the kernel code or kernel configuration \(**defconfig**  file provided by OpenHarmony can be used for reference\).
3.  Set build parameters based on your suitable compiler.
    1.  Use the build environment provided by the OpenHarmony project build framework.

        ```
         export PATH=${BUILD_HOME}/third_party/aosp/10.0.0_r2/prebuilts/clang/host/linux-x86/clang-r353983c/bin:${BUILD_HOME}/third_party/aosp/10.0.0_r2/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH # Configure the PATH environment variable, depending on the AOSP project. BUILD_HOME indicates the top-level code path.
        MAKE_OPTIONES="ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- CLANG_TRIPLE=aarch64-linux-gnu- CC=clang HOSTCC=clang" # Use Clang provided by the project build framework.
        ```

    2.  Use the open-source GCC.

        ```
        MAKE_OPTIONES="ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"
        ```

    3.  Use the open-source Clang.

        ```
        MAKE_OPTIONES="ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- CLANG_TRIPLE=aarch64-linux-gnu- CC=clang"
        ```


4.  Create a build directory and generate the  **.config**  file of the kernel.

    ```
    mkdir kernel_out # Create the build directory.
    make ${MAKE_OPTIONES} O=kernel_out hikey960_defconfig # Use the arch/arm64/config/hikey960_defconfig file as the kernel configuration baseline.
    make ${MAKE_OPTIONES} O=kernel_out menuconfig # Configure features as required.
    ```

5.  Build the kernel image.

    ```
    make ${MAKE_OPTIONES} O=kernel_out -j24 # Build the kernel_out/arch/arm64/boot/Image.gz-dtb image.
    make ${MAKE_OPTIONES} O=kernel_out hisilicon/hi3660-hikey960.dtb # Build a device tree binary (dtb) file if device tree source (dts) is modified.
    ```

6.  Build the  **boot.img**  file required by HiKey960.

    ```
    cp -f kernel_out/arch/arm64/boot/Image.gz-dtb ${BUILD_HOME}/third_party/aosp/device/linaro/hikey-kernel/Image.gz-dtb-hikey960-4.19 # Copy and replace the original AOSP image.
    cp -f kernel_out/arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dtb ${BUILD_HOME}/third_party/aosp/device/linaro/hikey-kernel/hi3660-hikey960.dtb-4.19 # Copy and replace the dtb file provided by AOSP.
    ./build.sh --product-name hikey960 --export-para TARGET_KERNEL_USE:4.19 --build-target bootimage # Build the boot.img file for HiKey960.
    ```


## Repositories Involved<a name="section27639463106"></a>

kernel/linux/patches

