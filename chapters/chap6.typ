= 实验结果与分析

== 功能验证

通过移植到AM中的官方指令测试集#[@riscv-tests]针对各指令进行分别测试，验证各指令的正确性，据@fig:instr_test 可以看到整数计算指令，内存加载存储指令和控制流转移指令均测试正确。由于未实现M扩展，乘除法指令均不能通过，若实际程序中使用到相关指令，需要在编译时指定目标架构，从而将对应指令替换为软件库函数，即使用标准RV32E中的指令模拟乘除法指令。

#figure(
  image("../images/instr_test.png"),
  caption: [risv-tests-am]
)<instr_test>

在SoC环境下运行RT-Thread操作系统。-

#figure(
  image("../images/rtt.png"),
  caption: [RT-Thread]
)


== 时序与面积

由于流水线处理器中需要进行冒险处理，在EXU检测出控制冒险需要冲刷流水线时，需要将flush信号传递给其他流水段/功能单元，当前方案为在检测出冒险的同周期进行冲刷，增加了关键路径的长度，使得主频降低为约500MHZ，面积报告如@tbl:timing 后续可以优化为在周期边沿先锁存flush信号，在下一个周期再进行冲刷。

#figure(
table(
  columns: 7,
  table.header(
    [*End-point*], [*Clock Group*], [*Delay Type*], [*Path Delay*],
    [*Require*], [*Slack*], [*Freq-(MHz)*]
  ),
  [ifu_224], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [ifu_219], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [ifu_214], [clock], [max], [1.936r], [1.967],  [0.032], [508.083],
  [clint_119], [clock], [min], [0.066r], [0.006],  [0.060], [NA],
  [clint_119], [clock], [min], [0.065f], [0.003],  [0.062], [NA],
  [clint_126], [clock], [min], [0.137r], [0.005],  [0.132], [NA],
),

caption: [流水线时序报告]

)<timing>

流水线技术只需要很少的寄存器和部分组合逻辑，故而面积开销较小，整体面积与多周期处理器相差不大，总面积为26710.39$mu m^2$，各模块面积如@fig:area。

// todo: picture name, bar discription

#figure(
  image("../images/core_area.png"),
  caption: [NPC各模块面积]
)<area>

== IPC

@tbl:ipc 分别显示了单周期无cache处理器，拥有配置为8行，块大小同字长且直接映射缓存的处理器，多周期处理器和流水线处理器的IPC。结合Iron Law，单周期处理器由于所有操作都需要在一个周期内完成，主频较低，所以综合来看其性能较低。表中多周期和流水线数据均为设置在700MHZ下测试，后续将上文主频降低问题修复后即可满足实验设置，故流水线处理器性能较多周期处理器有一定提升。

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),  // 关键行
    inset: 2pt,             // 单元内边距
    stroke: 0.4pt,          // 细一点的框线
    [commit], [说明], [instrs], [cycles], [ipc],
    [256bda1], [no cache], [576664], [26482178], [0.0218],
    [918127d], [81lw_r], [576366], [18921639], [0.0304],
    [43cc50b], [multicycle], [576379], [26967113], [0.0214],
    [18cce88], [pipeline], [576730], [26098354], [0.0221]
    ),
  caption: [IPC],
)<ipc>