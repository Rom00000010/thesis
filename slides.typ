#import "@preview/touying:0.6.1": *
#import "dewdrop.typ": *

#import "@preview/numbly:0.1.0": numbly

#show: dewdrop-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title + " - 孙旭栋",
  navigation: "mini-slides",
  mini-slides: (height: 2em, x: 7em, display-section: false, display-subsection: true, short-heading: true),  
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

#outline-slide()

= 绪论

== 概述

*关键词*：#("RISC-V", "处理器", "基础设施", "SoC", "性能评估与优化")

*RISC-V指令集架构*和*电子设计自动化*（EDA）工具的进步为处理器设计领域带来了革命性的改变，本研究进行特定应用集成电路（ASIC）流程的*处理器设计*，搭建配套的*基础设施*和*运行时环境*，并针对嵌入式场景进行*性能评估与优化*，最终进行*硅前验证*，提供了*处理器前端设计全栈*的参考经验。

== 背景

#let subsection(x) = text(size: 26pt, weight: "bold", fill: rgb("#085a7b"), x)
#let small(x) = text(size: 18pt, x)
#let gray(x) = text(fill: white.darken(50%), x)
#let cold(x) = text(fill: rgb("2878b5"), weight: "bold", x)
#let hot(x) = text(fill: rgb("c82423"), weight: "bold", x)

*RISC-V*：

- 模块化指令集 —— #gray[RV32E - RV64GC]
- 设计简洁，简化硬件设计和验证 —— #gray[定长指令，4种指令格式]

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

- 完善指令集架构与系统软件支持

- 量化性能评估与微结构优化

- 敏捷开发

- 功能，时序与面积验证

通过软硬件结合的处理器前端设计实践提供ASIC流程的参考经验与理论依据。