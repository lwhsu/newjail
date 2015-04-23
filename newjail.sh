#!/bin/sh

ARCH=amd64
TARGET=amd64
VERSION=11.0-CURRENT

RELTYPE=`echo ${VERSION} | cut -d '-' -f 2 | tr "[:upper:]" "[:lower:]"`
if [ ${RELTYPE} = "current" ]; then
	RELTYPE=snapshots
fi

DISTRIBUTIONS="base.txz"
echo ${TARGET} | grep 64 > /dev/null
if [ $? -eq 0 ]; then
	DISTRIBUTIONS="${DISTRIBUTIONS} lib32.txz"
fi

BSDINSTALL_DISTSITE="ftp://ftp0.twn.freebsd.org/pub/FreeBSD/${RELTYPE}/${ARCH}/${TARGET}/${VERSION}"
BSDINSTALL_CHROOT="/j/jails/jail1"
BSDINSTALL_DISTDIR="/tmp/freebsd-dist-${ARCH}-${TARGET}-${VERSION}"

mkdir -p ${BSDINSTALL_DISTDIR}
bsdinstall distfetch || error "Failed to fetch distribution"
bsdinstall checksum || error "Distribution checksum failed"

mkdir -p ${BSDINSTALL_CHROOT}
bsdinstall distextract || error "Distribution extract failed"

cp /etc/resolv.conf ${BSDINSTALL_CHROOT}/etc
