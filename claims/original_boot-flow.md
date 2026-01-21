init [4] (PID 1)
  └── xdm
        └── startx -- -nolisten tcp vt7
              └── xinit /etc/X11/xinit/xinitrc
                    └── openbox --startup /usr/libexec/openbox-autostart
                          └── /etc/xdg/openbox/autostart
                                ├── Checks /opt/scripts/first-run
                                └── su -c /opt/scripts/first-run
                                      └── [COMPILED ELF BINARY - 44392 bytes]
                                            └── /opt/scripts/welcome (shell script)
                                                  └── gtkdialog -i wizard-functions
