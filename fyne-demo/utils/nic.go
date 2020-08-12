package utils

import (
	"fmt"
)

type Nic struct {
	ipv4 string
	mac string
}

func(n *Nic) GetIPv4() string {
	return n.ipv4
}

func(n *Nic) GetMac() string {
	return n.mac
}

func(n *Nic) ToString() string {
	return fmt.Sprintf("ipv4: %s, mac: %s\r\n", n.ipv4, n.mac)
}

func NewNic(ipv4 string, mac string) *Nic {
	return &Nic {
		ipv4: ipv4,
		mac: mac,
	}
}
