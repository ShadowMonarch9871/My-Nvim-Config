-- Competitive Programming Setup
vim.api.nvim_create_user_command("CPSetup", function()
    -- Save the current buffer and window numbers
    local original_buffer = vim.api.nvim_get_current_buf()
    local original_window = vim.api.nvim_get_current_win()

    -- Ensure input.in and output.out are created
    local current_dir = vim.fn.expand("%:p:h")
    vim.fn.system("touch " .. current_dir .. "/input.in")
    vim.fn.system("touch " .. current_dir .. "/output.out")

    -- Create the vertical split for input.in on the right side
    vim.cmd("vsplit")
    vim.cmd("wincmd l") -- Move to the new window on the right
    vim.cmd("edit " .. current_dir .. "/input.in")

    -- Create the horizontal split for output.out below
    vim.cmd("split")
    vim.cmd("wincmd j") -- Move to the lower window (output.out)
    vim.cmd("edit " .. current_dir .. "/output.out")

    -- Move back to the original code window
    vim.api.nvim_set_current_win(original_window)

    -- Confirm the setup is complete
    print("CPSetup completed. Use Ctrl+h/j/k/l to navigate between windows.")
end, {})

-- Function to compile and run C++ code
_G.CompileAndRun = function()
    local filename = vim.fn.expand("%:t") -- Get the actual file name (e.g., test.cpp)
    local filepath = vim.fn.expand("%:p:h") -- Get the directory path
    local basename = vim.fn.expand("%:t:r") -- Get the base name without extension

    -- Ensure basename does not resolve to the directory name
    if filename == nil or filename == "" then
        print("No file to compile!")
        return
    end

    -- Correctly determine the output executable name
    local output_name = filepath .. "/" .. basename .. "_exec" -- Use the base name of the file

    -- Save all buffers
    vim.cmd("wa")

    -- Compile with correct file paths
    local compile_cmd = string.format('g++ -std=c++17 -O2 -Wall "%s/%s" -o "%s"', filepath, filename, output_name)

    print("Compiling with command: " .. compile_cmd) -- Debug: Print the compile command
    local compile_output = vim.fn.system(compile_cmd)

    if vim.v.shell_error ~= 0 then
        print("Compilation failed!")
        print(compile_output)
        return
    end

    -- Run
    local run_cmd = string.format('cd "%s" && ./"%s" < input.in > output.out', filepath, basename .. "_exec")
    local run_output = vim.fn.system(run_cmd)

    if vim.v.shell_error ~= 0 then
        print("Runtime error!")
        print(run_output)
        return
    end

    -- Refresh output buffer
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("output.out$") then
            vim.api.nvim_set_current_win(win)
            vim.cmd("e!")
            vim.cmd("normal! G")
            break
        end
    end

    print("Compilation and execution completed. Output written to output.out")
end

-- Key mapping to compile and run
vim.api.nvim_set_keymap("n", "<F5>", ":lua _G.CompileAndRun()<CR>", { noremap = true, silent = true })

-- Function to switch between windows
_G.SwitchWindow = function(direction)
    vim.cmd("wincmd " .. direction)
end

-- Key mappings to switch between windows
vim.api.nvim_set_keymap("n", "<C-h>", ':lua _G.SwitchWindow("h")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ':lua _G.SwitchWindow("j")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ':lua _G.SwitchWindow("k")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ':lua _G.SwitchWindow("l")<CR>', { noremap = true, silent = true })

-- Print a message to confirm the setup is loaded
print("C++ Competitive Programming setup loaded successfully!")
