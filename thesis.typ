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
    当今正处于体系结构的新黄金年代，RISC-V指令集架构的诞生为处理器设计领域提供了革命性的新范式，现代电子设计自动化（Electronic design automation，EDA）工具的进步也重新定义了处理器设计的方法论，使得敏捷开发成为可能。由于在学术界，工业界，社区以及其他相关工作多关注高性能计算处理器，闭源商业处理器，以及FPGA流程处理器的设计与验证，缺少ASIC流程嵌入式处理器的设计，验证以及相关的量化研究思路整合。

    因此本文的主要工作为：基于开源工具链进行ASIC流程处理器核心设计，并将其接入开源的片上系统（System on Chip, SoC），实现SoC中的关键设备仿真模型，在配套的基础设施与运行时环境下进行流片前的全系统功能验证。并针对嵌入式场景优化微体系结构，量化评估优化效果，对时序，面积与性能进行权衡。通过处理器系统实现提供全流程的参考经验，并对嵌入式场景下体系结构优化的量化研究思路进行整合。

    本文通过软件仿真对设计的处理器核以及SoC平台进行了测试。经测试，处理器核与SoC平台功能设计正确，可以正确执行官方指令测试集并启动RT-Thread操作系统，最终面积为26710.39$mu m^2$，优化后综合主频为500MHz，每周期完成指令数（Instructions Per Cycle，IPC）为0.022。
  ]

  // 英文摘要
  #abstract-en(
    keywords: ("RISC-V", "Processor", "Infrastructure", "SoC", "performance evaluation", "optimization")
  )[
    We are currently experiencing a new golden age in computer architecture. The emergence of the RISC-V instruction set architecture has introduced a revolutionary new paradigm to the processor design field, while advancements in modern Electronic Design Automation (EDA) tools have reshaped the methodologies for processor design, making agile development feasible. However, much attention from academia, industry, and communities has been concentrated on the design and verification of high-performance computing processors, closed-source commercial processors, and FPGA-based processors, leading to a lack of integrated design, verification, and quantitative research methodologies specifically for ASIC-based embedded processors.

    Therefore, the primary contributions of this paper are: designing an ASIC-based processor core using an open-source toolchain, integrating it into an open-source System on Chip (SoC), implementing simulation modules for key SoC components, and conducting comprehensive pre-tape-out functional verification in a supporting infrastructure and runtime environment. Additionally, this paper optimizes the microarchitecture specifically for embedded scenarios, quantitatively evaluates optimization outcomes, and balances timing, area, and performance metrics. It provides a complete processor system implementation as a reference and integrates quantitative research methodologies for architecture optimization in embedded scenarios.

    Through software simulations, the designed processor core and SoC platform have been thoroughly tested. The testing results demonstrate that the functional design of the processor core and SoC platform is correct. The system successfully executes the official instruction test suite and boots the RT-Thread operating system. The final processor area is 26710.39 µm², achieving an optimized synthesis frequency of 500MHz and an Instructions Per Cycle (IPC) of 0.022.

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

  #set list(indent: 2em)
  #set enum(indent: 2em)

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