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
    local png_file = os.tmpname() .. ".png"
    local config_file = os.tmpname() .. ".json"
    
    io.stderr:write("Temp files: " .. tmp_file .. ", " .. png_file .. "\n")
    
    -- Create puppeteer config file
    local config = io.open(config_file, "w")
    if config then
      config:write('{"args": ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--disable-gpu"]}')
      config:close()
    end
    
    -- Write mermaid code to temporary file
    local file = io.open(tmp_file, "w")
    if file then
      file:write(block.text)
      file:close()
      
      -- Convert mermaid to PNG using mermaid-cli (mmdc)
      local command = string.format("mmdc -i %s -o %s -t neutral -b white --puppeteerConfigFile %s", tmp_file, png_file, config_file)
      io.stderr:write("Running command: " .. command .. "\n")
      local success = os.execute(command)
      
      io.stderr:write("Command result: " .. tostring(success) .. "\n")
      io.stderr:write("Output format: " .. FORMAT .. "\n")
      
      -- Check if PNG file was created (more reliable than os.execute return value)
      local png_file_handle = io.open(png_file, "rb")
      if png_file_handle then
        local png_content = png_file_handle:read("*all")
        png_file_handle:close()
        
        io.stderr:write("PNG content length: " .. string.len(png_content) .. "\n")
          
          -- For EPUB, we need to handle PNG differently
          if FORMAT:match 'epub' then
            io.stderr:write("Processing for EPUB format\n")
            -- Increment counter for unique filename
            mermaid_counter = mermaid_counter + 1
            local image_filename = string.format("mermaid-%d.png", mermaid_counter)
            
            io.stderr:write("Creating permanent PNG file: " .. image_filename .. "\n")
            
            -- Create a permanent PNG file in the working directory
            local permanent_png = io.open(image_filename, "wb")
            if permanent_png then
              permanent_png:write(png_content)
              permanent_png:close()
              
              -- Clean up temporary files
              os.remove(tmp_file)
              os.remove(png_file)
              os.remove(config_file)
              
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
              io.stderr:write("Failed to create permanent PNG file\n")
            end
          else
            io.stderr:write("Processing for HTML format\n")
            -- For HTML output, create a permanent PNG file and return as image
            -- Increment counter for unique filename
            mermaid_counter = mermaid_counter + 1
            local image_filename = string.format("mermaid-%d.png", mermaid_counter)
            
            io.stderr:write("Creating permanent PNG file: " .. image_filename .. "\n")
            
            -- Create a permanent PNG file in the working directory
            local permanent_png = io.open(image_filename, "wb")
            if permanent_png then
              permanent_png:write(png_content)
              permanent_png:close()
              
              -- Clean up temporary files
              os.remove(tmp_file)
              os.remove(png_file)
              os.remove(config_file)
              
              -- Return as Image element for HTML
              return pandoc.Para({
                pandoc.Image(
                  {pandoc.Str("Mermaid Diagram")}, -- alt text
                  image_filename, -- src
                  "Mermaid Diagram" -- title
                )
              })
            else
              io.stderr:write("Failed to create permanent PNG file\n")
              -- Clean up temporary files
              os.remove(tmp_file)
              os.remove(png_file)
              os.remove(config_file)
            end
          end
      else
        io.stderr:write("mmdc command failed\n")
      end
      
      -- Clean up temporary files in case of failure
      os.remove(tmp_file)
      if io.open(png_file, "rb") then
        os.remove(png_file)
      end
      os.remove(config_file)
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
