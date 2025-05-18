= 访存模块与SoC环境 

核心内部的ICache和LSU通过Memory Interface进行访存，设备@fig:devices 主要包括顶层模块内的CLINT与SoC上的SRAM,Flash,SDRAM和UART，设备的地址空间映射如@tbl:map 所示。

由于流水线执行过程中多个单元可能会同时访问一个模块（结构冒险），比如通用寄存器组，CSR和内存。所以需要将通用寄存器组和CSR设置为可同时读写，以及使用Arbiter对内存请求进行仲裁，优先完成LSU的请求，阻塞ICache。访存模块中也存在多个从设备，所以需要使用Xbar进行路由，通过组合逻辑将请求直通到对应的从设备来建立访存通路。访存通路的中间模块作为代理master向下一个节点发起请求，并在收到响应后作为slave向上一个节点返回。其中CLINT模块主要用于提供时钟功能，根据处理器主频将计数器的值换算为绝对时间。

  // todo 图中的SOC要修改，字体要参照规范，颜色
  #figure(
    image("/images/memory.svg", width: 65%),
    caption: [
      访存模块
    ]
  )<devices>

  #figure(
    table(
      columns: 2,
      [设备], [地址空间],
      [CLINT], [0x02000000-0x0200ffff],
      [SRAM], [0x0f000000-0x0fffffff],
      [UART16550], [0x10000000-0x10000fff],
      [SPI-master], [0x10001000-0x10001fff],
      [Flash], [0x30000000-0x3fffffff],
      [SDRAM], [0xa0000000-0xbfffffff]
    ),
    caption: [
      地址空间映射
    ]
  )<map>

== SoC环境

将NPC接入ysyxSoC#[@ysyxSoC]，其中主要包含了总线与设备部分，其结构如 @fig:soc 所示。由于不同的设备支持的通信模式不同，故而各设备使用了不同的总线接口，其中包括AXI，APB，SPI，wishbone等总线协议，以SPI总线#[@spi_manual]为例，总线传输时序如 @fig:spi 所示，CS_n为片选信号，表示当前从设备被选中，SCK为时钟信号，MOSI和MISO分别为master和slave的输出信号。

ysyxSoC中通过Frag和Yanker对AXI请求进行预处理，AXI4Xbar上连接了SRAM和AXI到APB的转接桥，并将APB-delayer置于Xbar上方以附加延迟，其余设备均挂在APBXbar上。其中SRAM为AXI接口，作为高速存储器，一个周期即可完成读写，UART为APB接口，用于进行串行输出，SDRAM控制器为APB接口，SPI-master为wishbone接口，flash本身为SPI接口。

  #figure(
    image("/images/spi.svg", width:100%),
    caption: [SPI总线传输时序]
  )<spi>

  #figure(
    image("/images/asic.svg", width:80%, height: 55%),
    caption: [SoC结构]
  )<soc>

== SDRAM

// todo: 字数不够的话详细介绍下

ysyxSoC中使用SRAM和SDRAM作为内存，其中SRAM只有8KB大小，而MT48LC16M16A2镁光颗粒#[@micron]提供了32MB存储空间，基本满足当前的使用需求。ysyxSoC中集成了SDRAM控制器的实现，本文依照设备手册实现了周期级精确的颗粒仿真模型@fig:sdram，具有与控制器兼容的存储结构，支持读写，预充电和激活命令的响应，刷新等操作因涉及电气特性而被设置为空操作。

#figure(
  image("/images/sdram.svg", width: 110%),
  caption: [sdram结构图]
)<sdram>

SDRAM的结构如 @fig:sdram 所示，其存储阵列由4个bank构成，每个bank为$8192 * 512$的存储矩阵，矩阵的每个元素存储了16位的数据，由于SDRAM向外提供的接口与自身的电气特性以及存储阵列组织结构有关，所以控制器需要了解这些特性并与之兼容，从而发出正确的命令进行交互，比如以适当的频率对SDRAM颗粒进行刷新使得数据不会丢失。

在开始使用SDRAM前，需要先设置模式寄存器，以约定突发读写的长度，受到命令后返回数据的延迟周期数等参数。在发起读写命令前，需要先通过激活命令来将一行加载到其所在bank的行缓冲，而后给出列地址进行读写操作，在后续激活相同bank的另一行前需要通过预充电来关闭之前激活的行。

