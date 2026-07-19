--- number-figures.lua
-- 図番号を自動付与する Pandoc Lua フィルタ
-- キャプション付き画像（![キャプション](img/example.png)）から Pandoc が生成する
-- Figure 要素のキャプション先頭に「図1-1: 」を前置する。
-- Figure 構造はそのまま保持するため、EPUB では epub.css の figure/figcaption
-- スタイルが適用され、alt テキストや ID も失われない。
--
-- 章の追跡は number-chapter.lua と同じルール:
--   level-1 Header で章番号をカウントし、unnumbered クラスの章はスキップ
--   （unnumbered-class メタデータで変更可能）
--
-- PDF (LaTeX) では \caption が既定で「図 N:」ラベルを付けるため、
-- header-includes 側で \captionsetup{labelformat=empty} を指定して抑止すること。
--
-- 使い方:
--   pandoc --lua-filter=number-figures.lua ...

local chapter_counter = 0
local figure_counter = 0
local in_unnumbered_chapter = false

local opts = {
  skip_cls = "unnumbered",
  format = "Figure %d-%d: ",
}

-- 言語別の設定（number-chapter.lua と同じ方式）
local lang_formats = {
  ja = "図%d-%d: ",
  en = "Figure %d-%d: ",
}

function Meta(meta)
  local function get_meta_value(key)
    if meta[key] then
      return pandoc.utils.stringify(meta[key])
    end
    return nil
  end

  local lang = get_meta_value("lang") or "en"
  opts.format = lang_formats[lang] or lang_formats.en

  local skip_cls = get_meta_value("unnumbered-class")
  if skip_cls then opts.skip_cls = skip_cls end
end

local function Header(el)
  if el.level ~= 1 then return nil end

  if el.classes:includes(opts.skip_cls) then
    in_unnumbered_chapter = true
  else
    in_unnumbered_chapter = false
    chapter_counter = chapter_counter + 1
    figure_counter = 0
  end
  return nil
end

local function Figure(el)
  if in_unnumbered_chapter then return nil end

  figure_counter = figure_counter + 1
  local prefix = string.format(opts.format, chapter_counter, figure_counter)

  local long = el.caption.long
  if long and #long > 0 and long[1].content then
    table.insert(long[1].content, 1, pandoc.Str(prefix))
  else
    el.caption.long = {pandoc.Plain({pandoc.Str(prefix)})}
  end
  return el
end

return {
  { Meta = Meta },
  -- topdown: 文書順に走査するため、fenced div 内の Figure も
  -- 正しい章カウンターの状態で処理される
  { traverse = "topdown", Header = Header, Figure = Figure },
}
