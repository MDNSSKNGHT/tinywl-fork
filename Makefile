#
# tinywl
#
WAYLAND_PROTOCOLS	=	$(shell pkg-config --variable=pkgdatadir wayland-protocols)
WAYLAND_SCANNER		=	$(shell pkg-config --variable=wayland_scanner wayland-scanner)
# Comment if you don't want to build with Xwayland support.
XWAYLAND			=	-DXWAYLAND
CFLAGS				=	-g -Werror -I. -DWLR_USE_UNSTABLE
LIBS				=	\
		$(shell pkg-config --cflags --libs libinput)		\
		$(shell pkg-config --cflags --libs wlroots)			\
		$(shell pkg-config --cflags --libs wayland-server)	\
		$(shell pkg-config --cflags --libs xkbcommon)

# wayland-scanner is a tool which generates C headers and rigging for Wayland
# protocols, which are specified in XML. wlroots requires you to rig these up
# to your build system yourself and provide them in the include path.
xdg-shell-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		$(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@

tinywl: tinywl.c xdg-shell-protocol.h
	$(CC) $(CFLAGS) -o $@ $< $(LIBS) $(XWAYLAND)

clean:
	rm -f tinywl xdg-shell-protocol.h xdg-shell-protocol.c

.DEFAULT_GOAL=tinywl
.PHONY: clean
