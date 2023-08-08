return {
    format_on_save = {
        enabled = true,
        filter = function(bufnr)
            -- Get the file extension
            local file_extension = vim.fn.expand('%:e')

            -- Check if it's a Solidity file
            if file_extension == 'sol' then
                -- Construct the command with the current file path
                local format_command = string.format("forge fmt -- --path %s", vim.fn.expand('%:p'))

                vim.fn.jobstart(format_command, {
                    cwd = vim.fn.expand('%:p:h'),
                    on_exit = function(_, exit_code)
                        if exit_code == 0 then
                            vim.api.nvim_out_write("Formatting completed successfully.\n")

                            -- Refresh the buffer to show the updated content
                            vim.api.nvim_buf_call(bufnr, function()
                                vim.api.nvim_command('checktime')
                            end)
                        else
                            vim.api.nvim_err_writeln("Formatting encountered an error.")
                        end
                    end,
                })
                return false -- Never format on save for Solidity files
            end

            return true -- Do not format on save for other files
        end
    }
}
