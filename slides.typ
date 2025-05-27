#import "@preview/touying:0.6.1": *
#import "dewdrop.typ": *
#import "@preview/pinit:0.2.2": *

#import "@preview/numbly:0.1.0": numbly

#show: dewdrop-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title + " - 孙旭栋",
  navigation: "mini-slides",
  mini-slides: (height: 2em, x: 7em, display-section: false, display-subsection: true, short-heading: true),
  //config-common(show-notes-on-second-screen: right),
  config-info(
    title: [基于RISC-V的32位处理器设计],
    subtitle: [Design and Implementation of 32-bit RISC-V Processor],
    author: [孙旭栋\
            指导教师：蒋炎岩],
    date: datetime.today(),
    institution: [],
  ),
  primary: rgb("#085a7b"),
  alpha: 50%,
)

#set text(
  font: ("Arial", "WenQuanYi Micro Hei")
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#show heading.where(level: 2): set text(size: 28pt)

#title-slide()

= 绪论


== 背景

#let subsection(x) = text(size: 26pt, weight: "bold", fill: rgb("#085a7b"), x)
#let small(x) = text(size: 18pt, x)
#let gray(x) = text(fill: white.darken(50%), x)
#let cold(x) = text(fill: rgb("2878b5"), weight: "bold", x)
#let hot(x) = text(fill: rgb("c82423"), weight: "bold", x)

*RISC-V*：

- 模块化指令集 —— #gray[RV32E - RV64GC]
- 设计简洁，简化硬件设计和验证 —— #gray[定长指令，4种核心指令格式]

*EDA工具*：

- 全流程验证
  - 系统/微架构级 —— #gray[QEMU，gem5，缓存模拟器]
  - 现场可编程门阵列（FPGA）
  - ASIC
- 硬件描述语言抽象级提升 —— #gray[Chisel]

== 国内外研究现状

学术研究提供架构创新源泉，工业应用加速技术迭代，教育实践培养生态人才。

- *开源核心设计*
- *商业化芯片定制*
- *EDA工具创新*
- *教育实践*

== <touying:hidden>

#subsection("国外")

- *开源核心*
  - BOOM #gray[UC Berkeley]
- *EDA工具*
  - Rocket Chip #gray[UC Berkeley]
- *教育实践* 
  - 6.175 —— #gray[MIT]
  - CS152 —— #gray[UC Berkeley]

== <touying:hidden>

#subsection("国内")

- *开源核心*
  - 香山处理器 —— #gray[香山团队]
  - 果壳处理器 —— #gray[一生一芯团队]
- *EDA工具*
  - iEDA —— #gray[iEDA团队]
- *商业化芯片定制*
  - 玄铁处理器 —— #gray[阿里平头哥]
  - 无剑SoC —— #gray[阿里平头哥]
- *教育实践*
  - 芯动力-硬件设计加速方法 —— #gray[西南交通大学]
  - 一生一芯项目 —— #gray[一生一芯团队]

== 研究思路与动机

*关键词*：#("RISC-V；处理器；基础设施；SoC；性能评估与优化",)

- 完善指令集架构与系统软件支持

- 外设

- 量化性能评估与微结构优化

- 敏捷开发

- 功能，时序与面积验证

通过软硬件结合的处理器前端设计实践提供ASIC流程的参考经验与理论依据。

= 处理器架构

== 指令集架构

- RV32E：指令，通用寄存器，控制状态寄存器（CSR），性能计数器

#v(1.5cm)

#figure(
  table(
    columns: 3,
    stroke: none,
    inset: (x: 10pt, y: 9pt),
    table.hline(),
    [地址], [CSR],     [描述],
    table.hline(),
    [0xf11], [mstatus], [机器状态寄存器],
    [0xf12], [mtvec],   [异常处理程序基地址],
    [0x342], [mepc],    [触发异常时保存的pc值],
    [0x341], [mcause],  [触发异常的原因],
    table.hline(),
  ),
  caption: [特权架构寄存器]
)<csr>


