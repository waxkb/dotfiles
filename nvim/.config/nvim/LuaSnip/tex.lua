local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

return {
  s({trig="temp", wordTrig=false},
    fmta(
      [[
        \documentclass{article}

        \usepackage{amsmath,amssymb,amsthm}
        \usepackage[margin=1in]{geometry}
        \usepackage{thmtools}
        \usepackage{tikz}
        \usepackage{tikz-cd}

        \newcommand\N{\ensuremath{\mathbb{N}}}
        \newcommand\R{\ensuremath{\mathbb{R}}}
        \newcommand\Z{\ensuremath{\mathbb{Z}}}
        \renewcommand\O{\ensuremath{\emptyset}}
        \newcommand\Q{\ensuremath{\mathbb{Q}}}
        \newcommand\C{\ensuremath{\mathbb{C}}}

        \usepackage[framemethod=TikZ]{mdframed}
        \mdfsetup{skipabove=0.5em,skipbelow=0em, innertopmargin=5pt, innerbottommargin=6pt, linewidth=0.7pt}

        \declaretheoremstyle[
            bodyfont=\normalfont,
            numbered=yes,
            numberwithin=section,
            mdframed={}
        ]{masterstyle}

        \declaretheorem[style=masterstyle, name=Theorem]{theorem}
        \declaretheorem[style=masterstyle, name=Definition]{definition}
        \declaretheorem[style=masterstyle, name=Note]{note}


        \title{E}
        \author{E}
        \date{}

        \begin{document}
        \section{<>}

        <>

        \end{document}
      ]],
      { i(1, "Section"), i(0)}
    )
  ),
  s({trig="beg", snippetType="autosnippet"},
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      { i(1), i(0), rep(1) }
    )
  ),
  s({trig="mk", snippetType="autosnippet"},
    fmta(
      [[
        $<>$ <>
      ]],
      { i(1), i(0) }
    )
  ),
  s({trig="//", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        \frac{<>}{<>}<>
      ]],
      { i(1), i(2), i(3)}
    )
  ),
  s({trig="dm", snippetType="autosnippet"},
    fmta(
      [[
        \begin{align*}
          <>
        \end{align*}
        <>
      ]],
      { i(1), i(0)}
    )
  ),
  s({trig="([%a])([%d])", regTrig=true, wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        <>_<><>
      ]],
      { f( function(_, snip) return snip.captures[1] end ), f( function(_, snip) return snip.captures[2] end ), i(0)}
    )
  ),
  s({trig="sb", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        _{<>}<>
      ]],
      { i(1), i(0)}
    )
  ),
  s({trig="sd", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    t("^2")
  ),
  s({trig="cd", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    t("^3")
  ),
  s({trig="tt", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        ^{<>}<>
      ]],
      { i(1), i(0)}
    )
  ),
  s({trig="rt", wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        \sqrt{<>}<>
      ]],
      { i(1), i(0)}
    )
  ),
  s({trig="([%a])hat", regTrig=true, wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        \hat{<>}<>
      ]],
      { f( function(_, snip) return snip.captures[1] end ), i(0)}
    )
  ),
  s({trig="([%a])([.,]+)", regTrig=true, wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
    fmta(
      [[
        \vec{<>}<>
      ]],
      { f( function(_, snip) return snip.captures[1] end ), i(0)}
    )
  )
}
