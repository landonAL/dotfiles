local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>rv", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>pr", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>ne", function() harpoon:list():next() end)
