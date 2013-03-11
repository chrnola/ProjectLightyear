Project Lightyear
=========

A simple web server designed to be run on a [Raspberry Pi] in order to interface with an [Airphone Master Station C-ML] locally and/or over the Internet.

Status
---------------------

Still in development!

Installation
--------------

From a fresh install of [Raspbian on your Pi, you'll first need to install [node.js] and [npm], the node package manager.

```sudo apt-get install nodejs npm
```

Type in your password ("raspberry" by default) and wait a few. Next we're going to install [gpio-admin] so that we don't need to run our web server as root to be able to manipulate the Pi's [GPIO] pins. We'll use [Git] to get the latest version, so we'll have to install that real quick.

```sudo apt-get install git
```

Now we can proceed to install [gpio-admin].

```cd ~
mkdir projects
cd projects
git clone git://github.com/quick2wire/quick2wire-gpio-admin.git
cd quick2wire-gpio-admin
make
sudo make install
sudo adduser $USER gpio
```


This will create a separate gpio user group on your Pi that [gpio-admin] will use to determine who is allowed to access the GPIO pins. In order for this new group to take effect, you'll have to restart your session...or you could just reboot the Pi. ;)

```sudo reboot
```

Once your Pi comes back up, you can finally download the Project Lightyear source!

```cd ~/projects
git clone git://github.com/chrnola/ProjectLightyear.git
cd ProjectLightyear
```

Being that this project is bundled with a packages.json file, [npm] can use this to automatically download and install all the dependencies for you.

```npm install
```

Once those are all installed, you can start the server.

```nodejs server.js
```

By default, the server will be running on port 80, so pop open a web browser and type in your Pi's IP address or hostname to see it.

*Note: I will eventually be requiring SSL before deploying this in production...especially if it will be used over the Internet.*

To download newer versions of the code, you can simply do the following to avoid having to re-download the whole thing.

```cd ~/projects/ProjectLightyear
git update origin
npm install
```

I'll be documenting the physical circuit used to interface with the Airphone unit once it's actually been made. :-p

Until then this project still has quite a ways to go, so sit tight!

Credits
-----------------
This project would not be possible without all of the awesome things listed below.

* [node.js]
* [socket.io]
* [express]
* [pi-gpio]
* [jQuery]
* [Bootstrap]
* [Flat UI]
* [Raspberry Pi]
* [Raspbian]
* [gpio-admin]
* [Git]

License
--------------

MIT

Questions?
--------------
Feel free to contact me via Twitter: [@chrnola]

*Readme (easily) made with [Dillinger].*

  [node.js]: http://nodejs.org
  [socket.io]: http://socket.io
  [pi-gpio]: http://github.com/rakeshpai/pi-gpio
  [Bootstrap]: http://twitter.github.com/bootstrap/
  [jQuery]: http://jquery.com  
  [express]: http://expressjs.com
  [Dillinger]: http://dillenger.io
  [Flat UI]: http://designmodo.com/flat-free/
  [Airphone Master Station C-ML]: http://www.certifiedphonesolutions.com/Aiphone-Master-Station-C-ML-A-p/aipc-ml-fslash-a.htm
  [@chrnola]: http://twitter.com/chrnola
  [Raspberry Pi]: http://www.raspberrypi.org/
  [Raspbian]: http://www.raspbian.org/
  [gpio-admin]: http://github.com/quick2wire/quick2wire-gpio-admin
  [GPIO]: http://en.wikipedia.org/wiki/General_Purpose_Input/Output
  [Git]: http://git-scm.com
  [npm]: http://npmjs.org
    