#figure(
  table(
    columns: 2,
    stroke: none,
    inset: (x: 10pt, y: 10pt),
    table.hline(),
    [性能计数器],       [描述],
    table.hline(),
    [retired instrs], [已退休的指令数],
    [cycles],   [程序执行总周期数],
    [fetch stall cycles],    [等待取指周期数],
    [MEM/JUMP...],  [译码出各种类型指令数],
    [branch taken], [分支指令中跳转的数量],
    [memory wait cycles], [访存指令等待周期数],
    [icache...], [icache命中，未命中和等待周期数],
    [pipeline...], [流水线各种冒险的次数和停顿周期数],
    table.hline(),
  ),
  caption: [性能计数器]
)<perf>


== 微架构与总线

#figure(
  image("/images/npc.svg", width: 80%),
  caption: [处理器架构]
)<arch>
- 延迟无关设计（LID）


= 访存模块与SoC环境

== 访存模块

  #grid(
  columns: (1fr, 1fr),
  align(center)[
    #figure(
      image("/images/memory.svg", width: 95%, height: 80%),
      caption: [
        访存模块
      ]
    )<devices>
  ],
  align(center)[
    #v(2cm);
    #figure(
      table(
        columns: 2,
        stroke: none,
        table.hline(),
        [设备], [地址空间],
        table.hline(),
        [CLINT], [0x02000000-0x0200ffff],
        [SRAM], [0x0f000000-0x0fffffff],
        [UART], [0x10000000-0x10000fff],
        [SPI], [0x10001000-0x10001fff],
        [Flash], [0x30000000-0x3fffffff],
        [SDRAM], [0xa0000000-0xbfffffff],
        table.hline(),
      ),
      caption: [
        设备地址空间映射
      ]
    )<map>
  ]
)

== SoC环境

  #grid(
    columns: (1fr, 1fr),
    align(center)[
      #figure(
        image("/images/asic_simple.svg", width:100%, height: 80%),
        caption: [SoC结构]
      )<soc>
    ],
    align(center)[
      #v(5cm);
      - *总线* —— #gray[AXI，APB，SPI......]
      - *外设* —— #gray[SDRAM，Flash......]
    ]

  )

== 外设与访存延迟校正

#figure(
  image("/images/sdram.svg", width: 85%),
  caption: [SDRAM结构图]
)<sdram>

== <touying:hidden>

#subsection("SPI-Flash")

- *片上*SPI-master
- *片外*SPI-slave：Flash，slave1，slave2...

#grid(
  columns: (1fr, 1fr),
  align(center)[
    #figure(
      image("/images/flash.svg", width: 130%),
      caption: [
        SPI-Flash
      ]
      )<Flash>
  ],
  align(center)[
    #figure(
      table(
        columns: 2,
        stroke: none,
        table.hline(),
        [字段], [功能],
        table.hline(),
        [RxX], [数据接受],
        [TxX], [数据发送],
        [CTRL], [控制与状态],
        [DIVIDER], [时钟分频除数],
        [SS], [片选],
        table.hline(),
      ),
      caption: [SPI-master设备寄存器]
    )<spi_master>
  ]

)

== <touying:hidden>

#subsection("XIP模式")

通过*就地访问*(Execute In Place， XIP)模式取出Flash中的指令执行。

#figure(
  image("/images/xip.svg", width: 69%, height: 50%),
  caption: [XIP状态机流程图]
)<xip>

== <touying:hidden>

#subsection("访存延迟校正")

- 处理器与外设运行在*不同的频率*下
- Verilator*单时钟域*仿真
- 基于LID在互联中加入中继站（Relay Station），校正访存延迟，获得*周期级精确*的模拟。

若处理器核心和设备的*主频比值*为n, 当处理器核心在$t_0$时刻*发起APB请求*，设备在$t_1$时刻*响应*时，则APBdelay模块需要在满足
$
 (t_1-t_0) dot n = t_1^'-t_0 
