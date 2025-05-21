  #import "@preview/modern-nju-thesis:0.4.0": documentclass

  #let (
    // 布局函数
    twoside, doc, preface, mainmatter, appendix,
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
      supervisor: ("蒋炎岩", "副教授"),
      supervisor-en: "Associate Professor Yanyan Jiang",
      // supervisor-ii: ("王五", "副教授"),
      // supervisor-ii-en: "Professor My Supervisor",
      submit-date: datetime.today(),
    ),
    // 参考文献源
    bibliography: bibliography.with("ref.bib"),
  )

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
    keywords: ("我", "就是", "测试用", "关键词")
  )[
    中文摘要
  ]

  // 英文摘要
  #abstract-en(
    keywords: ("Dummy", "Keywords", "Here", "It Is")
  )[
    English abstract
  ]


  // 目录
  #outline-page()

  // 插图目录
  // #list-of-figures()

  // 表格目录
  // #list-of-tables()

  // 正文
  #show: mainmatter

  #include("/chapters/chap2.typ")
  #include("/chapters/chap3.typ")
  #include("/chapters/chap4.typ")
  #include("/chapters/chap5.typ")
  #include("/chapters/chap6.typ")
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