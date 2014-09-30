mage - README
=============================================

**mage** is an innovative project management tool for agile Scrum teams that uses and combines emerging technologies including interactive tabletops, wall displays, and mobile devices along with proven desktop technologies in a targeted manner to optimally support agile work processes. It has been developed in the context of the master's thesis *Innovative Tool Support for Agile Scrum Teams* by [Julian Maicher](http://twitter.com/jmaicher) at the [University of Paderborn](http://www.uni-paderborn.de).

# Architectural overview

The following figure gives an architectural overview about the developed prototype.

![Architectural Overview](Architecture.png). 

Conceptualized as a web site, the Desktop Interface is implemented as [Ruby on Rails](http://rubyonrails.org/)  application, which uses a [PostgreSQL](http://www.postgresql.org/) server as persistent database in the backend. The Mobile, Table, and Board Interface, on the other hand, are independently developed as Single Page Application (SPA) by using [AngularJS](https://angularjs.org/) and [Grunt](http://gruntjs.com/). Similar to the Desktop Interface, these web applications communicate over HTTP with the backend. In contrast, however, they solely rely on a JSON API to store and retrieve persistent information, which has been integrated into the Application Server.

In order to supply connected interfaces with most recent information as well as to connect these amongst each other, the backend is completed with a Real-time Application Server. This component is implemented in [Node.js](http://nodejs.org/) and uses the [Socket.IO](http://socket.io/) abstraction to communicate with connected clients over the [WebSocket protocol](http://tools.ietf.org/html/rfc6455). Thereby, not only bi-directional client-server communication is supported, but also the communication between two or more clients, which is a technical prerequisite for the interactive workspace application. Therefore, the real-time component acts as relay server and forwards client-client messages from the sender to one or more recipients. In order to further push information directly from the Application Server to connected clients, for instance when the status of a task has been updated, there is also a connection from the Application Server to the real-time server. Without further elaboration, this communication is enabled via an internal API relying on HTTP and JSON.

## Folder structure


The folder structure and how it corresponds to the architecture is outlined in the following.

```
|- mage/  	- Root directory
  |- db/   	- Configuration files for the PostgreSQL database server
  |- mage/	- Application directory
    |- mage-desktop  - Rails application for the Desktop Interface and Application Server
    |- mage-mobile   - SPA for the Mobile Interface
    |- mage-table    - SPA for the Table Interface
    |- mage-board    - SPA for the Board Interface
    |- mage-shared   - Shared code for all SPAs
    |- mage-reactive - Node.js server for the real-time component
    |- mage-env      - Configuration files for the virtual development environment
```

# Getting started

In the remaining, it is explained how to run the prototype and how to get started with the development. In order to simplify the technical setup, a virtual development environment has been created with [vagrant](https://www.vagrantup.com/) and [docker](https://www.docker.com/), which automatically installs all dependencies and lets you run and develop mage in a virtual machine (vm).

**Note**: This guide assumes a UNIX-based host system (OS X or Linux)

In order to get started, install [vagrant](https://www.vagrantup.com/) (v1.6.3 has been used during the development of this thesis), open a terminal, go to the root directory, and start the virtual development environment. 


```
 [host] $ vagrant up
```

Assuming you do this for the first time, this will set up a virtual machine (64-bit Ubuntu 12.04 LTS) and automatically install all of the dependencies. For detailed information, take a look at the `Vagrantfile`, in particular at the therein contained provisioning section.

Thereafter, you can log from the host into the vm (guest) and go to the [mounted](https://docs.vagrantup.com/v2/synced-folders/basic_usage.html) application directory.

```
 [host] $ vagrant ssh
[guest] $ cd /mage
```

Given you do this for the first time, you must further install some application-specific dependencies manually.

```
[guest] $ bundle install && npm install
```

## Desktop Interface and Application Server

Thereafter, you can run the Application Server and the Desktop Interface by starting the Rails application server.

```
[guest] $ cd /mage/mage-desktop
[guest] $ bundle install                 
[guest] $ bundle exec rake db:setup
[guest] $ bundle exec rake s
```

In order to access the Desktop Interface, it should be available at [http://127.0.0.1:3000](http://127.0.0.1:3000) in a browser. You can find available logic credentials in `/mage/mage/mage-desktop/db/seeds.rb`.

In case there are any problems with the database, please take a look at the next section.

## Database Server

The PostgreSQL server is generally automatically started and managed by vagrant and runs in a docker container in the background. The configuration file used for the Postgres server can be found at `mage/db/postgresql.conf`.

In case there are any problems, the container can be (re-)started with the following command:

```
[guest] $ docker start mage_db
```

If there is no container with such name, a new container can be generated and started with the following command:

```
[guest] $ docker run -d -p 5432:5432 --name mage_db mage/db
```

For more information, please take a look at the [docker documentation](http://docs.docker.com/userguide/dockerimages/) for how to (re-)start and stop docker containers from images.


**Note**: In case the Database Server is restarted while the Rails application runs, you have to restart the Rails server as well.

## Real-time Application Server

In order to run the Real-time Application Server, open a new terminal, ssh into the vm, install the npm dependencies, and start the Node.js server as follows:

```
[guest] $ cd /mage/mage-reactive/
[guest] $ npm install
[guest] $ nodemon server.js
```

## Mobile, Table, and Board Interface

Given the Rails and Node server are both started, you can start the Mobile, Table, and Board Interface. As a prerequisite therefore, open a new terminal, shh into the vm, and build the shared libraries first.

```
$ cd /mage/mage-shared
$ grunt build
```

Thereafter, you can start the development server for the Mobile Interface as follows:

```
$ cd /mage/mage-mobile
$ grunt dev
```

The Mobile Interface can then be accessed via [http://127.0.0.1:5000](http://127.0.0.1:5000) from the host machine.

Alternatively, I recommend to modify the `/etc/hosts` file on your host to include the following:

```
127.0.0.1 mage.dev, table.mage.dev, mobile.mage.dev, board.mage.dev, reactive.mage.dev
```

Thereafter, the Mobile Interface is also accessible via [http://mobile.mage.dev:3000/](http://mobile.mage.dev:3000).

**Note**: During development chrome/chromium has been used. Since the HTML5 technologies used for the SPAs are fairly new, there may be problems with other browsers.

In order to run the Table and Board Interface, open two new terminals and run the same commands to start the respective development servers:

```
$ cd /mage/mage-table
$ grunt dev
```

And for the Board Interface:

```
$ cd /mage/mage-board
$ grunt dev
```

Thereafter, the different interfaces and servers can be accessed from the host as follows:

```
Interface/Server  |		   IP/Port 	         |    Hostname
----------------------------------------------------------------------------
mage-desktop 	  | http://127.0.0.1:3000    | http://mage.dev:3000
mage-mobile 	  | http://127.0.0.1:5000    | http://mobile.mage.dev:3000
mage-table 		  | http://127.0.0.1:4000    | http://table.mage.dev:3000
mage-board 		  | http://127.0.0.1:7000    | http://board.mage.dev:3000
mage-reactive 	  | http://127.0.0.1:9999    | http://reactive.mage.dev:3000
```

During development, I strongly recommend the use of [tmux](http://tmux.sourceforge.net/) with [tmuxinator](https://github.com/tmuxinator/tmuxinator) or similar to automate parts of the previously described process. It quickly gets annoying when you always have to open all the terminal sessions and ssh into the guest vm manually. tmux, a terminal multiplexer, combined with tmuxinator can simplify this by automating the setup. A sample configuration for tmuxinator can be found here: `/mage/mage.tmux.yml`.

# Development

Since the `mage` folder is [mounted](https://docs.vagrantup.com/v2/synced-folders/basic_usage.html) into the guest machine and [automatically synced](https://docs.vagrantup.com/v2/synced-folders/basic_usage.html), you can edit the source files with any editor on the host machine while the development servers run inside the guest. Awesome, isn't it? :-)

With respect to the SPAs, the grunt development server (`grunt dev`) is change aware and automatically compiles [coffee](http://coffeescript.org/) and [sass](http://sass-lang.com/) files upon change. Moreover, it incorporates live reload functionality. That means, when you change a source file, the browser should automatically reload with the updated files.

# Deployment

In order to build the Mobile, Table, and Board Interface for deployment, there is a `grunt build` task. The build thereafter apperas in the dist/ folder, for instance `/mage/mage-mobile/dist`, and can be served by ordinary web servers, for example [nginx](http://nginx.org/). A sample configuration for nginx can be found at `mage/mage/mage-env/provision/nginx/mage.prod`, which also includes entries for the Rails and the Node server. 


Similar to the development environment, the production environment needs to have all dependencies such as Postgre installed. In order to avoid having to set up everything manually, there are docker container for the database (`mage/db/Dockerfile`) and the application (`mage/mage/Dockerfile`), which automate this process and allow to run the prototype from any server where [docker](https://www.docker.com/) is installed.

Without further elaboration, you can build and start the containers as follows:

```
$ cd mage/db/
$ docker build -t mage/db .
$ cd mage/mage
$ docker build -t mage/app .

$ docker run -d -p 5432:5432 --name mage_db mage/db
$ docker run -d --link mage_db:mage_db -p 8000:80 --name mage_app mage/app
```
Alternatively, you can also utilize the shell scripts at `mage/mage/mage-env/provision` to provision a production (or development) server manually. Prerequisite therefor is a 64-bit Ubuntu 12.04 LTS system.
  
---

# License

**The MIT License**

Copyright (c) 2014 Julian Maicher

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
