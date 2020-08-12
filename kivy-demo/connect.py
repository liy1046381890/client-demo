from socket import *


class Client:
    def __init__(self, host: str, port: int, data: str, bufsize: int = 1024):
        self.host = host
        self.port = port
        self.data = data.encode('utf-8')
        self.bufsize = bufsize
        self.address = (self.host, self.port)

    def tcp(self):
        client = socket(AF_INET, SOCK_STREAM)
        client.connect(self.address)
        client.send(self.data)
        print(client.recv(1024).decode())
        client.close()

    def udp(self):
        client = socket(AF_INET, SOCK_DGRAM)
        client.sendto(self.data, self.address)
        # message, server = client.recvfrom(2048)
        # print(message.decode('utf-8'), server)
        client.close()


if __name__ == '__main__':
    Client('192.168.211.82', 5000, 'hello world').udp()
