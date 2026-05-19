# QEMU ARM Linux-6.6 Patches

## 目录结构

```
qemu-arm-linux_patch/
├── qemu-arm-linux.patch    # ARM boot Makefile 修改
├── watchdog.patch          # watchdog.c 兼容性补丁
└── README.md               # 本文档
```

## 补丁说明

### 1. qemu-arm-linux.patch

**作用**: 修改 ARM boot Makefile，支持 zImage-dtb 生成

**修改内容**:
- 添加 `zImage-dtb` 到 targets 列表
- 创建 zImage-dtb 生成规则（复制 zImage）
- 修改 uImage 依赖为 zImage-dtb

**原因**: QEMU ARM 需要 zImage-dtb 格式的内核镜像

**应用方式**:
```bash
patch -p1 < qemu-arm-linux.patch
```

### 2. watchdog.patch

**作用**: 添加缺失的 watchdog_en per-cpu 变量

**修改内容**:
- 在 `kernel/watchdog.c` 中添加 `static DEFINE_PER_CPU(unsigned int, watchdog_en);`

**原因**: OpenHarmony 的 `watchdog_enable()` 函数使用了 `watchdog_en` 变量，
但 Linux-6.6 上游移除了这个变量。

**临时性质**: 这是一个临时解决方案，长期应该通过 HDF 适配层处理。

**应用方式**:
```bash
patch -p1 < watchdog.patch
```

## 依赖说明

### 头文件依赖

以下 OpenHarmony 特定头文件由 `kernel/linux/common_modules/ohoe_headers/apply_ohoe_headers.sh`
脚本注入，不包含在本补丁包中：

| 头文件 | 来源 | 用途 |
|--------|------|------|
| memcg_policy.h | linux-5.10 | 内存控制策略 |
| memcheck.h | linux-5.10 | 内存检查 |
| hyperhold_inf.h | linux-5.10 | Hyperhold 回收 |
| lowmem_dbg.h | linux-5.10 | 低内存调试 |
| xpm.h, xpm_types.h | linux-5.10 | XPM 电源管理 |
| zswapd.h | linux-5.10 | ZSWAP 守护进程 |
| mm_purgeable.h | linux-5.10 | 可清除内存 |
| reclaim_acct.h | linux-5.10 | 回收记账 |
| memory_group_manager.h | rk3568_patch | Mali GPU 内存管理 |

### 构建系统依赖

**kernel.mk 修改**: 需要为 ARM 平台设置 `LOADADDR=0x40008000`

**修改位置**: `kernel/linux/build/kernel.mk`

**修改内容**:
```makefile
ifeq ($(KERNEL_ARCH), arm)
    KERNEL_TARGET_TOOLCHAIN := ...
    KERNEL_TARGET_TOOLCHAIN_PREFIX := ...
    KERNEL_LOADADDR := 0x40008000  # 添加此行
endif
```

## 应用顺序

在构建内核时，补丁应用顺序如下：

1. 复制源码到临时目录
2. 应用 HDF 补丁
3. 应用 QEMU ARM 设备补丁 (`qemu-arm-linux.patch`)
4. 应用 watchdog 补丁 (`watchdog.patch`)
5. 注入 OpenHarmony 头文件 (`apply_ohoe_headers.sh`)
6. 注入其他 common modules
7. 拷贝配置文件
8. 执行 `make distclean`
9. 执行 `make defconfig`
10. 执行 `make uImage`

## QEMU ARM 特定配置

### defconfig

QEMU ARM 的 defconfig 位于:
```
kernel/linux/config/linux-6.6/arch/arm/configs/qemu-arm-linux_standard_defconfig
```

关键配置项：
- CONFIG_VIRTIO=y           # QEMU virtio 支持
- CONFIG_SERIAL_AMBA_PL011=y # QEMU UART
- CONFIG_SMC91X=y           # QEMU 网卡
- CONFIG_HDF=y              # OpenHarmony HDF

### 内存布局

- DDR 起始地址: 0x40000000
- 内核加载地址 (LOADADDR): 0x40008000
- 内存大小: 256MB (可配置)

## 与 linux-5.10 的差异

1. **补丁结构**: linux-5.10 所有修改在一个 patch 文件中，
   linux-6.6 拆分为多个专项补丁

2. **头文件注入**: linux-5.10 头文件已存在于源码树中，
   linux-6.6 通过脚本动态注入

3. **watchdog**: linux-6.6 需要额外的 watchdog 兼容补丁

## 待解决问题

1. [ ] 将 watchdog 修改迁移到 HDF 适配层
2. [ ] 评估 memory_group_manager.h 对 QEMU ARM 的必要性
3. [ ] 创建完整的 QEMU ARM defconfig（当前可能缺失）
4. [ ] 建立模块白名单机制
5. [ ] 考虑迁移到独立板级构建脚本（方案 B）

## 参考资料

- 设计文档: `design/qemu_linux_6_6_kernel_switch_design.md`
- 分析报告: `design/linux_6_6_migration_analysis_report.md`
- 参考实现: `device/board/hihope/rk3568/kernel/`

## 维护者

- 创建日期: 2025-05-14
- 最后更新: 2025-05-14
- 维护者: OpenHarmony QEMU ARM Team
