# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/xboxdrv/xboxdrv-0.8.5-r1.ebuild,v 1.3 2013/07/27 22:23:37 ago Exp $

EAPI=5
inherit base linux-info scons-utils toolchain-funcs systemd

MY_P=${PN}-linux-${PV}
DESCRIPTION="Userspace Xbox 360 Controller driver"
HOMEPAGE="http://pingus.seul.org/~grumbel/xboxdrv/"
SRC_URI="http://pingus.seul.org/~grumbel/xboxdrv/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/boost
	virtual/udev
	sys-apps/dbus
	dev-libs/glib:2
	virtual/libusb:1
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="~INPUT_EVDEV ~INPUT_JOYDEV ~INPUT_UINPUT ~!JOYSTICK_XPAD"

#src_prepare() {
#	epatch "${FILESDIR}"/libusb_transfer_no_device.patch
#}

src_compile() {
	escons \
		BUILD=custom \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="-Wall ${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xboxdrv
	doman doc/xboxdrv.1
	dodoc AUTHORS NEWS PROTOCOL README TODO

	newinitd "${FILESDIR}"/xboxdrv.initd xboxdrv
	newconfd "${FILESDIR}"/xboxdrv.confd xboxdrv

	insinto $(systemd_get_userunitdir)
	doins "${FILESDIR}"/xboxdrv.service

	systemd_dounit "${FILESDIR}"/xboxdrv.service
}
