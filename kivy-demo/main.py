import kivy
from kivy.app import App
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.uix.screenmanager import RiseInTransition
from kivy.uix.popup import Popup
from nic import Nic
from connect import Client

kivy.require('1.11.0')


class LoginScreen(Screen):

    def login(self, _):  # instance
        if self.ids.username.text == "root" and self.ids.password.text == "123456":
            self.manager.current = 'display'
        else:
            MyPopup().open()


class DisplayScreen(Screen):

    def on_enter(self, *args):
        Client('192.168.211.82', 6000, Nic().to_json()).tcp()
        Client('192.168.211.82', 5000, Nic().to_json()).udp()


class MyPopup(Popup):
    ...


class MyApp(App):
    def build(self):
        self.title = '(^_^)'
        self.icon = 'data/icon.png'
        screen_manager = ScreenManager(transition=RiseInTransition())
        screen_manager.add_widget(LoginScreen())
        screen_manager.add_widget(DisplayScreen())
        return screen_manager


if __name__ == '__main__':
    MyApp().run()
