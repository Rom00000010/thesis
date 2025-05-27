= 实验结果与分析

本章主要对处理器进行功能正确性的验证，具体来说包含指令实现的测试与操作系统程序的运行。并进行面积与性能数据的测量。

== 功能验证

移植到AM中的官方指令测试集#[@riscv-tests]包含了每条指令单独的测试程序，包括整数计算指令，内存加载存储指令和控制流转移指令等，可以看到处理器在各指令上实现正确。



#figure(
  image("../images/instr_test.png"),
  caption: [risv-tests-am]
)<instr_test>

操作系统程序较为复杂，可以综合检验处理器指令集功能的实现（包括指令，特权架构状态等），外设是否能够正确访问，@fig:rtt 为在NPC中启动RT-Thread操作系统。

#figure(
  image("../images/rtt.png", width: 95%),
  caption: [RT-Thread]
)<rtt>


== 时序与面积

流水线的分支预测错误冲刷实现使得主频由700MHz降低为500MHz，但通过适当处理可以恢复主频。由于流水线处理器中需要进行冒险处理，在EXU检测出控制冒险需要冲刷流水线时，需要将冲刷（flush）信号传递给其他流水段/功能单元，当前方案为在检测出冒险的同周期进行冲刷，增加了关键路径的延迟，使得主频降低为约500MHZ，面积报告如@tbl:timing。后续可以优化为在时钟周期边沿先寄存flush信号，在下一个周期再进行冲刷，从而以寄存器为分割点将关键路径分开，减少关键路径的延迟，从而更好的满足时序逻辑电路建立与保持时间的要求。

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

处理器最终总面积为26710.39$mu m^2$，流水线只需要很少的寄存器和部分组合逻辑，面积开销较小，整体面积与多周期处理器相差不大，各模块面积如@fig:area。

// todo: picture name, bar discription

#figure(
  image("../images/core_area.png"),
  caption: [NPC各模块面积]
)<area>

== IPC与性能

@tbl:ipc 分别显示了多周期处理器和流水线处理器两种配置的IPC。其均设置为运行在700MHz下，后续将上文主频降低问题修复后即可满足实验设置。结合Iron Law@eqt:ironlaw，两者拥有相同的主频但流水线处理器拥有更高的IPC，故而性能有所提升，但由于流水线中冒险的存在，仍有许多优化空间，具体在第七章中进行分析。


#figure(
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),  // 关键行
    stroke: none,
    table.hline(),
    [commit], [说明], [instrs], [cycles], [ipc],
    table.hline(),
    [43cc50b], [multicycle], [576379], [26967113], [0.021],
    [18cce88], [pipeline], [576730], [26098354], [0.022],
    table.hline(),
    ),
  caption: [IPC],
)<ipc>