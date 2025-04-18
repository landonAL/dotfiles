require('rose-pine').setup({
    disable_background = true,

    styles = {
        bold = false,
        italic = false
    }
})

function theme(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

theme()
