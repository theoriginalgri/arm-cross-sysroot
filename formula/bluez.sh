#!/bin/bash

URL="http://www.kernel.org/pub/linux/bluetooth/bluez-5.18.tar.xz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--enable-threads"
	"--enable-library"
	"--disable-udev"
	"--disable-cups"
	"--disable-obex"
	"--disable-systemd"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -lc -lrt -ldl -lresolv -lncurses"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS
			
cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: Bluetooth library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lbluetooth
Cflags: -I\${includedir}
EOF
fi
