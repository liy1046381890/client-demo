package utils

import (
	// "fmt"
	"net"
	"errors"
)

func GetNics() ([]*Nic, error) {
	nics := make([]*Nic, 0, 4)
    ift, err := net.Interfaces()
    if err != nil {
        return nil, errors.New("fail to get interfaces")
    }

    for _, ifi := range ift {
		// fmt.Println(ifi)
		mac := ifi.HardwareAddr.String()
		if len(mac) == 0 {
			continue
		}

        ifat, err := ifi.Addrs()
        if err != nil {
			return nil, errors.New("fail to get ips")
        }
        
        for _, ifa := range ifat {
            if ifa, ok := ifa.(*net.IPNet); ok {
                if ifa.IP.IsGlobalUnicast() && ifa.IP.To4() != nil {
                    nics = append(nics, NewNic(ifa.IP.String(), mac))
                }
            }
        }
    }
    return nics, nil
}