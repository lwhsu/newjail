#!/bin/sh

ARCH=amd64
TARGET=amd64
VERSION=11.0-CURRENT

error() {
	if [ -n "$1" ]; then
		echo "ERROR: $1"
	fi
	exit 1
}


RELTYPE=`echo ${VERSION} | cut -d '-' -f 2 | tr "[:upper:]" "[:lower:]"`
if [ ${RELTYPE} = "current" ]; then
	RELTYPE=snapshots
else
	RELTYPE=releases
fi

DISTRIBUTIONS="base.txz"
echo ${TARGET} | grep 64 > /dev/null
if [ $? -eq 0 ]; then
	DISTRIBUTIONS="${DISTRIBUTIONS} lib32.txz"
fi

export DISTRIBUTIONS
export BSDINSTALL_DISTSITE="ftp://ftp0.twn.freebsd.org/pub/FreeBSD/${RELTYPE}/${ARCH}/${TARGET}/${VERSION}"
export BSDINSTALL_CHROOT="/j/jails/jail1"
export BSDINSTALL_DISTDIR="/tmp/freebsd-dist-${ARCH}-${TARGET}-${VERSION}"

mkdir -p ${BSDINSTALL_DISTDIR}
bsdinstall distfetch || error "Failed to fetch distribution"
bsdinstall checksum || error "Distribution checksum failed"

mkdir -p ${BSDINSTALL_CHROOT}
bsdinstall distextract || error "Distribution extract failed"

cp /etc/resolv.conf ${BSDINSTALL_CHROOT}/etc
