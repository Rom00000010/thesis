  #import "@preview/modern-nju-thesis:0.4.0": documentclass, 字号

  #let (
    // 布局函数
    twoside, fonts, doc, preface, mainmatter, appendix,
    // 页面函数
    fonts-display-page, cover, decl-page, abstract, abstract-en, bilingual-bibliography,
    outline-page, list-of-figures, list-of-tables, notation, acknowledgement,
  ) = documentclass(
    // doctype: "bachelor",  // "bachelor" | "master" | "doctor" | "postdoc", 文档类型，默认为本科生 bachelor
    // degree: "academic",  // "academic" | "professional", 学位类型，默认为学术型 academic
    // anonymous: true,  // 盲审模式
    twoside: true,  // 双面模式，会加入空白页，便于打印
    // 你会发现 Typst 有许多警告，这是因为 modern-nju-thesis 加入了很多不必要的 fallback 字体
    // 你可以自定义字体消除警告，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
    // fonts: (楷体: (name: "Times New Roman", covers: "latin-in-cjk"), "FZKai-Z03S")),
    info: (
      title: ("基于RISC-V的", "32位处理器设计"),
      title-en: "Design and Implementation of 32-bit RISC-V Processor",
      grade: "2021",
      student-id: "211220042",
      author: "孙旭栋",
      author-en: "Xudong Sun",
      department: "计算机学院",
      department-en: "School of Computer Science",
      major: "计算机科学与技术",
      major-en: "Computer Science and Technology",
      supervisor: ("蒋炎岩", " 副教授"),
      supervisor-en: "Associate Professor Yanyan Jiang",
      // supervisor-ii: ("王五", "副教授"),
      // supervisor-ii-en: "Professor My Supervisor",
      submit-date: datetime.today(),
    ),
    // 参考文献源
    bibliography: bibliography.with("ref.bib"),
  )

  #let font-name = context text.font.first().name

  // 文稿设置
  #show: doc

  // 字体展示测试页
  // #fonts-display-page()

  // 封面页
  #cover()

  // 声明页
  #decl-page()

  // 前言
  #show: preface

  // 中文摘要
  #abstract(
    keywords: ("RISC-V", "处理器", "基础设施", "SoC", "性能评估与优化")
  )[
    当今正处于体系结构的新黄金年代，RISC-V指令集架构的诞生为处理器设计领域提供了革命性的新范式，现代电子设计自动化（Electronic design automation，EDA）工具的进步也重新定义了处理器设计的方法论，使得敏捷开发成为可能。本文意图在技术实践上通过多种验证方式，实现功能-时序的联合验证，构建完整的验证链。探索敏捷开发方法，提供可复用的技术方案；在系统完善层面针对嵌入式场景优化微体系结构，量化评估优化效果。实现完善的指令集架构与系统软件的支持，使用复杂的软件如操作系统进行验证；在学科能力整合与社区反哺方面将创新特性与工具探索反馈至社区，形成教学设计-学生实践-社区迭代的正向循环。并通过软硬件结合的全栈处理器设计实践，提供全流程的参考经验。

    本文基于RISC-V指令集架构，设计了一款支持RV32E指令集的处理器，搭建了配套的基础设施以提高处理器设计与验证的效率，接入片上系统（System on Chip，SoC）环境并编写了配套的运行时环境以支撑程序的运行，在类似流片的SoC环境下对处理器进行了量化的性能分析与微体系结构优化，并针对嵌入式场景对处理器的面积与时序进行了优化。

    本文通过软件仿真对设计的处理器核以及SoC平台进行了测试。经测试，处理器核与SoC平台功能设计正确，可以正确执行官方指令测试集并启动RT-Thread操作系统，最终面积为26710.39$mu m^2$，优化后综合主频为500MHz，每周期完成指令数（Instructions Per Cycle，IPC）为0.022。
  ]

  // 英文摘要
  #abstract-en(
    keywords: ("RISC-V", "Processor", "Infrastructure", "SoC", "performance evaluation", "optimization")
  )[
    Today, we are experiencing a new golden era in computer architecture. The emergence of the RISC-V Instruction Set Architecture (ISA) has provided a revolutionary new paradigm in processor design. Simultaneously, advancements in modern Electronic Design Automation (EDA) tools have redefined processor design methodologies, enabling agile development. This thesis aims to practically achieve functional-timing co-verification through various verification methods, constructing a comprehensive verification chain. It explores agile development methodologies to offer reusable technical solutions and optimizes micro-architectures specifically for embedded scenarios, quantitatively evaluating the effectiveness of such optimizations. The research also achieves comprehensive support for instruction set architectures and system software, validating the design using complex software such as operating systems. Additionally, the study contributes innovative features and tools back into the community, creating a positive cycle of educational design, student practice, and community iteration. Furthermore, it provides a reference experience covering the entire process through full-stack processor design integrating hardware and software.

    Based on the RISC-V ISA, this thesis presents a processor designed to support the RV32E instruction set, establishing supporting infrastructure to enhance the efficiency of processor design and verification. It integrates the processor into a System on Chip (SoC) environment, develops the corresponding runtime environment for program execution, and performs quantified performance analysis and micro-architecture optimization within an SoC environment akin to tape-out. Optimizations for embedded applications specifically target area and timing performance.

    Through software simulation, both the designed processor core and the SoC platform were tested. Results indicate the correctness of the processor core and the SoC platform, successfully executing the official instruction test suite and booting the RT-Thread operating system. The final area of the processor core is 26710.39$mu m^2$, with an optimized synthesized main frequency of 500 MHz and an Instructions Per Cycle (IPC) rate of 0.022.
  ]


  // 目录
  #outline-page()

  // 插图目录
  // #list-of-figures()

  // 表格目录
  // #list-of-tables()

  #show: u => {
    mainmatter(
    heading-size: (14pt, 14pt, 12pt),
    heading-font: (fonts.黑体, fonts.黑体, fonts.宋体),
    heading-weight: ("regular", "regular", "bold"),
    u,
    );
  }

  // 正文
  #show: mainmatter

  #include("/chapters/chap1.typ")
  #include("/chapters/chap2.typ")
  #include("/chapters/chap3.typ")
    #if twoside {
    pagebreak() + " "
  }
  #include("/chapters/chap4.typ")
  #include("/chapters/chap5.typ")
    #if twoside {
    pagebreak() + " "
  }
  #include("/chapters/chap6.typ")
    #if twoside {
    pagebreak() + " "
  }
  #include("/chapters/chap7.typ")
  



  // 中英双语参考文献
  // 默认使用 gb-7714-2015-numeric 样式
  #bilingual-bibliography(full: true)

  // 致谢
  #acknowledgement[
    感谢蒋炎岩老师在我完成毕业论文过程中的鼓励和指导，以及他的《操作系统》课，让我看到了计科中有意思的，自己感兴趣的地方，如叶慈所说：“教育不是注满一桶水，而是点燃一把火”。

    感谢一生一芯团队开源的丰富学习资源，组内同学和老师的热心交流与帮助，让我能站在巨人的肩膀上学习，能有志同道合的同学一起讨论。

    生活中除了学习还有很多有趣的事情，感谢最后一个学期我看过听过的书影音，和我一起运动，吃饭，聊天的朋友们以及每一个好天气，每一株小树一朵小花一颗小草，他们的存在令我感到安心。

    我在NJU做普通人，感谢NJU带给我的一切。
  ]