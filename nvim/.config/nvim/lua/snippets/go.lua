local ls = require("luasnip")
local extras = require("luasnip.extras")
local f = require("luasnip.extras.fmt")
require("luasnip.session.snippet_collection").clear_snippets("go")
local rep = extras.rep
local fmt = f.fmt
local fmta = f.fmta
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
  -- TODO: get fancier one - https://youtu.be/KtQZRAkgLqo?si=rItnlZy3BTcO6dQ3&t=1350
  -- make it log an error or return or whatever based on text_node
  s(
    "ife",
    fmta(
      [[
    if <> != nil {
      return <>
    }
      ]],
      {
        c(1, { t("err"), t(""), t("ok") }), -- Make it start empty
        rep(1),
      }
    )
  ),

  s("ifel", {
    t({ "if err != nil {", "    log.Fatal(err)", "}", "" }),
    i(0),
  }),

  s(
    "empty?",
    fmta(
      [[
    if len(<>) == 0 {
        <>
    }
    ]],
      { i(1), i(2) }
    )
  ),

  s(
    "p",
    fmt(
      [[
    fmt.Printf("{}\n", {})
    {}
    ]],
      { i(1, "%v"), i(2), i(0) }
    )
  ),

  s(
    "fp",
    fmt(
      [[
    fmt.Fprintf({}, "{}\n", {})
    {}
    ]],
      { i(1), i(2), i(3), i(0) }
    )
  ),

  s(
    "pl",
    fmt(
      [[
    fmt.Println("{}")
    {}
    ]],
      { i(1), i(0) }
    )
  ),

  s(
    "pd",
    fmt(
      [[
    fmt.Println("+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+")
    {}
    ]],
      { i(0) }
    )
  ),


  s(
    "ifew",
    fmta(
      [[
    if err != nil {
        return fmt.Errorf("Failed to <>: %w\n", err)
    }
    <>
    ]],
      { i(1), i(0) }
    )
  ),

  s(
    "fs",
    fmta(
      [[
    for {
        select {
            case <>: {
                <>
            }
            case <>: {
                <>
            }
        }
    }
    ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
}
-- detect clipboard contents, if certain prefix paste into import
