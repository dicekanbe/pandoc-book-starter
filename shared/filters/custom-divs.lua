-- custom-divs.lua
-- Pandoc fenced divs を LaTeX 環境に変換するフィルター

function Div(el)
  if FORMAT:match("latex") or FORMAT:match("pdf") then
    -- サポートする環境名のマッピング（jlreqで\noteが予約されているためnoteboxを使用）
    local env_map = {
      note = "notebox",
      warning = "warning",
      tip = "tip"
    }
    
    for class, env_name in pairs(env_map) do
      if el.classes:includes(class) then
        -- 内容をLaTeXに変換
        local content = pandoc.write(pandoc.Pandoc(el.content), "latex")
        -- LaTeX環境で囲む
        local latex = "\\begin{" .. env_name .. "}\n" .. content .. "\\end{" .. env_name .. "}\n"
        return pandoc.RawBlock("latex", latex)
      end
    end
  end
  return el
end
