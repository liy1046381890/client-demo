import netifaces
import json


class Nic:
    def __init__(self):
        self.name = None
        self.mac = None
        self.ip = None
        self.netmask = None
        self.gateway = None
        self.__get_nic_info()

    def __get_nic_info(self):
        self.gateway, self.name = netifaces.gateways()['default'][netifaces.AF_INET]
        for interface in netifaces.interfaces():
            if interface == self.name:
                self.mac = netifaces.ifaddresses(interface)[netifaces.AF_LINK][0]['addr']
                self.ip = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['addr']
                self.netmask = netifaces.ifaddresses(interface)[netifaces.AF_INET][0]['netmask']

    def to_json(self):
        return json.dumps(self.__dict__)


if __name__ == '__main__':
    ...
