-- Auto ID Filter for Pandoc
-- This filter automatically adds IDs to headers for cross-referencing



function Div(elem)
  -- Add special handling for div elements with specific classes
  if elem.classes:includes("note") or elem.classes:includes("warning") or elem.classes:includes("tip") then
    if elem.identifier == "" then
      -- Generate ID for special div blocks
      local class_name = elem.classes[1]
      local id = class_name .. "-" .. math.random(1000, 9999)
      elem.identifier = id
    end
  end
  return elem
end

function CodeBlock(elem)
  -- Add language class for syntax highlighting
  if elem.classes and #elem.classes > 0 then
    local lang = elem.classes[1]
    elem.attributes["data-language"] = lang
  end
  return elem
end

-- Add table of contents support
function pandoc.Meta(meta)
  if meta.toc == nil then
    meta.toc = true
  end
  return meta
end
