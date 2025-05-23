#show: u => mainmatter(
  u,
  heading-size: (14pt, 14pt, 12pt),
  heading-font: (字体.黑体, 字体.黑体, 字体.宋体),
  heading-weight: ("regular", "regular", "bold"),
)

#set list(indent: 2em)
#set enum(indent: 2em)

#show heading.where(level: 2): set heading(numbering: (..nums) => numbering("（一）", nums.at(1)))

#show heading.where(level: 3): set heading(numbering: (..nums) => numbering("1.", nums.at(2)))