-- Hyprland cursor configuration for Anya-cursors
-- https://github.com/Burhanverse/Anya-cursors

-- Set cursor theme and size
hl.env("XCURSOR_PATH", os.getenv("HOME") .. "/.icons")
hl.env("XCURSOR_THEME", "Anya-cursors")
hl.env("XCURSOR_SIZE", "24")

-- Cursor configuration
hl.config({
    cursor = {
        no_hardware_cursors = false,
    }
})

-- Set cursor theme persistently on every boot
hl.on("hyprland.start", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Anya-cursors'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("hyprctl setcursor Anya-cursors 24")
end)
