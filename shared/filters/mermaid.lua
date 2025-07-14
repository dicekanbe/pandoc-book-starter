-- Mermaid Filter for Pandoc
-- This filter converts Mermaid code blocks to SVG diagrams

local system = require 'pandoc.system'

-- Counter for unique filenames
local mermaid_counter = 0

-- Function to get current working directory
function get_current_dir()
  local handle = io.popen("pwd")
  local result = handle:read("*a")
  handle:close()
  return result:gsub("\n$", "") -- Remove trailing newline
end

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
      config:write([[{
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage",
    "--disable-gpu",
    "--disable-web-security",
    "--disable-features=IsolateOrigins",
    "--disable-site-isolation-trials"
  ]
}]])
      config:close()
    end
    
    -- Write mermaid code to temporary file
    local file = io.open(tmp_file, "w")
    if file then
      file:write(block.text)
      file:close()
      
      -- Convert mermaid to PNG using mermaid-cli (mmdc)
      local command = string.format("mmdc -i %s -o %s -t neutral -b white -s 3 -w 1200 -H 400 --puppeteerConfigFile %s", tmp_file, png_file, config_file)
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
        
        -- Increment counter for unique filename
        mermaid_counter = mermaid_counter + 1
        local image_filename = string.format("mermaid-%d.png", mermaid_counter)
        
        io.stderr:write("Creating permanent PNG file: " .. image_filename .. "\n")
        
        -- Create a permanent PNG file in the working directory
        local permanent_png = io.open(image_filename, "wb")
        if permanent_png then
          permanent_png:write(png_content)
          permanent_png:close()
          
          -- For LaTeX/PDF, also create image in build directory if needed
          if FORMAT:match 'latex' or FORMAT:match 'pdf' then
            io.stderr:write("Creating image in build directory for LaTeX/PDF\n")
            local build_dirs = {"../build/vol1/ja", "../build/vol1/en"}
            for _, build_dir in ipairs(build_dirs) do
              -- Create build directory if it doesn't exist
              os.execute("mkdir -p " .. build_dir)
              -- Copy image to build directory
              local build_image_path = build_dir .. "/" .. image_filename
              local build_png = io.open(build_image_path, "wb")
              if build_png then
                build_png:write(png_content)
                build_png:close()
                io.stderr:write("Created image at: " .. build_image_path .. "\n")
              end
            end
          end
          
          -- Clean up temporary files
          os.remove(tmp_file)
          os.remove(png_file)
          os.remove(config_file)
          
          io.stderr:write("Returning image element for format: " .. FORMAT .. "\n")
          
          -- Handle different output formats
          if FORMAT:match 'epub' then
            io.stderr:write("Processing for EPUB format\n")
            -- Return as Image element for EPUB
            return pandoc.Para({
              pandoc.Image(
                {pandoc.Str("Mermaid Diagram")}, -- alt text
                image_filename, -- src
                "Mermaid Diagram" -- title
              )
            })
          elseif FORMAT:match 'latex' or FORMAT:match 'pdf' then
            io.stderr:write("Processing for LaTeX/PDF format\n")
            -- For PDF output, use build directory path so LaTeX can find the image
            local build_image_path = "../build/vol1/ja/" .. image_filename
            io.stderr:write("Using build directory path for LaTeX: " .. build_image_path .. "\n")
            
            -- For PDF output, return as Image element that pandoc can convert to \includegraphics
            return pandoc.Para({
              pandoc.Image(
                {pandoc.Str("Mermaid Diagram")}, -- alt text
                build_image_path, -- src (relative to build directory)
                "Mermaid Diagram" -- title
              )
            })
          else
            io.stderr:write("Processing for HTML format\n")
            -- For HTML output, return as Image element
            return pandoc.Para({
              pandoc.Image(
                {pandoc.Str("Mermaid Diagram")}, -- alt text
                image_filename, -- src
                "Mermaid Diagram" -- title
              )
            })
          end
        else
          io.stderr:write("Failed to create permanent PNG file\n")
          -- Clean up temporary files
          os.remove(tmp_file)
          os.remove(png_file)
          os.remove(config_file)
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
    if FORMAT:match 'latex' or FORMAT:match 'pdf' then
      local fallback_content = string.format([[
\begin{quote}
\textbf{Note:} Mermaid diagram (install mermaid-cli to render)
\begin{verbatim}
%s
\end{verbatim}
\end{quote}
]], block.text)
      return pandoc.RawBlock("latex", fallback_content)
    else
      local fallback_content = string.format([[
<div class="mermaid-fallback">
<p><strong>Note:</strong> Mermaid diagram (install mermaid-cli to render)</p>
<pre><code class="language-mermaid">%s</code></pre>
</div>
]], block.text)
      return pandoc.RawBlock("html", fallback_content)
    end
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