== SPI-master

由于ysyxSoC中集成的Flash使用了SPI总线用以减少数据位宽，所以需要作为从设备挂载到SPI-master上。SPI-master#[@spi_master_manual]通过设备寄存器抽象向CPU提供自身支持的功能，其包含的设备寄存器如@tbl:spi_master 所示，在使用过程中，通常需要先设置DIVIDER为用于时钟分频的除数，而后将SS设置为要选择的设备，通过TxX给出要发送的命令，设置CTRL中的各字段以指定数据发送的字节顺序，使用哪一个时钟边沿等参数后启动传输，并在后续轮询SPI-master是否忙碌，在空闲时返回接受到的数据。

#figure(
  table(
    columns: 2,
    [RxX], [数据接受寄存器],
    [TxX], [数据发送寄存器],
    [CTRL], [控制与状态寄存器],
    [DIVIDER], [时钟分频除数寄存器],
    [SS], [片选寄存器],
  ),
  caption: [SPI-master设备寄存器]
)<spi_master>


== Flash

在ysyxSoC中，使用Flash作为持久存储，在verilator仿真环境中将待执行的程序镜像加载到Flash中，并在运行过程中通过bootloader将对应的程序段加载到其他存储器中提高执行效率。

ysyxSoC中集成了型号为W25Q128JV#[@Flash_manual]的spi-Flash颗粒仿真模型，用于SoC环境下的功能验证。其实际颗粒在ASIC流程中提供了一个轻量化的存储实现，拥有较低的面积和针脚开销的同时也能提供较高的传输速度。

#figure(
  image("/images/flash.svg", width: 100%),
  caption: [
    spi-Flash
  ]
  )<Flash>

flash模块作为从设备连接到上文中的spi-master@fig:Flash，以SCK作为输入时钟，以SS作为片选信号，MOSI和MISO分别是SPI-master和Flash的输出信号。仿真模型中包含了spi从设备状态机，在片选信号有效时根据时钟同步逐周期接受命令，并实现了手册中规定的Read Data(03h)命令，通过DPI-C机制读取Flash数组。

由于启动代码存放在Flash中，所以不能通过软件访问SPI-master的设备寄存器间接访问Flash，需要通过硬件来直接从Flash中取出指令并执行，所以需要通过XIP(Execute in place)模式访问Flash。在收到Flash地址空间访存请求时，使用状态机逐个周期发送SPI-master命令序列，相应的命令与驱动软件类似，在单条指令内通过硬件与SPI-master交互来实现对Flash的访问，取出指令执行。

根据SPI-master手册的规约与寄存器组织@tbl:spi_master，本文实现的XIP状态机如下：

#figure(
  image("/images/xip.svg", width: 100%),
  caption: [XIP状态机]
)

== 访存延迟校正

由于处理器核心与设备的制造工艺差异，在实际芯片运行过程中，核心与外设通常运行在不同的频率下，而使用LID（Latency Insensitive Design）#[@LID]设计范式对模块进行封装，附加通信的外部接口并在互联中加入中间节点可以在保证实现正确性的同时解耦各模块的设计，有利于简化复杂SoC的设计。本文使用的verilator仿真器为单时钟域仿真，处理器核心和外设运行在同一个时钟下，所以为了获得周期级精确（即与真实芯片在近似相同的周期数下完成程序的执行）的模拟，在仿真环境中需要将APBdelayer模块集成到APBXbar的上游用以捕获所有APB请求，先作为代理master与设备完成通信，在等待对应的延迟时间完成后作为slave将数据返还给实际master。

若处理器核心和设备的主频比值为n, 当处理器核心在t0时刻发起APB请求，设备在t1时刻响应时，则APBdelayer需要在满足

#box[$
(t_1-t_0) dot n = t_1^'-t_0
$]
的$t_1^'$时刻向core返回响应。

APBdelayer在初始化/空闲状态下，保持主从设备直通。收到访存请求和事务进行中时逐周期累加计数器，最后在从设备响应的时钟边沿寄存结果，并动态计算延迟周期。进入等待的延迟时间时，暂时拉低从设备的请求和主设备的响应，直到延迟周期结束重新返回响应并开始接受新的请求。