$
*延迟后*的$t_1^'$时刻向处理器核心返回响应。

= 基础设施与运行时环境

== 调试器视角

#figure(
  image("/images/infra.svg", width: 58%,height: 80%),
  caption: [基础设施与运行时环境]
)<infra>

== 程序运行视角

#figure(
  image("/images/link.svg", width: 100%),
  caption:[运行时内存映像]
)<memory>

= 性能评估与优化

== 概述

- *基准测试程序*：Microbench —— #gray[排序，位操作，md5校验...]
- *性能公式*与*基准数据*：

$
 "Iron Law": "perf" = "insts"/"prog" dot "cycles"/"inst" dot "times"/"cycle" 
$

$
 "Amdahl's Law": f(s) = 1 / (1 - p + p / s) 
$

#figure(
  table(
    columns: 8,  // 关键行
    stroke: none,
    table.hline(),
    [commit], [说明], [instrs], [cycles], [fetch stall], [LD], [ST], [memory],
    table.hline(),
    [256bda1], [no cache], [576664], [2648
    2178], [2115
    7364], [76204], [58156], [461
    3781],
    table.hline(),
    ),
  caption: [单周期处理器性能评估],
)

== 局部性与Cache

- *重用距离*

#grid(
  columns: (1fr,1fr),
  align(center)[
    #figure(
      image(
        "/images/reuse_distance.png",
        width:125%
      ),
      caption: [
        指令重用距离
      ],
    )<reuse>
  ],

  align(center)[
    #figure(
      image(
        "/images/data_reuse_distance.png",
        width: 125%
      ),
      caption: [数据重用距离],
    )
  ]
)


#subsection("Cache")

- *Cache设计因素*：
  - 块大小：同处理器字长
  - 容量
  - 映射机制
  - 替换策略

- *性能公式*：
$
 "AMAT"=p dot "access_time" + (1-p) dot ("access_time" + "miss_penalty")
$
- *缺失率构成*：
  - compulsory miss
  - capacity miss
  - conflict miss

== <touying:hidden>

#subsection[设计空间探索]

#figure(
  image("/images/cache_miss.png", width: 80%),
  caption:[不同配置下cache的命中率构成]
)<cache_sim>

== <touying:hidden>

#subsection[ICache开销]

#figure(
  table(
    columns: 7,
    [module], [ICache], [AOI22], [BUF], [DFF], [MUX2], [其它],
    [个数], [1], [115], [1376], [485], [715], [x],
    [单位面积/$mu m^2$], [5192.59], [1.33], [0.798], [4.522], [1.862], [x],
    [总面积/$mu m^2$], [5192.59], [152.95], [1098.05], [2193.17], [1331.33], [417.09]
  ),
  caption: [基于nangate45单元的8行直接映射缓存的面积构成]
)<area>

== <touying:hidden>

#subsection[ICache收益]

#figure(
  table(
    columns: 8,  // 关键行
    stroke: none,
    table.hline(),
    [commit], [说明], [instrs], [cycles], [fetch stall], [LD], [ST], [memory stall],
    table.hline(),
    [256bda1], [no cache], [57
    6664], [2648
    2178], [2115
    7364], [76204], [58156], [461
    3781],
    [918127d], [8l1w_r], [57
    6366], [1892
    1639], [1380
    6998], [76208], [58142], [440
    3915],
    table.hline(),
    ),
  caption: [cache性能评估], 
)

== 时序面积与流水线

高级体系结构优化如*流水线*,*乱序处理器*均以多周期为基础。针对关键路径进行时序优化，并减少面积开销。

- Iron Law:
$
 "Iron Law": "perf" = "insts"/"prog" dot "cycles"/"inst" dot "times"/"cycle" 
$

- CPI stack:
$
"CPI"_"avg" = "CPI"_"base" + "CPI"_"memory"
$<CPI>

