--- number-chapter.lua
-- 章番号を自動付与する Pandoc Lua フィルタ
-- 使い方:
--   pandoc --lua-filter=number-chapter.lua src/*.md -o book.epub
-- オプション（メタデータ）:
--   chapter-prefix   : "第"   （既定値）
--   chapter-suffix   : "章 "  （既定値）
--   chapter-start    : 1      （既定値; 0 から始めたい場合などに）
--   unnumbered-class : "unnumbered"  （見出しに付いていればスキップ）
--
-- 注意: PDF/LaTeX出力時は番号付けをスキップ（LaTeX側で管理するため）

-- PDF/LaTeX出力かどうかを判定
local is_latex_output = FORMAT:match("latex") or FORMAT:match("pdf") or FORMAT:match("beamer")

local chapter_counter = 0
local section_counter = {}
local in_unnumbered_chapter = false  -- 番号なし章内かどうかのフラグ
local opts = {
  start    = 1,
  skip_cls = "unnumbered",
  prefix   = "Chapter ",      -- デフォルト値
  suffix   = " ",             -- デフォルト値
}

-- 言語別の設定
local lang_opts = {
  ja = {
    prefix = "第",
    suffix = "章 "
  },
  en = {
    prefix = "Chapter ",
    suffix = " "
  }
}

-- ファイル毎のメタデータを格納
local current_file_opts = {}

-- メタデータからオプションを取得（グローバル設定のみ）
function Meta(meta)
  -- メタデータの値を取得（文字列に変換）
  local function get_meta_value(key)
    if meta[key] then
      -- デバッグ出力
      -- print("Getting meta value for " .. key .. ": type=" .. (meta[key].t or "unknown"))
      
      if meta[key].t == "MetaString" then
        return meta[key].text
      elseif meta[key].t == "MetaInlines" then
        return pandoc.utils.stringify(meta[key])
      elseif meta[key].t == "MetaBlocks" then
        return pandoc.utils.stringify(meta[key])
      else
        -- 他の型の場合はstringifyを試す
        return pandoc.utils.stringify(meta[key])
      end
    end
    return nil
  end

  -- 言語設定を取得
  local lang = get_meta_value("lang") or "en"  -- デフォルトは英語
  
  -- 言語に応じた設定を適用
  if lang_opts[lang] then
    opts.prefix = lang_opts[lang].prefix
    opts.suffix = lang_opts[lang].suffix
  else
    -- 未対応の言語の場合は英語設定を使用
    opts.prefix = lang_opts.en.prefix
    opts.suffix = lang_opts.en.suffix
  end

  -- 各オプションを取得（メタデータで明示的に指定されている場合は上書き）
  local prefix = get_meta_value("chapter-prefix")
  if prefix then opts.prefix = prefix end

  local suffix = get_meta_value("chapter-suffix")
  if suffix then opts.suffix = suffix end

  -- chapter-start設定は無視して、単純にunnumberedでない章を順番にカウント
  -- local start = get_meta_value("chapter-start")
  -- if start then 
  --   local start_num = tonumber(start)
  --   if start_num then
  --     -- chapter-startが指定された場合、章カウンターをリセット
  --     chapter_counter = start_num - 1
  --     opts.start = 1  -- 計算式を簡単にするため
  --   end
  -- end

  local skip_cls = get_meta_value("unnumbered-class")
  if skip_cls then opts.skip_cls = skip_cls end
  
  -- デバッグ用（必要に応じてコメントアウト）
  -- print("Meta processed: lang=" .. lang .. ", prefix=" .. opts.prefix .. ", suffix=" .. opts.suffix .. ", start=" .. opts.start)
end

-- Header ブロックを変換
function Header(el)
  -- PDF/LaTeX出力時は番号付けをスキップ（LaTeX側で管理）
  if is_latex_output then
    return el
  end

  -- レベル 1〜3 を対象にしたい場合
  if el.level > 3 then return nil end

  -- レベル1の場合、unnumberedフラグを更新
  if el.level == 1 then
    if el.classes:includes(opts.skip_cls) then
      in_unnumbered_chapter = true
      -- print("Unnumbered chapter found: " .. pandoc.utils.stringify(el.content))
      return el  -- 番号なし章なので、元の見出しをそのまま返す
    else
      in_unnumbered_chapter = false
      -- unnumberedでない章のみカウンターを増加
      chapter_counter = chapter_counter + 1
      -- print("Numbered chapter found: " .. pandoc.utils.stringify(el.content) .. ", counter=" .. chapter_counter)
      -- 章が変わったら節カウンターをリセット
      section_counter = {}
    end
  end

  -- 番号なし章内の場合、すべての見出しをスキップ
  if in_unnumbered_chapter then
    return el
  end

  -- 個別の見出しに「unnumbered」クラスがあればスキップ
  if el.classes:includes(opts.skip_cls) then return el end

  -- 節番号の更新
  section_counter[el.level] = (section_counter[el.level] or 0) + 1
  -- 下位レベルはリセット
  for i = el.level + 1, 6 do section_counter[i] = 0 end

  local label
  if el.level == 1 then
    local chapter_num = chapter_counter
    local prefix = opts.prefix or "Chapter "
    local suffix = opts.suffix or " "
    -- print("Header processing: prefix='" .. prefix .. "', suffix='" .. suffix .. "', chapter_num=" .. chapter_num .. ", title=" .. pandoc.utils.stringify(el.content))
    label = string.format("%s%d%s", prefix, chapter_num, suffix)
  elseif el.level == 2 then
    -- 「第1.2節」のように章番号.節番号形式
    local chapter_num = chapter_counter
    label = string.format("%d.%d ", chapter_num, section_counter[2])
  elseif el.level == 3 then
    -- 「第1.2.3項」のように章番号.節番号.項番号形式
    local chapter_num = chapter_counter
    label = string.format("%d.%d.%d ", chapter_num, section_counter[2], section_counter[3])
  end

  table.insert(el.content, 1, pandoc.Str(label))
  return el
end

-- フィルタの実行順序を制御: Metaを先に実行してからHeaderを実行
return {
  { Meta = Meta },
  { Header = Header }
}
