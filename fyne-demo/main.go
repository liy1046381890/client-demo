package main

import (
	"fmt"
	"fyne.io/fyne"
	"fyne.io/fyne/app"
	"fyne.io/fyne/layout"
	"fyne.io/fyne/widget"
	"io"
	"io/ioutil"
	"myappgo/utils"
	"net"
)

func login(a fyne.App) {
	myWin := a.NewWindow("login")

	username := widget.NewEntry()
	username.SetText("root")
	password := widget.NewPasswordEntry()
	password.SetText("123456")

	form := &widget.Form{
		Items: []*widget.FormItem{
			{Text: "username", Widget: username},
		},
		OnSubmit: func() {
			if username.Text == "root" && password.Text == "123456" {
				fmt.Println("Login")
				myWin.Hide()
				display(a)
				myWin.Close()
			} else {
				// wiget.ShowPopUp()
			}
		},
	}
	form.Append("password", password)
	myWin.SetContent(form)
	myWin.Resize(fyne.NewSize(600, 500))
	myWin.CenterOnScreen()
	myWin.Show()
}

func display(a fyne.App) {
	myWin := a.NewWindow("display")
	myWin.Resize(fyne.NewSize(600, 500))
	myWin.CenterOnScreen()
	logOut := widget.NewButton("login out", func() {
		myWin.Hide()
		login(a)
		myWin.Close()
	})

	nics, _ := utils.GetNics()

	var data string
	
	eths := make([]string, 0, 4)
	for _, nic := range nics {
		eths = append(eths, nic.GetMac())
		// fmt.Println(nic.ToString())
		data += nic.ToString()
	}

	ipLabel := widget.NewLabel("---")
	macLabel := widget.NewSelect(eths, func(mac string) {
		for _, nic := range nics {
			if nic.GetMac() == mac {
				ipLabel.SetText(nic.GetIPv4())
			}
		}
	})

	go func(data string) {
		if err := sendTo("192.168.211.82:6000", data, "tcp"); err != nil {
			fmt.Println(err)
		}
		if err := sendTo("192.168.211.82:5000", data, "udp"); err != nil {
			fmt.Println(err)
		}
	}(data)

	content := widget.NewVBox(layout.NewSpacer(), macLabel, ipLabel, layout.NewSpacer(), layout.NewSpacer(), logOut)
	myWin.SetContent(content)
	myWin.Show()
}

func sendTo(addr string, data string, mode string) error {
	conn, err := net.Dial(mode, addr)
	if err != nil {
		return fmt.Errorf("Error connect to server: %s\n", err)
	}
	defer conn.Close()
	
	if _, err := conn.Write([]byte(data)); err != nil {
		return fmt.Errorf("Error send data to server: %s\n", err)
	}
	fmt.Printf("Send: %s\n", data)

	resp := make([]byte, 512)
	respLen, err := conn.Read(resp)

	if err != nil && err != io.EOF {
		return fmt.Errorf("Response error: %s\n", err)
	}

	fmt.Println("Response: ", string(resp[:respLen]))

	return nil
}


func main() {
	myApp := app.New()
	content, _ := ioutil.ReadFile("data/icon.png")
	icon := &fyne.StaticResource{
		StaticName: "icon.png",
		StaticContent: content}
	myApp.SetIcon(icon)
	login(myApp)
	myApp.Run()
}