设存储器的*绝对访问时间*为$L$，当频率从$f_1$变成$f_2$时，其中$f_2=k dot f_1$。*原访存周期数*为$L dot f_1$，则*新访存周期数*为

$
L dot f_ 2=k dot L dot f_1
$

#figure(
  image("/images/csr.png"),
  caption:[CSR模块部分拓扑结构]
)<csr>


#subsection[拓扑路径]

#figure(
  image("/images/ltp.png"),
  caption:[CSR模块最长拓扑路径]
)<ltp>

== <touying:hidden>

#subsection[流水线]

功能单元在同一个周期同时工作，处理不同指令的同一阶段，理想情况下每周期完成一条指令，实现*指令级并行*，提高计算效率。

$
"CPI"_"multi"=4+"CPI"_"memory"
$

$
"CPI"_"pipe"=1+"CPI"_"memory"+"CPI"_"hazard"
$

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),  // 关键行
    stroke: none,
    table.hline(),
    [commit], [说明], [instrs], [cycles], [ipc],
    table.hline(),
    [43cc50b], [multicycle], [576379], [26967113], [0.0214],
    [18cce88], [pipeline], [576730], [26098354], [0.0221],
    table.hline(),
    ),
  caption: [pipeline性能评估],
)<pipeline>

- 进一步优化，需要更精确的*性能计数器架构*。

= 实验与展望

== 功能验证

#figure(
  image("/images/instr_test.png", width: 50%),
  caption: [risv-tests-am]
)<instr_test>



#figure(
  image("/images/rtt.png", width: 100%),
  caption: [RT-Thread]
)

== 时序，面积与IPC

#figure(
table(
  columns: 7,
  stroke: none,
  table.hline(),
  table.header(
    [*End-point*], [*Clock Group*], [*Delay Type*], [*Path Delay*],
    [*Require*], [*Slack*], [*Freq-(MHz)*]
  ),
  table.hline(),
  [ifu_224], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [ifu_219], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [ifu_214], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [clint_119], [clock], [min], [0.066r], [0.006],  [0.060], [NA],
  [clint_119], [clock], [min], [0.065f], [0.003],  [0.062], [NA],
  [clint_126], [clock], [min], [0.137r], [0.005],  [0.132], [NA],
  table.hline(),
),

caption: [流水线时序报告]

)<timing>


#figure(
  image("/images/core_area.png", width: 90%),
  caption: [NPC各模块面积]
)<area>

*总面积*： 26710.39$mu m^2$ 


#subsection[IPC]
#figure(
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),  // 关键行
    stroke: none,
    table.hline(),
    [commit], [说明], [instrs], [cycles], [ipc],
    table.hline(),
    [43cc50b], [multicycle], [576379], [26967113], [0.0214],
    [18cce88], [pipeline], [576730], [26098354], [0.0221],
    table.hline(),
    ),
  caption: [IPC],
)<ipc>

== 不足与展望

1. 处理器*微架构*方向的优化： 通过*分支预测*与*缓存预取*等技术进一步提高处理器性能，或后续改成*乱序处理器*架构，其关键在于通过*精准的性能计数器架构*寻找到实际的*性能瓶颈*。

2. 可以进行*指令集的完善*，实现更完善的*特权架构*，结合*AM模块*的进一步扩展，比如支持*虚拟内存*，启动*xv6或Linux*等更复杂的程序。

3. 可以将NPC与SoC移植到*FPGA*上进行上板验证，提高验证效率，并实现更完善的*硅前验证链*，为后续的*流片*提供保障。

4. 可以使用基于Scala的领域特定语言*Chisel*对处理器核进行重构，结合*现代编程语言*的能力提高处理器开发的效率，并针对设计与验证的*工具链*进一步探索，实现*敏捷开发*。

#let bigbold(x) = text(size: 40pt, weight: "bold", fill: rgb("#085a7b"), x)

== <touying:hidden>

#v(5cm);
#bigbold[感谢各位老师批评指正]