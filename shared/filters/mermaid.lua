-- Mermaid Filter for Pandoc
-- This filter converts Mermaid code blocks to SVG diagrams

local system = require 'pandoc.system'

-- Counter for unique filenames
local mermaid_counter = 0

function CodeBlock(block)
  if block.classes[1] == "mermaid" then
    io.stderr:write("Processing mermaid block\n")
    
    -- Create a temporary file for the mermaid code
    local tmp_file = os.tmpname() .. ".mmd"
    local svg_file = os.tmpname() .. ".svg"
    
    io.stderr:write("Temp files: " .. tmp_file .. ", " .. svg_file .. "\n")
    
    -- Write mermaid code to temporary file
    local file = io.open(tmp_file, "w")
    if file then
      file:write(block.text)
      file:close()
      
      -- Convert mermaid to SVG using mermaid-cli (mmdc)
      local command = string.format("mmdc -i %s -o %s -t neutral -b white", tmp_file, svg_file)
      io.stderr:write("Running command: " .. command .. "\n")
      local success = os.execute(command)
      
      io.stderr:write("Command result: " .. tostring(success) .. "\n")
      io.stderr:write("Output format: " .. FORMAT .. "\n")
      
      -- Check if SVG file was created (more reliable than os.execute return value)
      local svg_file_handle = io.open(svg_file, "r")
      if svg_file_handle then
        local svg_content = svg_file_handle:read("*all")
        svg_file_handle:close()
        
        io.stderr:write("SVG content length: " .. string.len(svg_content) .. "\n")
          
          -- For EPUB, we need to handle SVG differently
          if FORMAT:match 'epub' then
            io.stderr:write("Processing for EPUB format\n")
            -- Increment counter for unique filename
            mermaid_counter = mermaid_counter + 1
            local image_filename = string.format("mermaid-%d.svg", mermaid_counter)
            
            io.stderr:write("Creating permanent SVG file: " .. image_filename .. "\n")
            
            -- Create a permanent SVG file in the working directory
            local permanent_svg = io.open(image_filename, "w")
            if permanent_svg then
              permanent_svg:write(svg_content)
              permanent_svg:close()
              
              -- Clean up temporary files
              os.remove(tmp_file)
              os.remove(svg_file)
              
              io.stderr:write("Returning image element\n")
              
              -- Return as Image element for EPUB
              return pandoc.Para({
                pandoc.Image(
                  {pandoc.Str("Mermaid Diagram")}, -- alt text
                  image_filename, -- src
                  "Mermaid Diagram" -- title
                )
              })
            else
              io.stderr:write("Failed to create permanent SVG file\n")
            end
          else
            io.stderr:write("Processing for HTML format\n")
            -- For HTML output, return as raw SVG
            -- Clean up temporary files
            os.remove(tmp_file)
            os.remove(svg_file)
            
            -- Return the SVG as raw HTML
            return pandoc.RawBlock("html", svg_content)
          end
      else
        io.stderr:write("mmdc command failed\n")
      end
      
      -- Clean up temporary files in case of failure
      os.remove(tmp_file)
      if io.open(svg_file, "r") then
        os.remove(svg_file)
      end
    else
      io.stderr:write("Failed to create temp file\n")
    end
    
    io.stderr:write("Returning fallback content\n")
    
    -- If mermaid-cli is not available, return as a code block with a note
    local fallback_content = string.format([[
<div class="mermaid-fallback">
<p><strong>Note:</strong> Mermaid diagram (install mermaid-cli to render)</p>
<pre><code class="language-mermaid">%s</code></pre>
</div>
]], block.text)
    
    return pandoc.RawBlock("html", fallback_content)
  end
  
  return block
end

-- Alternative function for environments where mermaid-cli might not be available
function render_mermaid_placeholder(code)
  return string.format([[
<div class="mermaid-container">
<div class="mermaid">
%s
</div>
<script>
// Mermaid will be rendered by mermaid.js if loaded
if (typeof mermaid !== 'undefined') {
  mermaid.init();
}
</script>
</div>
]], code)
end

-- For web output, we can include mermaid.js
function Meta(meta)
  if FORMAT:match 'html' then
    local mermaid_script = [[
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>
mermaid.initialize({startOnLoad:true});
</script>
]]
    if meta['header-includes'] then
      table.insert(meta['header-includes'], pandoc.RawInline('html', mermaid_script))
    else
      meta['header-includes'] = {pandoc.RawInline('html', mermaid_script)}
    end
  end
  return meta
end
